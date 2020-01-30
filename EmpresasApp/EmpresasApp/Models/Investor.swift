//
//  Investor.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

// MARK: - Investor
public struct Investor: Codable,Equatable {
    
    
    let id: Int
    let investorName, email, city, country: String
    let balance: Int
    let photo: String
    let portfolio: Portfolio
    let portfolioValue: Int
    let firstAccess, superAngel: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case investorName = "investor_name"
        case email, city, country, balance, photo, portfolio
        case portfolioValue = "portfolio_value"
        case firstAccess = "first_access"
        case superAngel = "super_angel"
    }
    
    public static func == (lhs: Investor, rhs: Investor) -> Bool {
        return lhs.id == rhs.id
    }
}
