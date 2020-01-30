//
//  RemoteAuthService.swift
//  EmpresasAppTests
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
import EmpresasApp


class RemoteAuthServiceTests: XCTestCase {
    
    func test_init_doesNotRequestAuthenticationDataFromEndpoint() {
        let (_,client) = makeSUT()
        
        XCTAssertNil(client.endpointURL)
    }
    
    func test_authenticate_requestDataFromEndpointURL() {
        let endpointURL = URL(string: "https://test-authentication.com")!
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT(endpointURL: endpointURL)

        sut.authenticate(email: email, password: password){ _ in }

        XCTAssertEqual(client.endpointURL,endpointURL)
    }
    
    func test_authenticate_resquestwithEmailPasswordIntoBody() {
        let (sut,_) = makeSUT()
        let email = "email@email.com"
        let password = "123123"
        
        sut.authenticate(email: email, password: password){ _ in }
        
        XCTAssertEqual(sut.body,["email": email,"password":password])
        
    }
    
    func test_authenticate_deliversErrorOnClientConnectivityError() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: Result<Investor,RemoteAuthService.Error> = .failure(.generic)
        
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        let clientError = NSError(domain:"Test",code:0)
        client.complete(whith: clientError)
        
        XCTAssertEqual(capturedError,.failure(.connectivity))
    }
    
    func test_authentication_deliversUnauthorizedErrorOn401HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: Result<Investor,RemoteAuthService.Error> = .failure(.generic)
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        client.complete(whithStatusCode: 401)
        
        XCTAssertEqual(capturedError, .failure(.unauthorized))
    }
    
    func test_authentication_deliversBadRequestErrorOn400HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: Result<Investor,RemoteAuthService.Error> = .failure(.generic)
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        client.complete(whithStatusCode: 400)
        
        XCTAssertEqual(capturedError, .failure(.badRequest))
    }
    
    func test_authentication_deliversForbiddenErrorOn403HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: Result<Investor,RemoteAuthService.Error> = .failure(.generic)
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        client.complete(whithStatusCode: 403)
        
        XCTAssertEqual(capturedError, .failure(.forbidden))
    }
    
    func test_authentication_deliversErrorOn200HttpResponseWithInvalidData() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedError: Result<Investor,RemoteAuthService.Error> = .failure(.generic)
        sut.authenticate(email: email, password: password) { error in capturedError = error
        }
        
        let invalidJSON = Data("Invalid json".utf8)
        client.complete(whithStatusCode: 200,data: invalidJSON)
        
        XCTAssertEqual(capturedError, .failure(.invalidData))
    }
    
    
    // MARK: - Helpers
    private func makeSUT(endpointURL: URL = URL(string: "https://test-authentication.com")! ) -> (sut: RemoteAuthService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteAuthService(endpointURL: endpointURL,client: client)
        return (sut,client)
    }
    
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
    
}

