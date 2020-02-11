//
//  EnterpriseViewControllerTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 11/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

class EnterpriseViewControllerTests: XCTestCase {

    func test_init_mustReceiveAnEnterprise() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.enterprise.enterpriseName,makeEnterprise().enterpriseName)
    }
    
    func test_viewDidLoad_showsEnterpriseDetails() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.enterpriseDescriptionLabel.text, makeEnterprise().enterprisDescription)
    }
    
    func test_viewDidLoad_showsEnterpriseNameOnTitle() {
        let sut = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.navigationItem.title, makeEnterprise().enterpriseName)
    }
    
    
    // MARK: - Helpers
    private func makeSUT() -> EnterpriseViewController {
        let enterprise = makeEnterprise()
        let coordinator = EnterpriseDetailsCoordinatorSpy(navigationController: nil,
                                                          enterprise: enterprise)
        let sut = EnterpriseComposer.enterpriseComposedWith(enterprise: enterprise, coordinator: coordinator)
        
        return sut
    }
    
    private func makeEnterprise() -> Enterprise {
        return Enterprise(id: 0, emailEnterprise: nil, facebook: nil, twitter: nil, linkedin: nil, phone: nil, ownEnterprise: false, enterpriseName: "Test", photo: nil, enterprisDescription: "Test", city: "City", country: "Country", value: 0, sharePrice: 1, enterpriseType: EnterpriseType(id: 0, enterpriseTypeName: "Enterprise"))
    }
    
    private class EnterpriseDetailsCoordinatorSpy: EnterpriseDetailsCoordinator {
        
    }
   
}
