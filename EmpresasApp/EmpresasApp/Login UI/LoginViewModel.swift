//
//  LoginViewModel.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol {
    typealias Observer<T> = (T) -> Void
    
    var onLogginStateChange: Observer<Bool>? { get set }
    var onInvestorLogin: Observer<Investor>? { get set }
    var onChange: Observer<LoginViewModel>? { get set }
    func doLogin(email: String, password: String)
}

final class LoginViewModel: LoginViewModelProtocol {
    var onLogginStateChange: Observer<Bool>?
    var onInvestorLogin: Observer<Investor>?
    var onChange: Observer<LoginViewModel>?
    
    private let authenticationService: AuthenticationService
    
    init (authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    private(set) var isLogging: Bool = false {
        didSet {onChange?(self)}
    }
    
    func doLogin(email: String, password: String) {
        onLogginStateChange?(true)
        authenticationService.authenticate(email: email,password: password) { [weak self] result in
            print("authenticationService result \(result)")
            switch result {
            case .success(let investor):
                self?.onInvestorLogin?(investor)
            case .failure(let error):
                print("Inform view that an error has occuried, \(error)")
            }
            self?.onLogginStateChange?(false)
        }
    }
    
}
