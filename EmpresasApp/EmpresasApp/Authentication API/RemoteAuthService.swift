//
//  RemoteAuthService.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func post(to url: URL,completion: @escaping (Error) -> Void)
}

public class RemoteAuthService {

    private let endpointURL: URL
    private let client: HTTPClient
    
    public var headers: [String: String] = ["Content-Type":"application/json"]
    public var body: [String:String] = ["email":"email_test@email.com",
                                 "password":"123"]
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(endpointURL: URL, client: HTTPClient) {
        self.client = client
        self.endpointURL = endpointURL
    }
    
    public func authenticate(email: String,
                             password: String,
                             completion: @escaping (Error) -> Void) {
        
        self.setupHeaders(email: email, password: password)
        
        client.post(to: endpointURL) { error in
            completion(.connectivity)
        }
    }
    
    private func setupHeaders(email: String, password: String) {
        self.body["email"] = email
        self.body["password"] = password
    }
}

