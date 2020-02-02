//
//  HomeCoodinator.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

enum HomeCoordinatorTransition {
    case showEnterpriseDetails(Enterprise)
}

class HomeCoordinator: Coordinator {
    typealias T = HomeCoordinatorTransition
    
    var navigationController: UINavigationController?
        
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
        
    func start() {
        let endpointURL = URL(string: "https://empresas.ioasys.com.br/api/v1/enterprises")!
        
        let authState = AuthenticationManager.shared.authState!
        
        let viewModel = HomeViewModel(enterpriseService: RemoteEnterpriseService(endpointURL: endpointURL,
                                                                                 client: URLSessionEnterpriseHTTPCLient(),
                                                                                 authState: authState))
        let viewController = HomeUIComposer.loginComposedWith(viewModel: viewModel)
        viewController.navigationCoordinator = self
        navigationController?.viewControllers.remove(at: 0)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.viewControllers.insert(viewController, at: 0)
    }
    
    func performTransition(transition: T) {
        print("performTrantions")
        switch transition {
        case .showEnterpriseDetails(let enterprise):
            let enterpriseCoordinator = EnterpriseDetailsCoordinator(navigationController: navigationController, enterprise: enterprise)
            enterpriseCoordinator.start()
        }
    }
    
}
