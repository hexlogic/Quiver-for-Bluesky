import SwiftUI

struct FeedThreadView: View {
    typealias ProfileHandler = (String) -> Void
    typealias PostTapHandler = (String) -> Void
    
    private let onProfileTap: ProfileHandler
    private let onPostTap: PostTapHandler
    
    
    let feedItem: FeedItemModel
    
    init(feedItem: FeedItemModel, onProfileTap: @escaping ProfileHandler, onPostTap: @escaping PostTapHandler) {
        self.onProfileTap = onProfileTap
        self.feedItem = feedItem
        self.onPostTap = onPostTap
    }
    

    
    var body: some View {
        VStack(alignment: .leading) {
            Color.clear.frame(height: 0)
            
            if feedItem.reason != nil && feedItem.reason?.type == "app.bsky.feed.defs#reasonRepost" {
                HStack {
                    Color.clear.frame(width: 40)
                    Text("Reposted by \(feedItem.reason?.by?.displayName ?? "Unknown")")
                        .font(.caption)
                        .onTapGesture {
                            onProfileTap(feedItem.reason?.by?.did ?? "")
                        }
                }
            }
            
            if feedItem.reply?.parent != nil {
                MainPostView(post: feedItem.reply?.parent, onProfileTap: onProfileTap, isParent: true, onPostTap: onPostTap)
            }
            
            MainPostView(post: feedItem.post, onProfileTap: onProfileTap, onPostTap: onPostTap)
            Color.clear.frame(height: 0)
        }
    }
}

struct MainPostView: View {
    let post: PostModel?
    let isParent: Bool
    
    typealias ProfileHandler = (String) -> Void
    typealias PostTapHandler = (String) -> Void
    
    private let onProfileTap: ProfileHandler
    private let onPostTap: PostTapHandler
    
    init(post: PostModel?, onProfileTap: @escaping ProfileHandler, isParent: Bool = false, onPostTap: @escaping PostTapHandler) {
        self.post = post
        self.onProfileTap = onProfileTap
        self.isParent = isParent
        self.onPostTap = onPostTap
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .center) {
                AsyncImage(url: URL(string: post?.author?.avatar ?? "https://via.placeholder.com/40x40")!) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .foregroundStyle(.orange.opacity(0.5))
                } placeholder: {
                    Color.gray
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .foregroundStyle(.orange.opacity(0.5))
                }
                .onTapGesture {
                    onProfileTap(post?.author?.did ?? "")
                }
                if isParent {
                    Color.orange.frame(width: 2)
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(post?.author?.displayName ?? "Unknown")")
                            .minimumScaleFactor(0.5)
                            .truncationMode(.middle)
                            .lineLimit(1)
                            .font(.headline)
                        Text("@\(post?.author?.handle ?? "Unknown")")
                            .fontWeight(.thin)
                            .font(.footnote)
                    }
                    
                    Spacer()
                    Text("\(TimeAgo.timeAgo(from: TimeAgo.convertDate(from: post?.record?.createdAt) ?? Date()))")
                        .font(.headline)
                        .fontWeight(.light)
                }
                
                VStack(alignment: .leading) {
                    FacetedText(text: "\(post?.record?.text ?? "Unknown")", facets: post?.record?.facets ?? []) { did in
                        onProfileTap(did)
                    } tagTapHandler: { tag in
                        print("Tag tapped: \(tag)")
                    }
                    
                    //                    Text("\(feedItem.post?.record?.text ?? "Unknown")")
                    
                    if post?.embed?.images != nil {
                        ImageCarousel(images: post!.embed!.images!)
                    }
                    
                    if post?.embed?.externalBSViewModel != nil {
                        LinkPreviewView(
                            external: post?.embed?.externalBSViewModel
                        )
                    }
                    
                    if post?.embed?.type == "app.bsky.embed.record#view" {
                        if post?.embed?.record?.type == "app.bsky.graph.defs#listView" {
                            ModlistEmbed(embed: post?.embed)
                        } else {
                            PostEmbed(embed: post?.embed, onPostTap: onPostTap)
                        }
                        
                    }
                    
                    if post?.embed?.type == "app.bsky.embed.video#view" {
                        HLSPlayerView(link: (post?.embed?.playlist!)!, aspectRatio: (post?.embed?.aspectRatio!)!)
                    }
                }
                .onTapGesture {
                    if let uri = post?.uri {
                        onPostTap(uri)
                    }
                }
                PostActionsView(post: post)
                Color.clear.frame(height: 4)
            }
        }
    }
}

struct ModlistEmbed: View {
    private let embed: EmbedModel?
    
    init(embed: EmbedModel?) {
        self.embed = embed
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: embed?.record?.avatar ?? "https://via.placeholder.com/40x40")!) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .foregroundStyle(.orange.opacity(0.5))
                } placeholder: {
                    Color.gray
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .foregroundStyle(.orange.opacity(0.5))
                }
                VStack(alignment: .leading) {
                    Text("\(embed?.record?.name ?? "Unknown")")
                        .truncationMode(.middle)
                        .lineLimit(1)
                        .font(.caption)
                    Text("Moderation list by @\(embed?.record?.creator?.handle ?? "Unknown")")
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
                Spacer()
            }
            Text("\(embed?.record?.description ?? "Unknown")")
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 8))
    }
}

