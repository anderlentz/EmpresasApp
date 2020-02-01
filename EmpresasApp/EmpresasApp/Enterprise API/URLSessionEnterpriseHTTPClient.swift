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
