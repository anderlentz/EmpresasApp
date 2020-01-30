//
//  Portfolio.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

// MARK: - Portfolio
struct Portfolio {
    let enterprisesNumber: Int
    let enterprises: [Enterprise?]

    init(enterprisesNumber: Int, enterprises: [Enterprise]) {
        self.enterprisesNumber = enterprisesNumber
        self.enterprises = enterprises
    }
}
