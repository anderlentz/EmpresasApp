//
//  EnterpriseService.swift
//  EmpresasApp
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

protocol EnterpriseService {
    func getEnterprises(containingName: String,
                        completion: @escaping (Result<[Enterprise],RemoteEnterpriseService.EnterpriseServiceError>) -> Void)
}
