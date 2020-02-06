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
    
    func test_getAllEnterprises_onEnterprisesLoadOnSuccess() {
        let enterpriseService = EnterpriseServiceSpy()
        let sut = HomeViewModel(enterpriseService: enterpriseService)
        var receivedEnterprises: [Enterprise]?
        
        let exp = expectation(description: "Wait receive enterprise")
        sut.getAllEnterprises(enterpriseName: "Test")
        sut.onEnterprisesLoad = { enterprises in
            receivedEnterprises = enterprises
            print("Enterprises")
            exp.fulfill()
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.300, execute: { [weak enterpriseService] in
            enterpriseService?.completeGetEnterprisesWithSuccess(enterprise: self.makeEnterprise())
        })
                
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedEnterprises, [makeEnterprise()])
    }
    
    func test_getAllEnterprises_ShoudFailureOnError() {
        let enterpriseService = EnterpriseServiceSpy()
        let sut = HomeViewModel(enterpriseService: enterpriseService)
        var expectedErrorMessage = ""
        
        let exp = expectation(description: "Wait receive enterprise")
        sut.getAllEnterprises(enterpriseName: "Test")
        sut.onErrorLoad = { errorMessage in
            expectedErrorMessage = errorMessage
            exp.fulfill()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.300, execute: { [weak enterpriseService] in
            enterpriseService?.completeGetEnterprisesWithError(error: .badRequest)
        })
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(expectedErrorMessage,"Algo deu errado, tente novamente.")
    }
    
    func test_getAllEnterprises_withEmptyEnterprisesShouldCallOnEmptyEnterprisesLoad() {
        
        let enterpriseService = EnterpriseServiceSpy()
        let sut = HomeViewModel(enterpriseService: enterpriseService)
        var isOnEmptyEnterprisesLoadCalled = false
        
        let exp = expectation(description: "Wait to onEmptyEnterprisesLoad get called")
        
        sut.getAllEnterprises(enterpriseName: "any-enterprise-test")
        sut.onEmptyEnterprisesLoad = {
            isOnEmptyEnterprisesLoadCalled = true
            exp.fulfill()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.300, execute: { [weak enterpriseService] in
            enterpriseService?.completeGetEnterprisesWithEmptyEnterprises()

       })
        
        enterpriseService.completeGetEnterprisesWithEmptyEnterprises()
        wait(for: [exp], timeout: 1.0)
        XCTAssert(isOnEmptyEnterprisesLoadCalled)
    }
    
    private func makeEnterprise() -> Enterprise {
        return Enterprise(id: 0, emailEnterprise: nil, facebook: nil, twitter: nil, linkedin: nil, phone: nil, ownEnterprise: false, enterpriseName: "Test", photo: nil, enterprisDescription: "Test", city: "City", country: "Country", value: 0, sharePrice: 1, enterpriseType: EnterpriseType(id: 0, enterpriseTypeName: "Enterprise"))
    }
    
}
