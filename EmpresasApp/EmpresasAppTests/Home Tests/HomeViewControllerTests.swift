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
    
    private class HomeViewModelSpy: HomeViewModelProtocol {
        
        var wasGetAllEnterprisesCalled = false
        
        var onEnterprisesLoad: Observer<[Enterprise]>?
        var onErrorLoad: Observer<String>?
        var onChange: Observer<HomeViewModel>?
        
        func getAllEnterprises(enterpriseName: String) {
            wasGetAllEnterprisesCalled = true
        }
        
    
        
    }
    
}
