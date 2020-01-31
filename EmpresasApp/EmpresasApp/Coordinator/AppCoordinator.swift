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
    }
    
    func start() {
        
        // Probably we dont instantiate here when we have a composer available
        let bundle = Bundle(for: LoginViewController.self)
        let storyboard = UIStoryboard(name: "Main",bundle: bundle)
        let loginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
        
        loginViewController.modalPresentationStyle = .fullScreen
        uiViewController?.show(loginViewController, sender: nil)
        
        
        
    }
    func performTransition(transition: Transition) {}
    
}
