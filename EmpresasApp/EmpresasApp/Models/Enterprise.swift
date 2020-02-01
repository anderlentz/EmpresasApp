//
//  Enterprise.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

struct Enterprise: Equatable {
    
    let id: Int
    let emailEnterprise, facebook, twitter, linkedin: String?
    let phone: String?
    let ownEnterprise: Bool
    let enterpriseName: String
    let photo: String?
    let enterprisDescription, city, country: String
    let value, sharePrice: Int
    let enterpriseType: EnterpriseType
    
    static func == (lhs: Enterprise, rhs: Enterprise) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
