//
//  LivenessViewController.swift
//  Runner
//
//  Created by Putra Rolli on 14/01/25.
//
import Foundation
import AsliPassiveLiveness
import UIKit

protocol LivenessViewControllerDelegate: AnyObject {
    func didCompleteLiveness(result: String)
}

class LivenessViewController : ContainerViewController {
    
    var controller: AsliPassiveLivenessViewController?
    weak var delegate: LivenessViewControllerDelegate?
    
    init() {
        controller = AsliPassiveLivenessViewController.create(token: "4cdfb7dd-b690-45db-8f0c-e5a8c0813d1a")
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

extension LivenessViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension LivenessViewController: AsliPassiveLivenessViewControllerDelegate {
    func didLivenessSuccess(image: UIImage, result: Bool) {
        showDialog(result: result)
    }
    
    func didLivenessFailure(code: Int, errorMessage: String) {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.didCompleteLiveness(result: "\(errorMessage)")
    }
    
    func didTapRetake() {
        controller?.start()
    }
    
    func showDialog(result: Bool) {
        let alert = UIAlertController(title: "Sukses", message: "\(result)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didCompleteLiveness(result: "\(result)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
