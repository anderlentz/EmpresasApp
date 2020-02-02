//
//  URLSessionEnterpriseHTTPClient.swift
//  EmpresasApp
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

protocol EnterpriseHTTPClient {
    func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void)
}

class URLSessionEnterpriseHTTPCLient: EnterpriseHTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValues: Error {}
    
    func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            }
            else {
                completion(.failure(UnexpectedValues()))
                //completion(.failure(s))
            }
        }.resume()
    }
}
