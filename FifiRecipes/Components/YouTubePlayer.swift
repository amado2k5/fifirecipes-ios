import SwiftUI
import WebKit

/// Fullscreen-capable YouTube player. Loads the privacy-enhanced
/// youtube-nocookie.com embed — no tracking on our side; see README.
struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let web = WKWebView(frame: .zero, configuration: config)
        web.scrollView.isScrollEnabled = false
        web.isOpaque = false
        web.backgroundColor = .black
        return web
    }

    func updateUIView(_ web: WKWebView, context: Context) {
        guard let url = URL(
            string: "https://www.youtube-nocookie.com/embed/\(videoID)?rel=0&playsinline=1")
        else { return }
        if web.url != url { web.load(URLRequest(url: url)) }
    }
}

/// Sheet content: player + "Open in YouTube" secondary action.
struct VideoSheet: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.dismiss) private var dismiss
    let video: VideoItem

    var body: some View {
        NavigationStack {
            YouTubePlayerView(videoID: video.id)
                .background(.black)
                .navigationTitle(video.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(app.s[.close]) { dismiss() }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        if let url = URL(string: "https://www.youtube.com/watch?v=\(video.id)") {
                            Link(app.s[.openInYouTube], destination: url)
                        }
                    }
                }
        }
    }
}
