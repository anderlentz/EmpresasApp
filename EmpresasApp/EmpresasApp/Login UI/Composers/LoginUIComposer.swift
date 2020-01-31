//
//  LoginUIComposer.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

public final class LoginUIComposer {
    static func loginComposedWith(viewModel: LoginViewModel) -> LoginViewController {
        
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Main",bundle: bundle)
        let loginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
        
        let loginVC = loginViewController
        loginVC.viewModel = viewModel
        
        return loginVC
    }
}
