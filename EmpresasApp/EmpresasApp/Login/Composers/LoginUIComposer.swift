//
//  LoginUIComposer.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

/**
 The LoginUIComposer is responsable for instantiating  a LoginViewController and set the viewModel and the navCoordinator
 dependencies
 */
public final class LoginUIComposer {
    static func loginComposedWith(viewModel: LoginViewModel,coodinator: LoginCoordinator) -> LoginViewController {
        
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Main",bundle: bundle)
        let loginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
        
        loginViewController.viewModel = viewModel
        loginViewController.navigationCoordinator = coodinator
        
        
        return loginViewController
    }
}
