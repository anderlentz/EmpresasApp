//
//  RemoteAuthService.swift
//  EmpresasAppTests
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest

class RemoteAuthService {
 
}

class HTTPClient {
    var endpointURL: URL?
}


class RemoteAuthServiceTests: XCTestCase {
    
    func test_init_doesNotRequestAuthenticationDataFromEndpoint() {
        let client = HTTPClient()
        _ = RemoteAuthService()
        
        
        XCTAssertNil(client.endpointURL)
        
    }
}

