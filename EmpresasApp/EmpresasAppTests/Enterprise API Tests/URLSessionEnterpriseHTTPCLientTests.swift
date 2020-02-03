//
//  URLSessionEnterpriseHTTPCLientTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

class URLSessionEnterpriseHTTPCLientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_get_performsGETFromURLRequest() {
        let exp = expectation(description: "Wait for request")
        
        let urlRequest = URLRequest(url: anyEndpointURL())
        
        URLProtocolStub.observeRquests { [weak self] request in
            XCTAssertEqual(request.url, self?.anyEndpointURL())
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: urlRequest) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> URLSessionEnterpriseHTTPCLient {
        return URLSessionEnterpriseHTTPCLient()
    }
    
    private func anyEndpointURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func makeURLRequest() -> URLRequest {
        let urlRequest = URLRequest(url: anyEndpointURL())
        return urlRequest
    }
    
}
