//
//  HTTPClientSpy.swift
//  EmpresasAppTests
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation
@testable import EmpresasApp

class HTTPClientSpy: HTTPClient {
    
    var endpointURL: URL?
    var message: ((Result<(Data,HTTPURLResponse), Error>) -> Void) = { _ in}
    
    func post(to url: URL,
              completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void){
        self.endpointURL = url
        self.message = completion
    }
    
    func complete(whith error: Error) {
        let result: Result<(Data,HTTPURLResponse), Error> = .failure(error)
        message(result)
    }
    
    func complete(whithStatusCode code: Int, data: Data = Data()) {
        var sucessResult: (Result<(Data,HTTPURLResponse), Error>)
        
        let response = HTTPURLResponse(url: endpointURL!,
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil)!
        sucessResult = .success((data, response))
        
        message(sucessResult)
    }
}

extension HTTPClientSpy {
    static let endpointURL = URL(string: "http://authentication-test.com")!
}
