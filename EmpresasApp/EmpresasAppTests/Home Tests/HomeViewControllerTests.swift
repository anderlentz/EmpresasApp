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
        
        let (sut,viewModel) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(viewModel.wasGetAllEnterprisesCalled)
    
    }
    
    func test_searchEnterprises_callOnEnterprisesLoad() {
        let (sut,viewModel) = makeSUT()
        var receivedEnterprises: [Enterprise]?
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait on enterprises load")
        sut.viewModel?.onEnterprisesLoad = { enterprises in
            receivedEnterprises = enterprises
            exp.fulfill()
        }
        viewModel.completesGetAllEnterprisesWithSuccess(enterprises: [HomeViewControllerTests.makeEnterprise()])
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedEnterprises, [HomeViewControllerTests.makeEnterprise()])
    }
    
    func test_onEnterprisesLoad_rendersLoadedEnterprises() {
        let (sut,viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        
        viewModel.completesGetAllEnterprisesWithSuccess(enterprises: [HomeViewControllerTests.makeEnterprise()])
        
        
        
        XCTAssertEqual(sut.numberOfRenderedEnterprisesViews(), 1)
    }
    
    func test_onEnterprisesLoad_withEmptyResultShoudShowNoEnterprisesBackgroundView() {
        let (sut,viewModel) = makeSUT()
        var isEmptyResult = false
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for empty load callback")
        sut.viewModel?.onEmptyEnterprisesLoad = {
            isEmptyResult = true
            exp.fulfill()
        }
        
        viewModel.completesGetAllEnterprisesWithEmptyResult()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssert(isEmptyResult)
  
    }
    
    private func makeSUT() -> (sut:HomeViewController,viewModel: HomeViewModelSpy) {
        let viewModel = HomeViewModelSpy()
        return (HomeUIComposer.loginComposedWith(viewModel: viewModel),viewModel)
    }
    
    private class HomeViewModelSpy: HomeViewModelProtocol {
       
        var onEmptyEnterprisesLoad: (() -> Void)?
        var wasGetAllEnterprisesCalled = false
        var onEnterprisesLoad: Observer<[Enterprise]>?
        var onErrorLoad: Observer<String>?
        var onChange: Observer<HomeViewModel>?
        
        func getAllEnterprises(enterpriseName: String) {
            wasGetAllEnterprisesCalled = true
            
        }
        
        func completesGetAllEnterprisesWithSuccess(enterprises: [Enterprise]) {
            onEnterprisesLoad?(enterprises)
        }
        
        func completesGetAllEnterprisesWithEmptyResult() {
            onEmptyEnterprisesLoad?()
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
    
    func numberOfRenderedEnterprisesViews() -> Int {
        return tableView.numberOfRows(inSection: enterprisesSection)
    }
    
    private var enterprisesSection: Int {
        return 0
    }
}
