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
       
        let (_,viewModel) = makeSUT()
        
        XCTAssertEqual(viewModel.isLogging, false)
    }
    
    func test_viewDidLoad_doesNotAttemptToLogin() {
        
        let (sut,viewModel) = makeSUT()
        
        sut.loadViewIfNeeded()

        XCTAssertEqual(viewModel.isLogging, false)
    }
    
    func test_userInitiateLogin_expectStartAndStopLogginIndicator() {

        let (sut,viewModel) = makeSUT()
       
        var expectedIndicatorStatus = [Bool]()
        let exp = expectation(description: "Waits for initiate login")
        exp.expectedFulfillmentCount = 2
        
        viewModel.onLogginStateChange = {isLogging in
            expectedIndicatorStatus.append(isLogging)
            exp.fulfill()
        }
        
        sut.simulateUserInitiateLogin()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(expectedIndicatorStatus, [true,false])
        
    }
    
    func test_userInitiateLogin_startsToLoggingAndStopLoggingAffterHTTPClientError() {
        let (sut,viewModel) = makeSUT()
       
        var receivedLoginStatus: [Bool] = [Bool]()
        
        let exp = expectation(description: "Waits for initiate login and terminate on an http client error")
        exp.expectedFulfillmentCount = 2
        viewModel.onLogginStateChange = {isLogging in
            receivedLoginStatus.append(isLogging)
            exp.fulfill()
        }
        
        sut.simulateUserInitiateLogin()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedLoginStatus, [true,false])
    }
    
    // MARK: - Helpers

    private func makeSUT() -> (sut: LoginViewController,viewModel: LoginViewModel) {
        let remoteAuthService = RemoteAuthService(endpointURL: HTTPClientSpy.endpointURL, client: HTTPClientSpy())
        let viewModel = LoginViewModel(authenticationService: remoteAuthService)
        let vc = LoginUIComposer.loginComposedWith(viewModel: viewModel, coodinator: LoginCoordinatorSpy(navigationController: nil))
        return (vc,viewModel)
        
    }
    
    class HTTPClientSpyWithError: HTTPClient {
        
        var message: ((Result<(Data,HTTPURLResponse), Error>) -> Void) = { _ in}
        
        func post(to postRequest: URLRequest,
                  completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void){
            let errorResult: Result<(Data,HTTPURLResponse), Error> = .failure(NSError(domain:"Test",code:0))
            completion(errorResult)
        }

    }
    
    private class LoginCoordinatorSpy: LoginCoordinator {
        
    }
}

private extension LoginViewController {
    func simulateUserInitiateLogin() {
        viewModel?.doLogin(email: "email", password: "senha")
    }
}






