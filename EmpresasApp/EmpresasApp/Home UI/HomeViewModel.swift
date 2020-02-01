//
//  HomeViewModel.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

final class HomeViewModel {
    let enterpriseService: EnterpriseService
    
    init(enterpriseService: EnterpriseService) {
        self.enterpriseService = enterpriseService
    }
}
