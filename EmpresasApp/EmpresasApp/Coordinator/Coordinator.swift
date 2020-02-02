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
    case showHomeView
}

protocol Coordinator: class {
    associatedtype T
    
    var navigationController: UINavigationController? { get set }
    func start()
    func performTransition(transition: T)
}
