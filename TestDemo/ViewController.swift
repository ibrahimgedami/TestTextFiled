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

        // Test cases
        print(isValidString("Hello123"))  // Valid: Alphanumeric and length is at least 1
        print(isValidString("12345"))     // Valid: Only numeric characters and length is at least 1
        print(isValidString("AbCdEf"))    // Valid: Only alphabetic characters and length is at least 1
        print(isValidString("Special@"))  // Invalid: Contains a special character
        print(isValidString(""))
        print(isValidString("12345643$&"))
    }
    
    func isValidString(_ input: String) -> Bool {
        let regex = "^[A-Za-z0-9]{1,}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: input)
    }

    
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        

    }
    
}

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
}
