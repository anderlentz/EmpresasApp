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
        let endpointURL = URL(string: "https://empresas.ioasys.com.br/api/v1/enterprises?enterprises")!
        
        let authState = AuthState(accessToken: "", client: "", uid: "")
        
        let viewModel = HomeViewModel(enterpriseService: RemoteEnterpriseService(endpointURL: endpointURL,
                                                                                 client: URLSessionEnterpriseHTTPCLient(),
                                                                                 authState: authState))
        let viewController = HomeUIComposer.loginComposedWith(viewModel: viewModel)
        
        navigationController?.viewControllers.remove(at: 0)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.viewControllers.insert(viewController, at: 0)
    }
    
}
