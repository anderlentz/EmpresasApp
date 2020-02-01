//
//  RemoteEnterpriseServiceTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest

protocol EnterpriseService {
    func getAllEnterprises()
}

class RemoteEnterpriseService: EnterpriseService {
    
    var requestURL: URLRequest?
    
    init(endpointURL: URL) {
        requestURL = URLRequest(url: endpointURL)
    }
    
    func getAllEnterprises() {
        
    }
}

class RemoteEnterpriseServiceTests: XCTestCase {

    func test_getAllEnterprises_makeURLRequestToEndpointURL() {
        let endpointURL = URL(string: "https://any-url.com")!
        let sut = RemoteEnterpriseService(endpointURL: endpointURL)
    
        sut.getAllEnterprises()
        
        XCTAssertEqual(sut.requestURL?.url, endpointURL)
    }
}
