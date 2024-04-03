import SwiftUI

public struct WebViewPage: View {
   public let url: String
    @StateObject private var webViewStore = WebViewStore()
    
    public init(url: String) {
        self.url = url
    }
    
    public var body: some View {
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

public extension View {
    
    @available(iOS 16.4, *)
    func browse(url: String, show: Binding<Bool>) -> some View {
        self
            .sheet(isPresented: show) {
                WebViewPage(url: url)
                    .greedyFrame()
                    .ignoresSafeArea()
                    .background(Color.hex(0xF6F6F5).night(.hex(0x222222)))
                    .presentationCornerRadius(32)
                    .presentationDragIndicator(.visible)
            }
    }
}

struct WebViewPage_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.yellow.greedyFrame()
        }
        .ignoresSafeArea()
        .browse(url: "https://github.com", show: .constant(true))
    }
}
