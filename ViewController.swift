import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {

    private var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentController = WKUserContentController()
        contentController.add(self, name: "swiftToJsChannel")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        webView = WKWebView(frame: self.view.frame, configuration: config)
        self.view.addSubview(webView)

        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sendDataToJavaScript()
    }

    func sendDataToJavaScript() {
        let data = "Hello from Swift!"
        let script = "receiveDataFromSwift('\(data)')"
        webView.evaluateJavaScript(script, completionHandler: nil)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "swiftToJsChannel" {
            print("Received message from JavaScript: \(message.body)")
        }
    }
}
