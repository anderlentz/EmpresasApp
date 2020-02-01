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
    
    var requestURL: URLRequest
    let client: EnterpriseHTTPClient
    
    init(endpointURL: URL,client: EnterpriseHTTPClient) {
        self.requestURL = URLRequest(url: endpointURL)
        self.client = client
    }
    
    func getAllEnterprises() {
        requestURL.allHTTPHeaderFields = makeHeader()
        client.get(from: requestURL) { _ in}
    }
    
    private func makeHeader() -> [String: String] {
        return ["access-token":"",
                "client": "",
                "uid":""]
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
    
    func test_getAllEnterprises_requestWithAllRequideAuthenticationKeysIntoHTTPResquestHeader() {
        
        var requestURL = URLRequest(url: makeEndpointURL())
        requestURL.httpMethod = "GET"
        requestURL.allHTTPHeaderFields = ["access-token":"",
                                          "client":"",
                                          "uid":""]
        let (sut,client) = makeSUT(endpointURL: makeEndpointURL())
       
        sut.getAllEnterprises()
                
        XCTAssertNotNil(client.urlRequest?.value(forHTTPHeaderField: "access-token"),"Must have an access-token property at header")
        XCTAssertNotNil(client.urlRequest?.value(forHTTPHeaderField: "client"),"Must have a client property at header")
        XCTAssertNotNil(client.urlRequest?.value(forHTTPHeaderField: "uid"),"Must have an uid property at header")
        
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
    
    private func makeGetEnterprisesURLRequest() -> URLRequest {
        
        var urlRequest = URLRequest(url: makeEndpointURL())
        let headers = ["access-token":"",
        "client":"",
        "uid":""]
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}
