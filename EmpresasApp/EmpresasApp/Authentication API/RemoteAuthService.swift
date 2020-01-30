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
                    completion(.success(investorResult.investorFromAPI.toModelInvestor))
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

// MARK: - Result
private struct InvestorResult: Codable {
    let investorFromAPI: ApiInvestor
    let enterprise: ApiEnterprise?
    let success: Bool
}

// MARK: - Enterprise
private struct ApiEnterprise: Codable{
    var enterprise: Enterprise {
        return Enterprise()
    }
}

// MARK: - Portfolio
private struct ApiPortfolio: Codable {
    let enterprisesNumber: Int
    let enterprises: [ApiEnterprise]

    enum CodingKeys: String, CodingKey {
        case enterprisesNumber = "enterprises_number"
        case enterprises
    }
    
    init(enterprisesNumber: Int, enterprises: [ApiEnterprise]) {
        self.enterprisesNumber = enterprisesNumber
        self.enterprises = enterprises
    }
    
    var portfolio: Portfolio {
        return Portfolio(enterprisesNumber: enterprisesNumber,
                         enterprises: enterprises.map{ $0.enterprise} )
    }
}


// MARK: - Investor
private struct ApiInvestor: Codable {

    let id: Int
    let investorName, email, city, country: String
    let balance: Double
    let photo: String
    let portfolio: ApiPortfolio
    let portfolioValue: Double
    let firstAccess, superAngel: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case investorName = "investor_name"
        case email, city, country, balance, photo, portfolio
        case portfolioValue = "portfolio_value"
        case firstAccess = "first_access"
        case superAngel = "super_angel"
    }
    
    //Map an api investor to Investor through computed var
    var toModelInvestor: Investor {
        return Investor(id: id, investorName: investorName, email: email, city: city, country: country, balance: balance, photo: photo, portfolio: portfolio.portfolio, portfolioValue: portfolioValue, firstAccess: firstAccess, superAngel: superAngel)
    }
}
