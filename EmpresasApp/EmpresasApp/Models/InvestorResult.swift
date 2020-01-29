//
//  InvestorResult.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

// MARK: - Result
struct InvestorResult: Codable {
    let investor: Investor
    let enterprise: JSONNull?
    let success: Bool
}
