//
//  AppCoordinator.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    var uiViewController: UIViewController?
    
    init(uiViewController: UIViewController? = nil, navigationController: UINavigationController? = nil) {
        self.uiViewController = uiViewController
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewModel = LoginViewModel(authenticationService: RemoteAuthService(endpointURL: URL(string: "https://empresas.ioasys.com.br/api/v1/users/auth/sign_in")!, client: URLSessionHTTPClient()))
        
        let loginViewController = LoginUIComposer.loginComposedWith(viewModel: viewModel)
        
        loginViewController.navigationCoordinator = self
        loginViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.show(loginViewController, sender: nil)
  
    }
    func performTransition(transition: Transition) {
        switch transition {
        case .showHomeView:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            homeCoordinator.start()
               
        case .showEnterpriseDetails(_):
            break
        }
    }
    
}
