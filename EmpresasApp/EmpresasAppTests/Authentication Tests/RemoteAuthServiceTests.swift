//
//  RemoteAuthService.swift
//  EmpresasAppTests
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest

class RemoteAuthService {

    let client: HTTPClient
    let endpointURL: URL
    
    var headers: [String: String] = ["Content-Type":"application/json"]
    
    var body: [String:String] = ["email":"email_test@email.com",
                                 "password":"123"]
    
    
    init(endpointURL: URL, client: HTTPClient) {
        self.client = client
        self.endpointURL = endpointURL
    }
    
    func authenticate(email: String, password: String) {
        self.setupHeaders(email: email, password: password)
        client.post(to: endpointURL)
    }
    
    private func setupHeaders(email: String, password: String) {
        self.body["email"] = email
        self.body["password"] = password
    }
}

protocol HTTPClient {
    func post(to url: URL)
}

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
    
    func test_authenticate_withEmailPasswordIntoBody() {
        let (sut,_) = makeSUT()
        let email = "email@email.com"
        let password = "123123"
        
        sut.authenticate(email: email, password: password)
        
        XCTAssertEqual(sut.body,["email": email,"password":password])
        
        
    }
   
    
    // MARK: - Helpers
    private func makeSUT(endpointURL: URL = URL(string: "https://test-authentication.com")! ) -> (sut: RemoteAuthService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteAuthService(endpointURL: endpointURL,client: client)
        return (sut,client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var endpointURL: URL?
        
        func post(to url: URL) {
            self.endpointURL = url
        }
    }
    
}

