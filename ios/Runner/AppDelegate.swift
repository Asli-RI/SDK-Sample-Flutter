import Flutter
import UIKit
import AsliPassiveLiveness

@main
@objc class AppDelegate: FlutterAppDelegate, LivenessViewControllerDelegate {
    
    var livenessResult: String? // Menyimpan hasil liveness
    var flutterResult: FlutterResult? // Menyimpan referensi ke FlutterResult untuk dikembalikan nanti
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let controller = window?.rootViewController as? FlutterViewController {
            // Membuat FlutterMethodChannel untuk komunikasi
            let channel = FlutterMethodChannel(
                name: "com.asliri.demo/liveness",
                binaryMessenger: controller.binaryMessenger
            )

            // Tangani metode dari Flutter
            channel.setMethodCallHandler { [weak self, weak controller] (call, result) in
                guard let controller = controller else { return }
                switch call.method {
                case "startLiveness":
                    self?.flutterResult = result // Simpan referensi ke result
                    self?.startLiveness(controller: controller, result: result)
                case "getResult":
                    if let livenessResult = self?.livenessResult {
                        result(livenessResult)
                    } else {
                        result(FlutterError(code: "NO_RESULT", message: "No liveness result available", details: nil))
                    }
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }

        return result
    }
    
    private func startLiveness(controller: FlutterViewController, result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            let livenessVC = LivenessViewController()
            livenessVC.delegate = self // Tetapkan delegate
            
            let nav = UINavigationController(rootViewController: livenessVC)
            nav.isNavigationBarHidden = true
            nav.modalPresentationStyle = .fullScreen
            
            controller.present(nav, animated: true, completion: nil)
        }
    }
    
    func didCompleteLiveness(result: String) {
        self.livenessResult = result
        // Kirim kembali hasil ke Flutter melalui FlutterResult
        if let flutterResult = self.flutterResult {
            flutterResult(result)
            self.flutterResult = nil // Bersihkan setelah dipanggil
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

