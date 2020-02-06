//
//  HomeViewControllerTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 06/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

class HomeViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_dontLoadEnterprises() {
        
        //let enterpriseService = EnterpriseServiceSpy()
        let viewModel = HomeViewModelSpy()
        let sut = HomeUIComposer.loginComposedWith(viewModel: viewModel)
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(viewModel.wasGetAllEnterprisesCalled)
    
    }
    
    func test_searchEnterprises_callOnEnterprisesLoad() {
        let viewModel = HomeViewModelSpy()
        let sut = HomeUIComposer.loginComposedWith(viewModel: viewModel)
        var receivedEnterprises: [Enterprise]?
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait on enterprises load")
        sut.viewModel?.onEnterprisesLoad = { enterprises in
            receivedEnterprises = enterprises
            exp.fulfill()
        }
        viewModel.completesGetAllEnterprisesWithSuccess()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedEnterprises, [HomeViewControllerTests.makeEnterprise()])
        
    }
    
    private class HomeViewModelSpy: HomeViewModelProtocol {
        
        var wasGetAllEnterprisesCalled = false
        
        var onEnterprisesLoad: Observer<[Enterprise]>?
        var onErrorLoad: Observer<String>?
        var onChange: Observer<HomeViewModel>?
        
        func getAllEnterprises(enterpriseName: String) {
            wasGetAllEnterprisesCalled = true
            
        }
        
        func completesGetAllEnterprisesWithSuccess() {
            onEnterprisesLoad?([HomeViewControllerTests.makeEnterprise()])
        }
    }
    
    static private func makeEnterprise() -> Enterprise {
        return Enterprise(id: 0, emailEnterprise: nil, facebook: nil, twitter: nil, linkedin: nil, phone: nil, ownEnterprise: false, enterpriseName: "Test", photo: nil, enterprisDescription: "Test", city: "City", country: "Country", value: 0, sharePrice: 1, enterpriseType: EnterpriseType(id: 0, enterpriseTypeName: "Enterprise"))
    }
}

private extension HomeViewController {
    func simulateSuccefullEnterpriseSearch(){
        viewModel?.getAllEnterprises(enterpriseName: "teste")
        
    }
}
