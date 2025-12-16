import SwiftUI

public struct WebViewPage: View {
  public let url: String
  @StateObject private var webViewStore: WebViewStore

  public init(url: String, mailtoClicked: ((String) -> Void)? = nil) {
    self.url = url
    let webView = FullScreenWKWebView()
    self._webViewStore = StateObject(wrappedValue: WebViewStore(webView: webView))
    webView.mailToClicked = mailtoClicked
  }

    public var body: some View {
        WebView(webView: webViewStore.webView)
        .overlay {
          if self.webViewStore.isLoading {
            ProgressView()
              .scaleEffect(1.2)
          }
        }
#if os(iOS)
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
#else
            .navigationTitle(webViewStore.title ?? "")
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        webViewStore.webView.goBack()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(!webViewStore.canGoBack)

                    Button {
                        webViewStore.webView.goForward()
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!webViewStore.canGoForward)
                }
            }
#endif
            .onAppear {
                if let url = self.url.url {
                    self.webViewStore.webView.load(URLRequest(url: url))
                }
            }
    }

}

public extension View {

  func browse(url: String, show: Binding<Bool>, mailtoClicked: ((String) -> Void)? = nil) -> some View {
    self
      .sheet(isPresented: show) {
        WebViewPage(url: url, mailtoClicked: mailtoClicked)
          .greedyFrame()
          .ignoresSafeArea()
          .background(Color.hex(0xF6F6F5).night(.hex(0x222222)))
#if os(iOS)
          .presentationCornerRadius(32)
          .presentationDragIndicator(.visible)
#endif
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
