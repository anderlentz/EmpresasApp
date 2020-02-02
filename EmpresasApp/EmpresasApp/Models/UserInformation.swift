//
//  UserInformation.swift
//  EmpresasApp
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    var authState: AuthState?
    
    init(){}
}
