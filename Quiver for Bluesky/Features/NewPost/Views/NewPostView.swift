import SwiftUI

struct NewPostView: View {
        
    @Environment(\.dismiss) var dismiss
    
    typealias OnPostCreated = () -> Void
    @State private var text = ""
    let maxLength = 300
    
    let onPostCreated: OnPostCreated
    
    private var isOverLimit: Bool {
        text.count > maxLength
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                Spacer()
                Button("Post") {
                    onPostCreated()
                }
            }
            TextField("What's up?", text: $text, axis: .vertical)
            .lineLimit(5...10)
            .onChange(of: text) { newValue in
                if newValue.count > maxLength {
                    text = String(newValue.prefix(maxLength))
                }
            }
            .padding(.vertical)
            Spacer()
            HStack {
                Image(systemName: "photo")
                Color.clear.frame(width: 4, height: 0)
                Image(systemName: "video")
                Color.clear.frame(width: 4, height: 0)
                Image(systemName: "camera")
                Color.clear.frame(width: 4, height: 0)
                Text("GIF")
                    .bold()
                Spacer()
                Text("\(text.count)/\(maxLength)")
                    .bold()
                    .foregroundColor(isOverLimit ? .red : .gray)
            }
        }
        .padding()
    }
}

#Preview {
    NewPostView() {
        
    }
}
