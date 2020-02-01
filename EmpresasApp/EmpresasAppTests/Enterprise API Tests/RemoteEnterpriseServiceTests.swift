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
    
}

class RemoteEnterpriseService: EnterpriseService {
    
    let requestURL: URLRequest
    let client: EnterpriseHTTPClient
    
    init(endpointURL: URL,client: EnterpriseHTTPClient) {
        self.requestURL = URLRequest(url: endpointURL)
        self.client = client
    }
    
    func getAllEnterprises() {
        
    }
}

class RemoteEnterpriseServiceTests: XCTestCase {

    func test_init_constructsGetRequestToEndpointURL() {
        let endpointURL = URL(string: "https://any-url.com")!
        
        let (sut,_) = makeSUT()
        
        XCTAssertEqual(sut.requestURL.url, endpointURL)
        XCTAssertEqual(sut.requestURL.httpMethod, "GET")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(endpointURL: URL = URL(string: "https://any-url.com")!) -> (sut: RemoteEnterpriseService, client: EnterpriseHTTPClient) {
        let client = EnterpriseHTTPClientSpy()
        let sut = RemoteEnterpriseService(endpointURL: endpointURL,client: client)
        return (sut,client)
    }
    
    private class EnterpriseHTTPClientSpy: EnterpriseHTTPClient {
       
    }
}
