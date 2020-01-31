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
        let viewController = HomeUIComposer.loginComposedWith(viewModel: HomeViewModel())
        
        navigationController?.viewControllers.remove(at: 0)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.viewControllers.insert(viewController, at: 0)
    }
    
}
