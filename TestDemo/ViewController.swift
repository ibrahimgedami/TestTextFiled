//
//  ViewController.swift
//  TestDemo
//
//  Created by Ibrahim Gedami on 18/10/2023.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    @IBOutlet weak var customView: UIView?
    @IBOutlet weak var stackView: UIStackView?
    
    private var hostingController: UIHostingController<MySwiftUIView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let stackView = stackView else { return }
        hostingController = UIHostingController(rootView: MySwiftUIView())
        if let hostingController {
            addChild(hostingController)
            stackView.addArrangedSubview(hostingController.view)
            hostingController.didMove(toParent: self)
            hostingController.view.isHidden = true
        }
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            guard let hostingIsHidden = self.hostingController?.view.isHidden else { return }
            self.hostingController?.view.alpha = hostingIsHidden ? 1 : 0.5
            self.hostingController?.view.transform = hostingIsHidden ? .identity : CGAffineTransform(scaleX: 0.9, y: 0.9)

            guard let customViewIsHidden = self.customView?.isHidden else { return }
            self.customView?.alpha = customViewIsHidden ? 1 : 0.5
            self.customView?.transform = customViewIsHidden ? .identity : CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            self.hostingController?.view.isHidden.toggle()
            self.customView?.isHidden.toggle()
        })

    }
    
}

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
}
