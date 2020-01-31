//
//  HomeCoodinator.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class HomeCoordinator {
    var navigationController: UINavigationController?
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
        
    func start() {
        
        // Probably we dont instantiate here when we have a composer available
//        let bundle = Bundle(for: LoginViewController.self)
//        let storyboard = UIStoryboard(name: "Main",bundle: bundle)
//        let loginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
//        
//        navigationController?.pushViewController(loginViewController, animated: true)
        
    }
    
}
