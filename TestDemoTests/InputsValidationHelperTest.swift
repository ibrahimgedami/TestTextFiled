//
//  InputsValidationHelperTest.swift
//  TestDemoTests
//
//  Created by Ibrahim Gedami on 18/10/2023.
//

import XCTest
@testable import TestDemo

final class InputsValidationHelperTests: XCTestCase {
    
    private var helperUnderTest: InputsValidationHelperProtocol?

    override func setUp() {
        super.setUp()
        helperUnderTest = InputsValidationHelper()
    }
    
    override func tearDownWithError() throws {
        helperUnderTest = nil
    }
    
    private func testSubstitutedIfExceptionValueExistPatternFound() {
        let valueWithPattern = "This is 8666 test"
        let resultWithPattern = helperUnderTest?.substitutedIfExceptionValueExist(valueWithPattern)
        XCTAssertEqual(resultWithPattern, "(PrefixSubstituted)This is 8666 test")
    }
    
    private func testSubstitutedIfExceptionValueExistPatternNotFound() {
        let valueWithoutPattern = "Mohammed Ahmed"
        let resultWithoutPattern = helperUnderTest?.substitutedIfExceptionValueExist(valueWithoutPattern)
        XCTAssertEqual(resultWithoutPattern, "Pattern is not found")
    }
    
}
