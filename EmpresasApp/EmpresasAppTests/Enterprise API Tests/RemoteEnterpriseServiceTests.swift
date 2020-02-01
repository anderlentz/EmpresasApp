//
//  RemoteEnterpriseServiceTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

protocol EnterpriseService {
    func getAllEnterprises()
}

protocol EnterpriseHTTPClient {
    func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void)
}

class RemoteEnterpriseService: EnterpriseService {
    
    let requestURL: URLRequest
    let client: EnterpriseHTTPClient
    
    init(endpointURL: URL,client: EnterpriseHTTPClient) {
        self.requestURL = URLRequest(url: endpointURL)
        self.client = client
    }
    
    func getAllEnterprises() {
        client.get(from: requestURL) { _ in}
    }
}

class RemoteEnterpriseServiceTests: XCTestCase {

    func test_init_constructsGetRequestToEndpointURL() {
        let endpointURL = makeEndpointURL()
        
        let (sut,_) = makeSUT(endpointURL: endpointURL)
        
        XCTAssertEqual(sut.requestURL.url, endpointURL)
        XCTAssertEqual(sut.requestURL.httpMethod, "GET")
    }
    
    func test_getAllEnterprise_performGETrequestToEndpointURL() {
        
        var requestURL = URLRequest(url: makeEndpointURL())
        requestURL.httpMethod = "GET"
        let (sut,client) = makeSUT(endpointURL: makeEndpointURL())
        
        sut.getAllEnterprises()
        
        XCTAssertEqual(client.urlRequest?.url, makeEndpointURL())
        XCTAssertEqual(client.urlRequest?.httpMethod, "GET")
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(endpointURL: URL) -> (sut: RemoteEnterpriseService, client: EnterpriseHTTPClientSpy) {
        let client = EnterpriseHTTPClientSpy()
        let sut = RemoteEnterpriseService(endpointURL: endpointURL,client: client)
        return (sut,client)
    }
    
    private func makeEndpointURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    private class EnterpriseHTTPClientSpy: EnterpriseHTTPClient {
        var urlRequest: URLRequest?
        
        func get(from urlRequest: URLRequest,completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void) {
            self.urlRequest = urlRequest
        }
    }
}
