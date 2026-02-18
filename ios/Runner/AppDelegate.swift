import Flutter
import UIKit
import AsliPassiveLiveness

@main
@objc class AppDelegate: FlutterAppDelegate, LivenessViewControllerDelegate {
    
    var windows: UIWindow?
    var livenessResult: String? // Menyimpan hasil liveness
    var flutterResult: FlutterResult? // Menyimpan referensi ke FlutterResult untuk dikembalikan nanti
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Ambil FlutterViewController sebagai root view controller
        let flutterViewController = FlutterViewController()
        
        // Bungkus FlutterViewController dalam UINavigationController
        let navigationController = UINavigationController(rootViewController: flutterViewController)
        navigationController.navigationBar.isHidden = true
        // Tetapkan UINavigationController sebagai rootViewController dari window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        // Membuat FlutterMethodChannel untuk komunikasi
        let channel = FlutterMethodChannel(
            name: "com.asliri.demo/liveness",
            binaryMessenger: flutterViewController.binaryMessenger
        )

        // Tangani metode dari Flutter
        channel.setMethodCallHandler { [weak self] (call, result) in
            switch call.method {
            case "startLiveness":
                self?.flutterResult = result // Simpan referensi ke result
                self?.startLiveness(controller: flutterViewController, result: result)
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

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func startLiveness(controller: FlutterViewController, result: @escaping FlutterResult) {
        let livenessVC = LivenessViewController()
        livenessVC.navigationItem.hidesBackButton = true
        livenessVC.delegate = self // Tetapkan delegate
        // Pastikan controller berada dalam UINavigationController
        guard let navigationController = controller.navigationController else {
            result(FlutterError(code: "NAVIGATION_ERROR", message: "No UINavigationController found", details: nil))
            return
        }
        navigationController.isNavigationBarHidden = true
        // Push LivenessViewController ke dalam stack navigasi
        navigationController.pushViewController(livenessVC, animated: true)
    }
    
    func didCompleteLiveness(result: String) {
        self.livenessResult = result
        // Kirim kembali hasil ke Flutter melalui FlutterResult
        if let flutterResult = self.flutterResult {
                flutterResult(result)
                self.flutterResult = nil // Bersihkan setelah dipanggil
        }
    }
}
