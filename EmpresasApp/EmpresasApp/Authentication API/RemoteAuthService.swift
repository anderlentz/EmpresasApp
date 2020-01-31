//
//  RemoteAuthService.swift
//  EmpresasApp
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func post(to url: URL,completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void)
}

public class RemoteAuthService: AuthenticationService {

    private let endpointURL: URL
    private let client: HTTPClient
    
    public var headers: [String: String] = ["Content-Type":"application/json"]
    public var body: [String:String] = ["email":"email_test@email.com",
                                 "password":"123"]
    
    public enum AuthenticationError: Swift.Error {
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
    
    public func authenticate(email: String,
                             password: String,
                             completion: @escaping (Result<Investor,AuthenticationError>) -> Void) {
        
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

                    do {
                        let investor = try InvestorMapper.map(data)
                        completion(.success(investor))
                    } catch {
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


