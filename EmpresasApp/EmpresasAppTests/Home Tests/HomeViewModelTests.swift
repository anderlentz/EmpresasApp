//
//  HomeViewModelTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 05/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

class HomeViewModelTests: XCTestCase {
    
    func test_getAllEnterprises_withEmptyNameShouldNotPerformRequestToEnterpriseService() {
        
        let enterpriseService = EnterpriseServiceSpy()
        let sut = HomeViewModel(enterpriseService: enterpriseService)
        
        sut.getAllEnterprises(enterpriseName: "")
        
        XCTAssertFalse(enterpriseService.wasCalled)
        
    }
    
    
    private class EnterpriseServiceSpy: EnterpriseService {
        
        var wasCalled = false
        
        func getEnterprises(containingName: String, completion: @escaping (Result<[Enterprise], RemoteEnterpriseService.EnterpriseServiceError>) -> Void) {
            
        }
    }
}
