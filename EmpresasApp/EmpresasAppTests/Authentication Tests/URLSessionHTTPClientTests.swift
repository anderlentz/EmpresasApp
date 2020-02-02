//
//  URLSessionHTTPClientTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_postToURL_performsPOSTRequestWithURL() {
        
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRquests { [weak self] request in
            XCTAssertEqual(request.url, self?.anyEndpointURL())
            XCTAssertEqual(request.httpMethod, "POST")
            exp.fulfill()
        }
        
        makeSUT().post(to: makePostURLRequest()) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_postUrlRequest_failsOnRequestError() {
        let error = NSError(domain: "ANY ERROR", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let exp = expectation(description: "Wait for completion")
        
        makeSUT().post(to: makePostURLRequest()) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_post_failsOnAllNilValues() {
        URLProtocolStub.stub(data: nil, response: nil, error: nil)
        
        let exp = expectation(description: "Wait for completion")
        
        makeSUT().post(to: makePostURLRequest()) { result in
            switch result {
            case .failure:
               break
            default:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    private func makeSUT() -> URLSessionHTTPClient {
        return URLSessionHTTPClient()
    }
    
    private func anyEndpointURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func makePostURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: anyEndpointURL())
        urlRequest.httpMethod = "POST"
        return urlRequest
    }
}
