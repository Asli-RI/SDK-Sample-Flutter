//
//  OcrViewController.swift
//  Runner
//
//  Created by Putra Rolli on 14/01/25.
//
import Foundation
import AsliOCR
import UIKit

protocol OcrViewControllerDelegate: AnyObject {
    func didCompleteOcr(result: String)
}

class OcrViewController : ContainerViewController {
    
    var controller: AsliOCRViewController?
    weak var delegate: OcrViewControllerDelegate?
    
    init() {
        controller = AsliOCRViewController.create(token: "4cdfb7dd-b690-45db-8f0c-e5a8c0813d1a")
        super.init(viewController: controller!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller?.delegate = self
        controller?.start()
        
        if let gesture = self.navigationController?.interactivePopGestureRecognizer {
            gesture.isEnabled = true
            gesture.delegate = self
        }
    }
    
}

extension OcrViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension OcrViewController: AsliOCRViewControllerDelegate {
    func didScanSuccess(image: UIImage, ocr: NSDictionary) {
        let resultString = "Success: \(ocr)"
        self.dismiss(animated: true) {
            self.delegate?.didCompleteOcr(result: resultString)
        }
    }
    
    func didScanFailure(code: Int, errorMessage: String) {
        self.dismiss(animated: true) {
            self.delegate?.didCompleteOcr(result: "Failed: \(code) - \(errorMessage)")
        }
    }
    
    func didRetryScan() {
        
    }
    
    func didTapRetake() {
        controller?.start()
    }
    
    func showDialog(result: Bool) {
        let alert = UIAlertController(title: "Sukses", message: "\(result)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.didCompleteOcr(result: "\(result)")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
