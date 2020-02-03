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
    
    func test_getUrlRequest_failsOnRequestError() {
        let requestError = anyError()
        
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
        
        XCTAssertEqual(receivedError as NSError?, requestError)
           
    }
    
    func test_get_failsOnAllInvalidCases() {
        
        XCTAssertNotNil(resultErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyError()))
        XCTAssertNotNil(resultErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_getFromURLResquest_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()
        URLProtocolStub.stub(data: data, response: response, error: nil)
        
        let exp = expectation(description: "Wait for completion")
        
        makeSUT().get(from: anyURLRequest()) { result in
            switch result {
            case let .success((receivedData, receivedResponse)):
                XCTAssertEqual(receivedData, data)
                XCTAssertEqual(receivedResponse.url, response.url)
                XCTAssertEqual(receivedResponse.statusCode, response.statusCode)
            default:
                XCTFail("Expected success, got \(result)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    
    // MARK: - Helpers
    private func makeSUT() -> URLSessionEnterpriseHTTPCLient {
        return URLSessionEnterpriseHTTPCLient()
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyEndpointURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyEndpointURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func anyEndpointURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyURLRequest() -> URLRequest {
        let urlRequest = URLRequest(url: anyEndpointURL())
        return urlRequest
    }
    
    private func anyData() -> Data {
        return Data()
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "ANY ERROR", code: 1)
    }
    
    private func resultErrorFor(data: Data?, response: URLResponse?, error: Error?,
                                file: StaticString = #file, line: UInt = #line) -> Error? {
        URLProtocolStub.stub(data: data, response: response, error: error)
        
        let exp = expectation(description: "Wait for completion")
        
        var receivedError: Error?
        makeSUT().get(from: anyURLRequest()) { result in
            switch result {
            case let .failure(error):
                receivedError = error
            default:
                XCTFail("Expected failure with error, got \(result) instead",file: file,line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return receivedError
    }
}
