//
//  RemoteAuthService.swift
//  EmpresasAppTests
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
import EmpresasApp


class RemoteAuthServiceTests: XCTestCase {
    
    func test_init_doesNotRequestAuthenticationDataFromEndpoint() {
        let (_,client) = makeSUT()
        
        XCTAssertNil(client.endpointURL)
    }
    
    func test_authenticate_requestDataFromEndpointURL() {
        let endpointURL = URL(string: "https://test-authentication.com")!
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT(endpointURL: endpointURL)

        sut.authenticate(email: email, password: password){ _ in }

        XCTAssertEqual(client.endpointURL,endpointURL)
    }
    
    func test_authenticate_resquestwithEmailPasswordIntoBody() {
        let (sut,_) = makeSUT()
        let email = "email@email.com"
        let password = "123123"
        
        sut.authenticate(email: email, password: password){ _ in }
        
        XCTAssertEqual(sut.body,["email": email,"password":password])
        
    }
    
    func test_authenticate_deliversErrorOnClientConnectivityError() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: RemoteAuthService.Error?
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        let clientError = NSError(domain:"Test",code:0)
         client.complete(whith: clientError)
        
        XCTAssertEqual(capturedError,.connectivity)
    }
    
    func test_authentication_deliversUnauthorizedErrorOn401HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: RemoteAuthService.Error?
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        client.complete(whithStatusCode: 401)
        
        XCTAssertEqual(capturedError, .unauthorized)
    }
    
    func test_authentication_deliversBadRequestOn400HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: RemoteAuthService.Error?
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        client.complete(whithStatusCode: 400)
        
        XCTAssertEqual(capturedError, .badRequest)
    }
    
    func test_authentication_deliversForbiddenErrorOn403HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: RemoteAuthService.Error?
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        client.complete(whithStatusCode: 403)
        
        XCTAssertEqual(capturedError, .forbidden)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(endpointURL: URL = URL(string: "https://test-authentication.com")! ) -> (sut: RemoteAuthService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteAuthService(endpointURL: endpointURL,client: client)
        return (sut,client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var endpointURL: URL?
        var message: ((Error?,HTTPURLResponse?) -> Void) = { _,_  in}
        
        func post(to url: URL,completion: @escaping (Error?,HTTPURLResponse?) -> Void) {
            self.endpointURL = url
            self.message = completion
        }
        
        func complete(whith error: Error) {
            message(error, nil)
        }
        
        func complete(whithStatusCode code: Int) {
            let response = HTTPURLResponse(url: endpointURL!,
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)
            message(nil,response)
        }
    }
    
}

