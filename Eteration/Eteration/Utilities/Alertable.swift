//
//  Alertable.swift
//  OzanSuperApp
//
//  Created by Tolga Taner on 20.03.2025.
//

import UIKit.UIViewController

protocol Alertable { }
extension Alertable where Self: UIViewController {
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
