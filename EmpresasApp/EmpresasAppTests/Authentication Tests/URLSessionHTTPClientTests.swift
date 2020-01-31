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
        
        let endpointURL = URL(string: "https://auth.test.com")!
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRquests { request in
            XCTAssertEqual(request.url, endpointURL)
            XCTAssertEqual(request.httpMethod, "POST")
            exp.fulfill()
        }
        
        URLSessionHTTPClient().post(to: endpointURL) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_postUrlRequest_failsOnRequestError() {
        let endpointURL = URL(string: "https://auth.test.com")!
        let error = NSError(domain: "ANY ERROR", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        
        let sut = URLSessionHTTPClient()
        
        let exp = expectation(description: "Wait for completion")
        
        sut.post(to: endpointURL) { result in
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
    
    // MARK: - URLProtocolStub class
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ( (URLRequest) -> Void)?
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }

        override class func canInit(with request: URLRequest) -> Bool {
            //Intercep all requests
            requestObserver?(request)
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }
        
        static func observeRquests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
    }
}