struct PostEmbed: View {
    
    let embed: EmbedModel?
    
    typealias PostTapHandler = (String) -> Void
    
    var onPostTap: PostTapHandler
    
    var body : some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: embed?.record?.author?.avatar ?? "https://via.placeholder.com/40x40")!) { image in
                    image
                        .resizable()
                        .frame(width: 15, height: 15)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .foregroundStyle(.orange.opacity(0.5))
                } placeholder: {
                    Color.gray
                        .frame(width: 15, height: 15)
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .foregroundStyle(.orange.opacity(0.5))
                }
                VStack(alignment: .leading) {
                    Text("\(embed?.record?.author?.displayName ?? "Unknown")")
                        .minimumScaleFactor(0.5)
                        .truncationMode(.middle)
                        .lineLimit(1)
                        .font(.caption)
                    Text("@\(embed?.record?.author?.handle ?? "Unknown")")
                        .fontWeight(.thin)
                        .font(.caption)
                }
                
                Spacer()
                Text("\(TimeAgo.timeAgo(from: TimeAgo.convertDate(from: embed?.record?.value?.createdAt) ?? Date()))")
                    .font(.caption)
                    .fontWeight(.light)
            }
            
            Text("\(embed?.record?.value?.text ?? "Unknown")")
                .font(.system(size: 12))
            
            
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange, lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture {
            onPostTap(embed?.record?.uri ?? "")
        }
    }
}


struct FacetedText: View {
    typealias ScreenNavigationHandler = (String) -> Void
    
    let text: String
    let facets: [FacetModel]
    
    let profileTapHandler: ScreenNavigationHandler
    let tagTapHandler: ScreenNavigationHandler
    
    
    private func buildAttributedString() -> AttributedString {
        var attributedString = AttributedString(text)
        
        // Convert byte ranges to character ranges
        guard let textData = text.data(using: .utf8) else { return attributedString }
        
        for facet in facets {
            // Convert byte offsets to string indices
            guard let startIndex = String(data: textData.prefix(facet.index?.byteStart ?? 0), encoding: .utf8)?.count,
                  let endIndex = String(data: textData.prefix(facet.index?.byteEnd ?? 0), encoding: .utf8)?.count,
                  startIndex <= text.count,
                  endIndex <= text.count else {
                continue
            }
            
            let startStringIndex = text.index(text.startIndex, offsetBy: startIndex)
            let endStringIndex = text.index(text.startIndex, offsetBy: endIndex)
            
            guard let attributedStartIndex = AttributedString.Index(startStringIndex, within: attributedString),
                  let attributedEndIndex = AttributedString.Index(endStringIndex, within: attributedString) else {
                continue
            }
            let range = attributedStartIndex..<attributedEndIndex
            
            // Apply link attributes
            attributedString[range].foregroundColor = .orange
            attributedString[range].underlineStyle = .none
            let feature = facet.features?.first
            if feature?.type == "app.bsky.richtext.facet#mention" {
                let did = feature?.did
                attributedString[range].mentionAttributes.mention = did
                
                if let mentionURL = URL(string: "mention://profile/\(did ?? "")") {
                    attributedString[range].link = mentionURL
                }
            } else if feature?.type == "app.bsky.richtext.facet#tag" {
                let tag = feature?.tag
                attributedString[range].mentionAttributes.mention = tag
                
                if let tagURL = URL(string: "tag://\(tag ?? "")") {
                    attributedString[range].link = tagURL
                }
            }
            
            else {
                attributedString[range].link = URL(string: facet.features?.first?.uri ?? "")
            }
        }
        
        return attributedString
    }
    
    var body: some View {
        Text(buildAttributedString())
            .environment(\.openURL, OpenURLAction(handler: { url in
                if url.scheme == "mention" {
                    if let did = url.pathComponents.last {
                        profileTapHandler(did)
                    }
                    return .handled
                }
                if url.scheme == "tag" {
                    if let tag = url.pathComponents.last {
                        tagTapHandler(tag)
                    }
                    return .handled
                }
                return .systemAction
            }))
    }
}

private extension AttributeScopes {
    struct MentionAttributes: AttributeScope {
        let mention: MentionAttribute
    }
    
    var mentionAttributes: MentionAttributes.Type { MentionAttributes.self }
    
    struct TagAttributes: AttributeScope {
        let tag: TagAttribute
    }
    
    var tagAttributes: TagAttribute.Type { TagAttribute.self }
}

private struct MentionAttribute: AttributedStringKey {
    static let name = "mention"
    typealias Value = String
}

private struct TagAttribute: AttributedStringKey {
    static let name = "tag"
    typealias Value = String
}


