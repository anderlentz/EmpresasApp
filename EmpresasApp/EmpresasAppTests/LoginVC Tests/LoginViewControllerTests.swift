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
        let viewModel = LoginViewModel(authenticationService: remoteAuthService)
        
        _ = LoginUIComposer.loginComposedWith(viewModel: viewModel)
        
        XCTAssertEqual(viewModel.isLogging, false)
    }
    
    func test_viewDidLoad_doesNotAttemptToLogin() {
        let sut = LoginViewController()
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        let viewModel = LoginViewModel(authenticationService: remoteAuthService)
        sut.viewModel = viewModel
        
        sut.loadViewIfNeeded()

        XCTAssertEqual(viewModel.isLogging, false)
    }
    
    func test_userInitiateLogin_showsLogginIndicator() {
        let sut = LoginViewController()
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        let viewModel = LoginViewModel(authenticationService: remoteAuthService)
        sut.viewModel = viewModel
        
        let exp = expectation(description: "Waits for initiate login")
        viewModel.onLogginStateChange = {isLogging in
            XCTAssertEqual(isLogging, true)
            exp.fulfill()
        }
        
        sut.simulateUserInitiateLogin()
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    func test_userInitiateLogin_startsToLoggingAndStopLoggingAffterHTTPClientError() {
        let sut = LoginViewController()
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpyWithError())
        let viewModel = LoginViewModel(authenticationService: remoteAuthService)
        sut.viewModel = viewModel
        var receivedLoginStatus: [Bool] = [Bool]()
        
        let exp = expectation(description: "Waits for initiate login and terminate on an http client error")
        exp.expectedFulfillmentCount = 2
        viewModel.onLogginStateChange = {isLogging in
            print("isLogging: \(isLogging)")
            receivedLoginStatus.append(isLogging)
            exp.fulfill()
        }
        
        sut.simulateUserInitiateLogin()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedLoginStatus, [true,false])
    }
    
    // MARK: - Helpers
//    private func makeSUT() -> LoginViewController {
//
//        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
//        let viewModel = LoginViewModel(authenticationService: remoteAuthService)
//        return LoginUIComposer.loginComposedWith(viewModel: viewModel, authenticationService: remoteAuthService)
//
//    }
    
    class HTTPClientSpyWithError: HTTPClient {
        
        var message: ((Result<(Data,HTTPURLResponse), Error>) -> Void) = { _ in}
        
        func post(to postRequest: URLRequest,
                  completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void){
            let errorResult: Result<(Data,HTTPURLResponse), Error> = .failure(NSError(domain:"Test",code:0))
            completion(errorResult)
        }
        
//        func complete(whith error: Error) {
//            let result: Result<(Data,HTTPURLResponse), Error> = .failure(error)
//            message(result)
//        }
    }
    
}

private extension LoginViewController {
    func simulateUserInitiateLogin() {
        viewModel?.doLogin(email: "email", password: "senha")
    }
}






