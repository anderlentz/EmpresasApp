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
        
        sut.doLogin(email: "", password: "12341234")
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(expectedErrorMessage)
        
    }
    
    
    // MARK: - Helpers
    func makeSUT() -> LoginViewModel {
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        return LoginViewModel(authenticationService: remoteAuthService)
    }
}
