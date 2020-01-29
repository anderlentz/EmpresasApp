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
    
    func authenticate() {
        client.post(to: URL(string: "https://test-authentication.com")!)
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
}

protocol HTTPClient {
    func post(to url: URL)
}

class HTTPClientSpy: HTTPClient {
    
    var endpointURL: URL?
    
    func post(to url: URL) {
        self.endpointURL = url
    }
}

class RemoteAuthServiceTests: XCTestCase {
    
    func test_init_doesNotRequestAuthenticationDataFromEndpoint() {
        let client = HTTPClientSpy()
        _ = RemoteAuthService(client: client)
        
        XCTAssertNil(client.endpointURL)
    }
    
    func test_authenticate_requestDataFromEndpointURL() {
        let client = HTTPClientSpy()
        let sut = RemoteAuthService(client: client)

        sut.authenticate()

        XCTAssertNotNil(client.endpointURL)
    }
   
    
}

