import SwiftUI
import AVKit
import AVFoundation

struct HLSPlayerView: View {
    @StateObject private var playerViewModel = PlayerViewModel()
    private var link: String
    private var aspectRatio: AspectRatioModel
    
    
    init(link: String, aspectRatio: AspectRatioModel) {
        self.link = link
        self.aspectRatio = aspectRatio
    }
    
    var body: some View {
        VStack {
            // Video Player
            VideoPlayer(player: playerViewModel.player)
                .aspectRatio(CGSize(width: (aspectRatio.width ?? 0), height: (aspectRatio.height ?? 0)), contentMode: .fill)
                .overlay(
                    Group {
                        if playerViewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                )
        }
        .onAppear {
            // Start playing when view appears
            playerViewModel.setupPlayer(with: link)
        }
        .onDisappear {
            // Cleanup when view disappears
            playerViewModel.cleanup()
        }
    }
}

class PlayerViewModel: ObservableObject {
    let player = AVPlayer()
    @Published var isPlaying = false
    @Published var isLoading = true
    @Published var isMuted = true
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    
    private var timeObserver: Any?
    private var itemObservation: NSKeyValueObservation?
    
    func setupPlayer(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
        // Set initial muted state
        player.isMuted = true
        
        
        // Setup audio session
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        // Auto-play when ready
        itemObservation = playerItem.observe(\.status) { [weak self] item, _ in
            DispatchQueue.main.async {
                self?.isLoading = item.status != .readyToPlay
                if item.status == .readyToPlay {
                    self?.play()  // Start playing automatically
                }
            }
        }
        
        // Add time observer
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { [weak self] time in
            self?.currentTime = time.seconds
        }
    }
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player.seek(to: cmTime)
    }
    
    func toggleMute() {
        isMuted.toggle()
        player.isMuted = isMuted
    }

    
    func cleanup() {
        pause()
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
        itemObservation?.invalidate()
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}

struct PlayerControlsView: View {
    @ObservedObject var viewModel: PlayerViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Progress Slider
            Slider(
                value: Binding(
                    get: { viewModel.currentTime },
                    set: { viewModel.seek(to: $0) }
                ),
                in: 0...max(viewModel.duration, 1)
            )
            .disabled(viewModel.isLoading)
            
            // Time Labels
            HStack {
                Text(timeString(from: viewModel.currentTime))
                Spacer()
                Text(timeString(from: viewModel.duration))
            }
            .font(.caption)
            
            // Control Buttons
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.seek(to: max(0, viewModel.currentTime - 10))
                }) {
                    Image(systemName: "gobackward.10")
                        .font(.title2)
                }
                
                Button(action: {
                    if viewModel.isPlaying {
                        viewModel.pause()
                    } else {
                        viewModel.play()
                    }
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                }
                
                Button(action: {
                    viewModel.seek(to: min(viewModel.duration, viewModel.currentTime + 10))
                }) {
                    Image(systemName: "goforward.10")
                        .font(.title2)
                }
                
                Button(action: {
                    viewModel.toggleMute()
                }) {
                    Image(systemName: viewModel.isMuted ? "speaker.slash.fill" : "speaker.fill")
                        .font(.title2)
                }
            }
            .disabled(viewModel.isLoading)
        }
        .padding()
    }
    
    private func timeString(from seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
