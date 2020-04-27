//
//  DocumentViewController.swift
//  assign4
//
//  Created by Josh on 4/25/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import UIKit

class CirclesViewController: UIViewController, UIGestureRecognizerDelegate {
    

    @IBOutlet var circleView: CircleView!
    
    var circlesDocument: CirclesDocument?
    
    @objc func doTap(recog: UITapGestureRecognizer) {
        let loc = recog.location(in: view)
        circlesDocument?.container?.circles.append(Circle(c: loc, r: 100))
        circleView.setNeedsDisplay()
        circlesDocument?.updateChangeCount(.done)
    }
    
    @objc func doTapExit(recog: UITapGestureRecognizer) {
        dismiss(animated: true) {
            self.circlesDocument?.close(completionHandler: nil)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return ((gestureRecognizer == self.tapRecog) && (otherGestureRecognizer == self.doubleTapRecog))
    }
    
    var tapRecog: UITapGestureRecognizer!
    var doubleTapRecog: UITapGestureRecognizer!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        circlesDocument?.open(completionHandler: { (success) in
            if success {
                if let container = self.circlesDocument?.container {
                    self.circleView.circleContainer = container
                    self.circleView.setNeedsDisplay()
                    
                    self.tapRecog = UITapGestureRecognizer(target: self, action: #selector(self.doTap))
                    self.tapRecog.numberOfTapsRequired = 1
                    self.circleView.addGestureRecognizer(self.tapRecog)
                    self.tapRecog.delegate = self
                
                    self.doubleTapRecog = UITapGestureRecognizer(target: self, action: #selector(self.doTapExit))
                    self.doubleTapRecog.numberOfTapsRequired = 2
                   self.view.addGestureRecognizer(self.doubleTapRecog)

                }
            } else {
                self.presentWarningWith(title: "Error", message: "Document can't be viewed.") {
                    self.dismiss(animated: true)
                }
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.circlesDocument?.close(completionHandler: nil)
        }
    }
}


extension UIViewController {
    
    // MARK: - Factories
    
    /// Returns an alert controller with the passed title and message.
    func makeAlertWith(title: String, message: String) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    // MARK: - Imperatives
    
    /// Presents a warning alert with the provided title and message.
    func presentWarningWith(title: String, message: String, handler: Optional<() -> ()> = nil) {
        let alert = makeAlertWith(title: title, message: message)
        _ = alert.addActionWith(title: "Ok", style: .default)
        
        present(alert, animated: true, completion: handler)
    }
}

extension UIAlertController {
    
    // MARK: - Imperatives
    
    /// Adds a new alert action to the alert controller.
    func addActionWith(title: String, style: UIAlertAction.Style = .default, handler: Optional<(UIAlertAction) -> Swift.Void> = nil) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        addAction(action)
        
        return action
    }
}
