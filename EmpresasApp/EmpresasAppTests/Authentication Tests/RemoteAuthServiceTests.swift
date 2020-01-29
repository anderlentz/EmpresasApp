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
    
    init(endpointURL: URL, client: HTTPClient) {
        self.client = client
        self.endpointURL = endpointURL
    }
    
    func authenticate() {
        client.post(to: endpointURL)
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
        let (sut,client) = makeSUT(endpointURL: endpointURL)

        sut.authenticate()

        XCTAssertEqual(client.endpointURL,endpointURL)
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

