//
//  RemoteEnterpriseServiceTests.swift
//  EmpresasAppTests
//
//  Created by Anderson on 01/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp

protocol EnterpriseService {
    func getAllEnterprises(completion: @escaping (Result<[Enterprise],RemoteEnterpriseService.EnterpriseServiceError>) -> Void)
}

protocol EnterpriseHTTPClient {
    func get(from urlRequest: URLRequest, completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void)
}

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
            case .success(let (_,response)):
                switch response.statusCode {
                case 401:
                    completion(.failure(.unauthorized))
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

class RemoteEnterpriseServiceTests: XCTestCase {

    func test_init_constructsGetRequestToEndpointURL() {
        let endpointURL = makeEndpointURL()
        
        let (sut,_) = makeSUT(endpointURL: endpointURL)
        
        XCTAssertEqual(sut.requestURL.url, endpointURL)
        XCTAssertEqual(sut.requestURL.httpMethod, "GET")
    }
    
    func test_getAllEnterprise_performGETrequestToEndpointURL() {
        
        var requestURL = URLRequest(url: makeEndpointURL())
        requestURL.httpMethod = "GET"
        let (sut,client) = makeSUT(endpointURL: makeEndpointURL())
        
        sut.getAllEnterprises(){ _ in }
        
        XCTAssertEqual(client.urlRequest?.url, makeEndpointURL())
        XCTAssertEqual(client.urlRequest?.httpMethod, "GET")
    }
    
    func test_getAllEnterprises_requestWithAllRequideAuthenticationKeysIntoHTTPResquestHeader() {
        
        var requestURL = URLRequest(url: makeEndpointURL())
        requestURL.httpMethod = "GET"
        requestURL.allHTTPHeaderFields = ["access-token":"",
                                          "client":"",
                                          "uid":""]
        let (sut,client) = makeSUT(endpointURL: makeEndpointURL())
       
        sut.getAllEnterprises(){ _ in }
                
        XCTAssertNotNil(client.urlRequest?.value(forHTTPHeaderField: "access-token"),"Must have an access-token property at header")
        XCTAssertNotNil(client.urlRequest?.value(forHTTPHeaderField: "client"),"Must have a client property at header")
        XCTAssertNotNil(client.urlRequest?.value(forHTTPHeaderField: "uid"),"Must have an uid property at header")
        
    }
    
    func test_getAllEnterprises_requestWithAuthStateValuesAtAuthenticationKeysIntoHTTPRequestHeader() {
        let authenticateState = makeAuthState()
        let (sut,client) = makeSUT(endpointURL: makeEndpointURL(), authState: authenticateState)
        
        sut.getAllEnterprises(){ _ in }
        
        XCTAssertEqual(client.urlRequest?.value(forHTTPHeaderField: "access-token"), authenticateState.accessToken)
        XCTAssertEqual(client.urlRequest?.value(forHTTPHeaderField: "client"), authenticateState.client)
        XCTAssertEqual(client.urlRequest?.value(forHTTPHeaderField: "uid"), authenticateState.uid)
    }
    
    func test_getAllEnterprises_deliversErrorOnConnectivityError() {
        let (sut, client) = makeSUT(endpointURL: makeEndpointURL())
        var capturedResult: Result<[Enterprise],RemoteEnterpriseService.EnterpriseServiceError>?
        
        sut.getAllEnterprises() { result in
            capturedResult = result
        }
        
        let clientError = NSError(domain: "test", code: 0)
        client.complete(whith: clientError)
        
        XCTAssertEqual(capturedResult, .failure(.connectivity))
    }
    
    func test_authentication_deliversUnauthorizedErrorOn401HttpResponse() {
        let (sut, client) = makeSUT(endpointURL: makeEndpointURL())
        var capturedResult: Result<[Enterprise],RemoteEnterpriseService.EnterpriseServiceError>?
        
        sut.getAllEnterprises() { result in
            capturedResult = result
        }
        
        client.complete(withStatusCode: 401)
        
        XCTAssertEqual(capturedResult, .failure(.unauthorized))
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(endpointURL: URL, authState: AuthState = AuthState(accessToken: nil, client: nil, uid: nil))
        -> (sut: RemoteEnterpriseService, client: EnterpriseHTTPClientSpy) {
            
        let client = EnterpriseHTTPClientSpy()
        let sut = RemoteEnterpriseService(endpointURL: endpointURL,client: client, authState: authState)
        return (sut,client)
    }
    
    private func makeEndpointURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
    private func makeAuthState() -> AuthState {
        return AuthState(accessToken: "access_token_test", client: "client_test", uid: "uid")
    }
    
    private func makeGetEnterprisesURLRequest() -> URLRequest {
        
        var urlRequest = URLRequest(url: makeEndpointURL())
        let headers = ["access-token":"",
        "client":"",
        "uid":""]
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
}

private class EnterpriseHTTPClientSpy: EnterpriseHTTPClient {
    var message: ((Result<(Data,HTTPURLResponse), Error>) -> Void) = { _ in}
    var urlRequest: URLRequest?
    
    func get(from urlRequest: URLRequest,completion: @escaping (Result<(Data,HTTPURLResponse),Error>) -> Void) {
        self.urlRequest = urlRequest
        self.message = completion
    }
    
    func complete(whith error: Error) {
        message(.failure(error))
    }
    
    func complete(withStatusCode: Int) {
        let anyURL = URL(string:"https://any-url.com")!
        let response = HTTPURLResponse(url: anyURL,
        statusCode: withStatusCode,
        httpVersion: nil,
        headerFields: nil)!
        
        message(.success((Data(), response)))
    }
}
