//
//  AuthenticationManager.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

protocol AuthenticationService {
    
    func authenticate(email: String, password: String, completion: @escaping (Result<Investor,RemoteAuthService.AuthenticationError>) -> Void)
}
