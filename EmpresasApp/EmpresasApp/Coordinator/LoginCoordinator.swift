//
//  LoginCoordinator.swift
//  EmpresasApp
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation
import UIKit

class LoginCoordinator: Coordinator {
    
    typealias T = Transition
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let viewModel = LoginViewModel(
            authenticationService: RemoteAuthService(
                endpointURL: URL(string: "https://empresas.ioasys.com.br/api/v1/users/auth/sign_in")!,
                client: URLSessionHTTPClient()
            )
        )
        
        let loginViewController = LoginUIComposer.loginComposedWith(viewModel: viewModel,coodinator: self)
        
//        loginViewController.navigationCoordinator = self
        loginViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.show(loginViewController, sender: nil)
    }
    
    func performTransition(transition: T) {
        switch transition {
        case .showHomeView:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            homeCoordinator.start()
        }
    }
}
