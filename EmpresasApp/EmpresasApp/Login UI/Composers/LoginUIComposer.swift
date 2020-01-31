//
//  LoginUIComposer.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

public final class LoginUIComposer {
    static func loginComposedWith(viewModel: LoginViewModel, authenticationService: AuthenticationService) -> LoginViewController {
        
        let loginVC = LoginViewController()
        loginVC.viewModel = viewModel
        return loginVC
    }
}
