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
        
    }
    
    // MARK: - Helpers
    private func makeSUT() -> LoginViewController {
        
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        return LoginUIComposer.loginComposedWith(viewModel: LoginViewModelSpy(), authenticationService: remoteAuthService)
        
    }
    
    
    // MARK: - LoginViewModelSpy class
    private class LoginViewModelSpy: LoginViewModelProtocol {

        func doLogin(email: String, password: String) {
            
        }
    }
    
}







