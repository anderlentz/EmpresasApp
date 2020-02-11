//
//  EnterpriseComposer.swift
//  EmpresasApp
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

public final class EnterpriseComposer {
    static func enterpriseComposedWith(enterprise: Enterprise, coordinator: EnterpriseDetailsCoordinator) -> EnterpriseViewController {
                
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "EnterpriseDetails",bundle: bundle)
        let viewController = storyboard.instantiateViewController(identifier: "EnterpriseViewController") { coder in
            return EnterpriseViewController(coder: coder, enterprise: enterprise)
        }
        
        viewController.coordinator = coordinator

        return viewController
    }
}

