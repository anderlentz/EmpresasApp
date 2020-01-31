//
//  Coordinator.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

import Foundation
import UIKit

enum Transition {
    case showEnterpriseDetails(Enterprise)
    case showHomeView
}

protocol Coordinator: class {
    var navigationController: UINavigationController? { get set }
    var uiViewController: UIViewController? { get set}
    func start()
    func performTransition(transition: Transition)
}
