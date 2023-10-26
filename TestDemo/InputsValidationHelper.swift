//
//  InputsValidationHelper.swift
//  TestDemo
//
//  Created by Ibrahim Gedami on 18/10/2023.
//

import Foundation

protocol InputsValidationHelperProtocol {
    func substitutedIfExceptionValueExist(_ value: String) -> String
}

class InputsValidationHelper: InputsValidationHelperProtocol {
    
    func substitutedIfExceptionValueExist(_ value: String) -> String {
        let pattern = "8666" // The regular expression pattern
        guard (value.range(of: pattern, options: .regularExpression) != nil) else { return value }
        let substitutedValue = "(PrefixSubstituted)\(value)"
        return substitutedValue
    }
    
}

