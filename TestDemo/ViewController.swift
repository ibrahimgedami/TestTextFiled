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
    
    private var hostingController: UIHostingController<ChartTest>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let components = toDate(inputFormatterString: "d-MMM-yyyy", outputFormatterString: "yyyy-MM-dd", dateString: "1-Dec-2023")
        if let day = components?.day, let month = components?.month, let year = components?.year {
            print("Day: \(day), Month: \(month), ?Year: \(year)")
        }

        guard let stackView = stackView else { return }
        hostingController = UIHostingController(rootView: ChartTest())
        if let hostingController {
            addChild(hostingController)
            stackView.addArrangedSubview(hostingController.view)
            hostingController.didMove(toParent: self)
            hostingController.view.isHidden = true
        }
        
    }
    
    func toDate(inputFormatterString: String?, outputFormatterString: String?, dateString: String) -> DateComponents? {
        let dateString = dateString//"1-Dec-2023"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormatterString
        dateFormatter.locale = Locale(identifier: "en_US")
        
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = outputFormatterString //
        let formattedDate = outputDateFormatter.string(from: date)
        
        guard let newDate = outputDateFormatter.date(from: formattedDate) else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        return components
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
