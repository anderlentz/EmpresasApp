//
//  EnterpriseDetailsCoordinator.swift
//  EmpresasApp
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

enum EnterpriseDetailsCoordinatorTransition {
    //case showEnterpriseDetails(Enterprise)
}


class EnterpriseDetailsCoordinator: Coordinator {
    typealias T = EnterpriseDetailsCoordinatorTransition
    
    var navigationController: UINavigationController?
    let enterprise: Enterprise
    
    init(navigationController: UINavigationController?, enterprise: Enterprise) {
        self.navigationController = navigationController
        self.enterprise = enterprise
    }
    
    func start() {
        let enterpriseDetailsVC = EnterpriseComposer.enterpriseComposedWith(enterprise: enterprise)
        enterpriseDetailsVC.enterprise = enterprise
        navigationController?.pushViewController(enterpriseDetailsVC, animated: true)
    }
    
    func performTransition(transition: EnterpriseDetailsCoordinatorTransition) {
        
    }
}
