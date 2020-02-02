//
//  LoginViewModelTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp
class LoginViewModelTests: XCTestCase {
    
    func test_doLogin_withInvalidEmailAndPasswordMustReturnNonNilLoginValidationErrorMessage() {
        let sut = makeSUT()
        var expectedErrorMessage: String?
        
        let exp = expectation(description: "Wait for error login message")
        sut.onLoginValidationError = { errorMessage in
            expectedErrorMessage = errorMessage
            exp.fulfill()
        }
        
        sut.doLogin(email: "", password: "")
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(expectedErrorMessage)
    }
    
    func test_doLogin_withEmptyEmailAndCorrectPasswordMustReturnLoginValidationErrorMessage() {
        let sut = makeSUT()
        var expectedErrorMessage: String?
        
        let exp = expectation(description: "Wait for error login message")
        sut.onLoginValidationError = { errorMessage in
            expectedErrorMessage = errorMessage
            exp.fulfill()
        }
        
        sut.doLogin(email: "", password: validPassword())
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(expectedErrorMessage)
        
    }
    
    func test_doLogin_withEmptyPasswordAndValidEmailMustReturnLoginValidationErrorMessage() {
        let sut = makeSUT()
        var expectedErrorMessage: String?
        
        let exp = expectation(description: "Wait for error login message")
        sut.onLoginValidationError = { errorMessage in
            expectedErrorMessage = errorMessage
            exp.fulfill()
        }
        
        sut.doLogin(email: validEmail(), password: "")
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(expectedErrorMessage)
        
    }
    
    
    
    
    // MARK: - Helpers
    func makeSUT() -> LoginViewModel {
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        return LoginViewModel(authenticationService: remoteAuthService)
    }
    
    func validEmail() -> String {
        return "test@test.com"
    }
    
    func validPassword() -> String {
        return "12341234"
    }
    
    func passwordWithWhiteSpace() -> String {
        return " 1212 1"
    }
}
