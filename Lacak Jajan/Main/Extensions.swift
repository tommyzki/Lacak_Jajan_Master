//
//  Extensions.swift
//  Lacak Jajan
//
//  Created by Tommy Miyazaki on 6/6/17.
//  Copyright © 2017 Tommyzki. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(_ message: String?, title: String?) {
        self.showAlert(message, title: title, okAction: nil)
    }
    func showAlert(_ message: String?, title: String?, okAction: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            okAction?()
            alert.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    func showAlert(_ message: String?, title: String?, okAction: (() -> Void)?, cancelAction: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            okAction?()
            alert.presentingViewController?.dismiss(animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            cancelAction?()
        })
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
