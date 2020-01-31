//
//  Investor.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

// MARK: - Investor
public struct Investor: Equatable {
    let id: Int
    let investorName, email, city, country: String
    let balance: Double
    let photo: String
    let portfolio: Portfolio
    let portfolioValue: Double
    let firstAccess, superAngel: Bool
    
    public static func == (lhs: Investor, rhs: Investor) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: Int,investorName: String,email: String, city: String, country: String, balance: Double, photo: String, portfolio: Portfolio, portfolioValue: Double, firstAccess: Bool, superAngel: Bool) {
        
        self.id = id
        self.investorName = investorName
        self.email = email
        self.city = city
        self.country = country
        self.balance = balance
        self.photo = photo
        self.portfolio = portfolio
        self.portfolioValue = portfolioValue
        self.firstAccess = firstAccess
        self.superAngel = superAngel
    }
}
