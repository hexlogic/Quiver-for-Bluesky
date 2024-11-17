import SwiftUI

struct LinkPreviewView: View {
    let external: ExternalBSViewModel?
    @Environment(\.openURL) var openURL
    
    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                // If image exists
                if(external?.thumb != nil)
                {
                    AsyncImage(url: URL(string: external!.thumb!)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("\(external?.title ?? "")")
                        .font(.headline)
                        .lineLimit(1...10)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(URL(string: external?.uri ?? "")?.host() ?? "")
                        .font(.caption)
                }
                .padding(8)
            }
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture {
            if let url = URL(string: external?.uri ?? "") {
                openURL(url)
            }
        }
        
    }
}
