//
//  EnterpriseMapper.swift
//  EmpresasApp
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

class EnterpriseMapper {
    
    // MARK: - Result
    private struct EnterprisesResult: Codable {
        let enterprises: [ApiEnterprise]
        
        //Maps an list of APIEnterprise to [Enterprise] business class
        var mappedEnterprises: [Enterprise] {
            return enterprises.map { (apiEnterprise) -> Enterprise in
                apiEnterprise.mappedEnterprise
            }
        }
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
    
    static func map(data: Data) throws -> [Enterprise] {
        do {
            let enterprisesResult = try JSONDecoder().decode(EnterprisesResult.self, from: data)
            return enterprisesResult.mappedEnterprises
        }
    }
}
