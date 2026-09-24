import Flutter
import UIKit
import AsliOCR

@main
@objc class AppDelegate: FlutterAppDelegate, OcrViewControllerDelegate {
    
    var ocrResult: String? // Menyimpan hasil ocr
    var flutterResult: FlutterResult? // Menyimpan referensi ke FlutterResult
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(
                name: "com.asliri.demo/ocr",
                binaryMessenger: controller.binaryMessenger
            )

            channel.setMethodCallHandler { [weak self, weak controller] (call, result) in
                guard let controller = controller else { return }
                switch call.method {
                case "startOcr":
                    self?.flutterResult = result
                    self?.startOcr(controller: controller)
                case "getResult":
                    if let ocrResult = self?.ocrResult {
                        result(ocrResult)
                    } else {
                        result(FlutterError(code: "NO_RESULT", message: "No ocr result available", details: nil))
                    }
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        return result
    }
    
    private func startOcr(controller: FlutterViewController) {
        DispatchQueue.main.async {
            let ocrVC = OcrViewController()
            ocrVC.delegate = self
            
            // Tambahkan gesture swipe kanan
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissOcr))
            swipeRight.direction = .right
            ocrVC.view.addGestureRecognizer(swipeRight)
            
            let nav = UINavigationController(rootViewController: ocrVC)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen // Tetap Full Screen 100%
            controller.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc private func dismissOcr() {
        DispatchQueue.main.async { [weak self] in
            self?.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didCompleteOcr(result: String) {
        self.ocrResult = result
        if let flutterResult = self.flutterResult {
            flutterResult(result)
            self.flutterResult = nil
        }
        
        dismissOcr()
    }
}
