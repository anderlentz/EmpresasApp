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
        let enterprise = HomeViewControllerTests.makeEnterprise()
        sut.loadViewIfNeeded()
        
        viewModel.completesGetAllEnterprisesWithSuccess(enterprises: [enterprise])
        
        let view = sut.enterpriseView(at: 0)
        guard let cell = view as? EnterpriseTableViewCell else {
            return XCTFail("Expected \(EnterpriseTableViewCell.self)")
        }

        XCTAssertEqual(sut.numberOfRenderedEnterprisesViews(), 1)
        XCTAssertEqual(cell.enterpriseName.text, enterprise.enterpriseName)
        XCTAssertEqual(cell.countryLabel.text, enterprise.country)
        XCTAssertEqual(cell.businessLabel.text, enterprise.enterpriseType.enterpriseTypeName)
    }
    
    func test_onEnterprisesLoad_withEmptyResultShoudReceiveOnEmptyEnterpriseCallback() {
        let (sut,viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for empty load callback")
        sut.viewModel?.onEmptyEnterprisesLoad = {
            exp.fulfill()
        }
        
        viewModel.completesGetAllEnterprisesWithEmptyResult()
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    func test_showEmptyEnterprisesBackgroundResult_setsTableviewBackgroundToEmptyResultLayout() {
        let (sut,_) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Waits set background view at main thread")
        DispatchQueue.main.async {
            sut.simulateEmptyEnterprisesSearch()
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(sut.tableView.backgroundView?.restorationIdentifier, "noEnterprisesBackground")
        
    }
    
    func test_searchBar_textDidChangePerformsSearchWithSameString() {
        
        let (sut,viewModel) = makeSUT()
        var receivedEnterpriseName = ""
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait receiving enterprise name")
        
        viewModel.onSearchEnterpriseName = { enterpriseName in
            receivedEnterpriseName = enterpriseName
            exp.fulfill()
        }
        
        sut.simulateUserTypeEnterpriseNameOnSearchBar(enterpriseName: "enterprise-test")
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedEnterpriseName, "enterprise-test")
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
        var onSearchEnterpriseName: Observer<String>?
        
        func getAllEnterprises(enterpriseName: String) {
            wasGetAllEnterprisesCalled = true
            onSearchEnterpriseName?(enterpriseName)
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
    
    private var enterprisesSection: Int {
        return 0
    }
    
    func numberOfRenderedEnterprisesViews() -> Int {
        return tableView.numberOfRows(inSection: enterprisesSection)
    }
    
    func enterpriseView(at row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource
        let index = IndexPath(item: row, section: enterprisesSection)
        return dataSource?.tableView(tableView, cellForRowAt: index)
    }
    
    func simulateSuccefullEnterpriseSearch(){
        viewModel?.getAllEnterprises(enterpriseName: "teste")
    }
    
    func simulateEmptyEnterprisesSearch() {
        showEmptyEnterprisesBackgroundResult()
    }
    
    func simulateUserTypeEnterpriseNameOnSearchBar(enterpriseName: String) {
        let searchBar = searchController.searchBar
        self.searchBar(searchBar, textDidChange: enterpriseName)
    }
}
