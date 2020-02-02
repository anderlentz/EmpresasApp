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

    // MARK: - ApiEnterprise
    private struct ApiEnterprise: Codable {
        let id: Int
        let emailEnterprise, facebook, twitter, linkedin: String?
        let phone: String?
        let ownEnterprise: Bool
        let enterpriseName: String
        let photo: String?
        let enterprisDescription, city, country: String
        let value, sharePrice: Int
        let enterpriseType: APIEnterpriseType

        enum CodingKeys: String, CodingKey {
            case id
            case emailEnterprise = "email_enterprise"
            case facebook, twitter, linkedin, phone
            case ownEnterprise = "own_enterprise"
            case enterpriseName = "enterprise_name"
            case photo
            case enterprisDescription = "description"
            case city, country, value
            case sharePrice = "share_price"
            case enterpriseType = "enterprise_type"
        }
        
        var mappedEnterprise: Enterprise {
            return Enterprise(id: id,
                              emailEnterprise: emailEnterprise,
                              facebook: facebook,
                              twitter: twitter,
                              linkedin: linkedin,
                              phone: phone,
                              ownEnterprise: ownEnterprise,
                              enterpriseName: enterpriseName,
                              photo: phone,
                              enterprisDescription: enterprisDescription,
                              city: city,
                              country: country,
                              value: value,
                              sharePrice: sharePrice,
                              enterpriseType: enterpriseType.mappedEnterpriseType)
        }
    }
    
    // MARK: - EnterpriseType
    struct APIEnterpriseType: Codable {
        let id: Int
        let enterpriseTypeName: String

        enum CodingKeys: String, CodingKey {
            case id
            case enterpriseTypeName = "enterprise_type_name"
        }
        
        var mappedEnterpriseType: EnterpriseType {
            return EnterpriseType(id: id, enterpriseTypeName: enterpriseTypeName)
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
                             enterprises: enterprises.map{ $0.mappedEnterprise} )
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
