//
//  URLSessionHTTPClient.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnexpectedValues: Error {}
    
    func post(to postRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        
        session.dataTask(with: postRequest) { (data, response, error) in
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
