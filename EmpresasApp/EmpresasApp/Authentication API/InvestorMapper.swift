//
//  InvestorFactory.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

class InvestorMapper {
    // MARK: - Result
    private struct InvestorResult: Codable {
        let investor: ApiInvestor
        let enterprise: ApiEnterprise?
        let success: Bool
    }

    // MARK: - Enterprise
    private struct ApiEnterprise: Codable{
        var enterprise: Enterprise {
            return Enterprise()
        }
    }

    // MARK: - Portfolio
    private struct ApiPortfolio: Codable {
        let enterprisesNumber: Int
        let enterprises: [ApiEnterprise]

        enum CodingKeys: String, CodingKey {
            case enterprisesNumber = "enterprises_number"
            case enterprises
        }
        
        init(enterprisesNumber: Int, enterprises: [ApiEnterprise]) {
            self.enterprisesNumber = enterprisesNumber
            self.enterprises = enterprises
        }
        
        var portfolio: Portfolio {
            return Portfolio(enterprisesNumber: enterprisesNumber,
                             enterprises: enterprises.map{ $0.enterprise} )
        }
    }


    // MARK: - Investor
    private struct ApiInvestor: Codable {

        let id: Int
        let investorName, email, city, country: String
        let balance: Double
        let photo: String
        let portfolio: ApiPortfolio
        let portfolioValue: Double
        let firstAccess, superAngel: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case investorName = "investor_name"
            case email, city, country, balance, photo, portfolio
            case portfolioValue = "portfolio_value"
            case firstAccess = "first_access"
            case superAngel = "super_angel"
        }
        
        //Map an api investor to Investor through computed var
        var investor: Investor {
            return Investor(id: id, investorName: investorName, email: email, city: city, country: country, balance: balance, photo: photo, portfolio: portfolio.portfolio, portfolioValue: portfolioValue, firstAccess: firstAccess, superAngel: superAngel)
        }
    }
    
    static func map(_ data: Data) throws -> Investor {
        
        do {
            let investorResult = try JSONDecoder().decode(InvestorResult.self, from: data)
            return investorResult.investor.investor
        } catch {
            throw RemoteAuthService.AuthenticationError.invalidData
        }
    }
}
