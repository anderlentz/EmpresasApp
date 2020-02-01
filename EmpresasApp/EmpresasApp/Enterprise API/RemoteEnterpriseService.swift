//
//  RemoteEnterpriseService.swift
//  EmpresasApp
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

class RemoteEnterpriseService: EnterpriseService {
   
    let authState: AuthState
    let client: EnterpriseHTTPClient
    var requestURL: URLRequest
    
    public enum EnterpriseServiceError: Swift.Error {
        case connectivity
        case unauthorized
        case badRequest
        case forbidden
        case invalidData
        case generic
    }
    
    init(endpointURL: URL,client: EnterpriseHTTPClient, authState: AuthState) {
        self.requestURL = URLRequest(url: endpointURL)
        self.client = client
        self.authState = authState
    }
    
    func getAllEnterprises(completion: @escaping (Result<[Enterprise], RemoteEnterpriseService.EnterpriseServiceError>) -> Void) {
        requestURL.allHTTPHeaderFields = makeHeader()
        client.get(from: requestURL) { result in
            switch result {
            case .failure:
                completion(.failure(.connectivity))
            case .success(let (data,response)):
                switch response.statusCode {
                case 401:
                    completion(.failure(.unauthorized))
                case 200:
                    do {
                        let enterprises = try EnterpriseMapper.map(data: data)
                        completion(.success(enterprises))
                    } catch {
                        completion(.failure(.invalidData))
                    }
                default:
                    completion(.failure(.generic))
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func makeHeader() -> [String: String] {
        
        if let accessToken = authState.accessToken,
            let client = authState.client,
            let uid = authState.uid {
            return ["access-token": accessToken,
                    "client": client,
                    "uid": uid]
        } else {
            return ["access-token":"",
                    "client": "",
                    "uid":""]
        }
    }
}
