//
//  Portfolio.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

// MARK: - Portfolio
struct Portfolio: Codable {
    let enterprisesNumber: Int
    let enterprises: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case enterprisesNumber = "enterprises_number"
        case enterprises
    }
    
    init(enterprisesNumber: Int, enterprises: [JSONAny]) {
        self.enterprisesNumber = enterprisesNumber
        self.enterprises = enterprises
    }
}
