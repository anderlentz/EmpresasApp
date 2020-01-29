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

        sut.authenticate(email: email, password: password)

        XCTAssertEqual(client.endpointURL,endpointURL)
    }
    
    func test_authenticate_resquestwithEmailPasswordIntoBody() {
        let (sut,_) = makeSUT()
        let email = "email@email.com"
        let password = "123123"
        
        sut.authenticate(email: email, password: password)
        
        XCTAssertEqual(sut.body,["email": email,"password":password])
        
    }
    
    func test_authenticate_deliversErrorOnClientConnectivityError() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        client.error = NSError(domain:"Test",code:0)
        
        var capturedError: RemoteAuthService.Error?
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        XCTAssertEqual(capturedError,.connectivity)
    }
    
    // MARK: - Helpers
    private func makeSUT(endpointURL: URL = URL(string: "https://test-authentication.com")! ) -> (sut: RemoteAuthService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteAuthService(endpointURL: endpointURL,client: client)
        return (sut,client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var endpointURL: URL?
        var error: Error?
        
        func post(to url: URL,completion: @escaping (Error) -> Void) {
            self.endpointURL = url
            
            if let error = error {
                completion(error)
            }
        }
    }
    
}

