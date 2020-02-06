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
    
    func test_getAllEnterprises_withShouldPerformRequestToEnterpriseServiceIfNameHasMoreThanOneCharacters() {
        
        let enterpriseService = EnterpriseServiceSpy()
        let sut = HomeViewModel(enterpriseService: enterpriseService)
        var receivedCount = 0
        
        sut.getAllEnterprises(enterpriseName: "")
        XCTAssertEqual(enterpriseService.callingCount, 0)
        
        let exp = expectation(description: "wait to service get called")
        enterpriseService.onGetEnterprisesCalled = { count in
            receivedCount = count
            exp.fulfill()
        }
        
        sut.getAllEnterprises(enterpriseName: "a")
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedCount, 1)
        
        
        let exp2 = expectation(description: "wait to service get called")
        enterpriseService.onGetEnterprisesCalled = { count in
           receivedCount = count
           exp2.fulfill()
        }

        sut.getAllEnterprises(enterpriseName: "a")

        wait(for: [exp2], timeout: 1.0)
        XCTAssertEqual(receivedCount, 2)
    }
    
    
    private class EnterpriseServiceSpy: EnterpriseService {
        
        var wasCalled = false
        var callingCount = 0

        var onGetEnterprisesCalled: (Int) -> Void = {_ in}
        
        func getEnterprises(containingName: String, completion: @escaping (Result<[Enterprise], RemoteEnterpriseService.EnterpriseServiceError>) -> Void) {
            wasCalled = true
            callingCount += 1
            onGetEnterprisesCalled(callingCount)
        }
    }
}
