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
    
    func test_doLogin_withValidEmailAndEmptyPasswordProducesFormattedErrorMessage() {
        let sut = makeSUT()
        var expectedErrorMessage: String?
        
        let exp = expectation(description: "Wait for error login message")
        sut.onLoginValidationError = { errorMessage in
            expectedErrorMessage = errorMessage
            exp.fulfill()
        }
        
        sut.doLogin(email: validEmail(), password: emptyPassword())
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(expectedErrorMessage,makeFormattedEmptyPasswordErrorMessage())
        
    }
    
    func test_doLogin_withValidEmailAndWhitespacePasswordProducesFormattedErrorMessage() {
        let sut = makeSUT()
        var expectedErrorMessage: String?
        
        let exp = expectation(description: "Wait for error login message")
        sut.onLoginValidationError = { errorMessage in
            expectedErrorMessage = errorMessage
            exp.fulfill()
        }
        
        sut.doLogin(email: validEmail(), password: makePasswordWithWhiteSpace())
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(expectedErrorMessage,makeFormattedWhiteSpacePasswordErrorMessage())
        
    }
    
    func test_doLogin_withValidPasswordAndIncorrectEmailsProducesFormattedErrorMessages() {
        let sut = makeSUT()
        var expectedErrorMessages = [String]()
        
        let exp = expectation(description: "Wait for error login message")
        exp.expectedFulfillmentCount = 8
        sut.onLoginValidationError = { errorMessage in
            expectedErrorMessages.append(errorMessage)
            exp.fulfill()
        }
        
        sut.doLogin(email: "a.com", password: validPassword())
        sut.doLogin(email: "a@test", password: validPassword())
        sut.doLogin(email: "a@test.", password: validPassword())
        sut.doLogin(email: "@test.", password: validPassword())
        sut.doLogin(email: "com", password: validPassword())
        sut.doLogin(email: "a.", password: validPassword())
        sut.doLogin(email: "", password: validPassword())
        sut.doLogin(email: " ", password: validPassword())
        
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(expectedErrorMessages[0],LoginViewModel.ErrorMessage.onInvalidEmail.rawValue)
        XCTAssertEqual(expectedErrorMessages[1],LoginViewModel.ErrorMessage.onInvalidEmail.rawValue)
        XCTAssertEqual(expectedErrorMessages[2],LoginViewModel.ErrorMessage.onInvalidEmail.rawValue)
        XCTAssertEqual(expectedErrorMessages[3],LoginViewModel.ErrorMessage.onInvalidEmail.rawValue)
        XCTAssertEqual(expectedErrorMessages[4],LoginViewModel.ErrorMessage.onInvalidEmail.rawValue)
        XCTAssertEqual(expectedErrorMessages[5],LoginViewModel.ErrorMessage.onInvalidEmail.rawValue)
        XCTAssertEqual(expectedErrorMessages[6],LoginViewModel.ErrorMessage.onEmptyEmail.rawValue)
        XCTAssertEqual(expectedErrorMessages[7],LoginViewModel.ErrorMessage.onInvalidEmail.rawValue)
        
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
    
    func makePasswordWithWhiteSpace() -> String {
        return " "
    }
    func emptyPassword() -> String {
        return ""
    }
    
    func makeFormattedEmptyPasswordErrorMessage() -> String {
        return "Password não pode ser vazio."
    }
    
    func makeFormattedWhiteSpacePasswordErrorMessage() -> String {
        return "Password não pode conter espaços."
    }
}
