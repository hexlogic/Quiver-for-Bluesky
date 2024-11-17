import SwiftUI

struct ImageCarousel: View {
    let images: [EmbedImageModel]
    
    var body: some View {
        PhotoCarousel(imageUrls: images.map {
            URL(string: $0.fullsize ?? "https://via.placeholder.com/40x40")!
        }, aspectRatio: CGSize(width: images.first?.aspectRatio?.width ?? 0, height: images.first?.aspectRatio?.height ?? 0))
    }
}
