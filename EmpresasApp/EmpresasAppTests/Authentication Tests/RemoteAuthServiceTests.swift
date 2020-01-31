//
//  RemoteAuthService.swift
//  EmpresasAppTests
//
//  Created by Anderson on 29/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import XCTest
@testable import EmpresasApp


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
        
        var capturedResult: Result<Investor,RemoteAuthService.AuthenticationError> = .failure(.generic)
        
        sut.authenticate(email: email, password: password) { result in capturedResult = result
        }
        
        let clientError = NSError(domain:"Test",code:0)
        client.complete(whith: clientError)
        
        XCTAssertEqual(capturedResult,.failure(.connectivity))
    }
    
    func test_authentication_deliversUnauthorizedErrorOn401HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedResult: Result<Investor,RemoteAuthService.AuthenticationError> = .failure(.generic)
        sut.authenticate(email: email, password: password) { result in capturedResult = result
        }
        
        client.complete(whithStatusCode: 401)
        
        XCTAssertEqual(capturedResult, .failure(.unauthorized))
    }
    
    func test_authentication_deliversBadRequestErrorOn400HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedResult: Result<Investor,RemoteAuthService.AuthenticationError> = .failure(.generic)
        sut.authenticate(email: email, password: password) { result in capturedResult = result
        }
        
        client.complete(whithStatusCode: 400)
        
        XCTAssertEqual(capturedResult, .failure(.badRequest))
    }
    
    func test_authentication_deliversForbiddenErrorOn403HttpResponse() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedResult: Result<Investor,RemoteAuthService.AuthenticationError> = .failure(.generic)
        sut.authenticate(email: email, password: password) { result in capturedResult = result
        }
        
        client.complete(whithStatusCode: 403)
        
        XCTAssertEqual(capturedResult, .failure(.forbidden))
    }
    
    func test_authentication_deliversErrorOn200HttpResponseWithInvalidData() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedResult: Result<Investor,RemoteAuthService.AuthenticationError> = .failure(.generic)
        sut.authenticate(email: email, password: password) { result in capturedResult = result
        }
        
        let invalidJSON = Data("Invalid json".utf8)
        client.complete(whithStatusCode: 200,data: invalidJSON)
        
        XCTAssertEqual(capturedResult, .failure(.invalidData))
    }
    
    func test_authentication_deliversInvestorOn200HttpResponseWithValidJSON() {
        let email = "email@email.com"
        let password = "123123"
        let (sut,client) = makeSUT()
        
        var capturedResults = [Result<Investor,RemoteAuthService.AuthenticationError>]()
        
        sut.authenticate(email: email, password: password) { result in capturedResults.append(result)
        }
        
        client.complete(whithStatusCode: 200, data: makeValidJSONData())
        
        
        XCTAssertEqual(capturedResults, [.success(makeValidInvestor())])
        
    }
    
    // MARK: - Helpers
    private func makeSUT(endpointURL: URL = URL(string: "https://test-authentication.com")! ) -> (sut: RemoteAuthService, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteAuthService(endpointURL: endpointURL,client: client)
        return (sut,client)
    }
    
    private func makeValidInvestor() -> Investor {
        let portfolio = Portfolio(enterprisesNumber: 0, enterprises: [])
        return Investor(id: 1,
                        investorName: "Test Apple",
                        email: "testeapple@ioasys.com.br",
                        city: "BH",
                        country: "Brasil",
                        balance: 350000.0,
                        photo: "/uploads/investor/photo/1/cropped4991818370070749122.jpg",
                        portfolio: portfolio,
                        portfolioValue: 350000.0,
                        firstAccess: false,
                        superAngel: false)
    }
    
    private func makeValidJSONData() -> Data {
        print("entrou")
        
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "validJSON", withExtension: ".json") else {
            XCTFail("Missing file: validJSON.json")
            return Data()
        }
        
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            return data
        } catch let error{
            XCTFail(error.localizedDescription)
        }
        return Data()
    }
    
    
}

