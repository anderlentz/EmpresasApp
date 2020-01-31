//
//  LoginViewControllerTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

class LoginViewControllerTests: XCTestCase {
    
    func test_init_doesNotAtemptToLogin() {
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        let viewModel = LoginViewModelSpy()
        
        _ = LoginUIComposer.loginComposedWith(viewModel: viewModel, authenticationService: remoteAuthService)
        
        XCTAssertEqual(viewModel.logginCount, 0)
    }
    
    func test_viewDidLoad_doesNotAttemptToLogin() {
        let sut = LoginViewController()
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(viewModelSpy.logginCount, 0)
    }
    
    func test_userInitiateLogin_showsLogginIndicator() {
        let sut = LoginViewController()
        let viewModelSpy = LoginViewModelSpy()
        sut.viewModel = viewModelSpy
        
        let exp = expectation(description: "Waits for initiate login")
        viewModelSpy.onLogginStateChange = {isLogging in
            XCTAssertEqual(isLogging, true)
            exp.fulfill()
        }
        
        sut.simulateUserInitiateLogin()
        
        wait(for: [exp], timeout: 1.0)
        
    
    }
    
    // MARK: - Helpers
    private func makeSUT() -> LoginViewController {
        
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        return LoginUIComposer.loginComposedWith(viewModel: LoginViewModelSpy(), authenticationService: remoteAuthService)
        
    }
    
    // MARK: - LoginViewModelSpy class
    private class LoginViewModelSpy: LoginViewModelProtocol {
        var onLogginStateChange: ((Bool) -> Void)?
        var onInvestorLogin: ((Investor) -> Void)?
        var onChange: ((LoginViewModel) -> Void)?

        var logginCount = 0
        func doLogin(email: String, password: String) {
            onLogginStateChange?(true)
            logginCount += 1
            print("Do login")
        }
    }
    
}

private extension LoginViewController {
    func simulateUserInitiateLogin() {
        viewModel?.doLogin(email: "email", password: "senha")
    }
}





