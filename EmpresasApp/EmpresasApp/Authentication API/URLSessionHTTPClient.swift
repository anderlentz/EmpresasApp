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
    
    func post(to url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        session.dataTask(with: urlRequest) { (_, _, error) in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
