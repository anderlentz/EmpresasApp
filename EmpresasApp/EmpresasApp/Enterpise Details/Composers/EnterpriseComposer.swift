//
//  EnterpriseComposer.swift
//  EmpresasApp
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

public final class EnterpriseComposer {
    static func enterpriseComposedWith(enterprise: Enterprise) -> EnterpriseViewController {
                
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "EnterpriseDetails",bundle: bundle)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EnterpriseViewController") as! EnterpriseViewController
        
        //viewController.viewModel = viewModel
        
        return viewController
    }
}

