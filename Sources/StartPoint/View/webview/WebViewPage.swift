import SwiftUI

struct WebViewPage: View {
    let url: String
    @StateObject private var webViewStore = WebViewStore()

    var body: some View {
        WebView(webView: webViewStore.webView)
            .navigationBarTitle(Text(verbatim: webViewStore.title ?? ""), displayMode: .inline)
            .navigationBarItems(trailing: HStack {
                Button {
                    webViewStore.webView.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                }
                .disabled(!webViewStore.canGoBack)

                Button {
                    webViewStore.webView.goForward()
                } label: {
                    Image(systemName: "chevron.right")
                        .imageScale(.large)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                }
                .disabled(!webViewStore.canGoForward)
            })
            .onAppear {
                if let url = self.url.url {
                    self.webViewStore.webView.load(URLRequest(url: url))
                }
            }
    }

}

struct WebViewPage_Previews: PreviewProvider {
    static var previews: some View {
        WebViewPage(url: "https://github.com")
    }
}
