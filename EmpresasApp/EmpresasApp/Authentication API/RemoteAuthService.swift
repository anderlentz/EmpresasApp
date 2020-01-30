//
//  RemoteAuthService.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

protocol HTTPClient {
    func post(to url: URL,completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void)
}

class RemoteAuthService {

    private let endpointURL: URL
    private let client: HTTPClient
    
    public var headers: [String: String] = ["Content-Type":"application/json"]
    public var body: [String:String] = ["email":"email_test@email.com",
                                 "password":"123"]
    
    public enum Error: Swift.Error {
        case connectivity
        case unauthorized
        case badRequest
        case forbidden
        case invalidData
        case generic
    }
    
    public init(endpointURL: URL, client: HTTPClient) {
        self.client = client
        self.endpointURL = endpointURL
    }
    
    func authenticate(email: String,
                             password: String,
                             completion: @escaping (Result<Investor,Error>) -> Void) {
        
        self.setupHeaders(email: email, password: password)
        
        client.post(to: endpointURL) { result in
            
            switch result {
            case .success(let (data,response)):
                switch response.statusCode{
                case 400:
                    completion(.failure(.badRequest))
                case 401:
                   completion(.failure(.unauthorized))
                case 403:
                   completion(.failure(.forbidden))
                case 200:
                    if let investorResult = try? JSONDecoder().decode(InvestorResult.self, from: data) {
                        completion(.success(investorResult.investor))
                    } else {
                        completion(.failure(.invalidData))
                    }
                default:
                   completion(.failure(.unauthorized))
                }
            case .failure(_):
                completion(.failure(.connectivity))
            }
        }
    }
    
    
    private func setupHeaders(email: String, password: String) {
        self.body["email"] = email
        self.body["password"] = password
    }
}

