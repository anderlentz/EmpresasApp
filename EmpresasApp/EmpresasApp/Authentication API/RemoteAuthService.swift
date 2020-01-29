//
//  RemoteAuthService.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

protocol HTTPClient {
    func post(to url: URL)
}

class RemoteAuthService {

    let client: HTTPClient
    let endpointURL: URL
    
    var headers: [String: String] = ["Content-Type":"application/json"]
    
    var body: [String:String] = ["email":"email_test@email.com",
                                 "password":"123"]
    
    
    init(endpointURL: URL, client: HTTPClient) {
        self.client = client
        self.endpointURL = endpointURL
    }
    
    func authenticate(email: String, password: String) {
        self.setupHeaders(email: email, password: password)
        client.post(to: endpointURL)
    }
    
    private func setupHeaders(email: String, password: String) {
        self.body["email"] = email
        self.body["password"] = password
    }
}

