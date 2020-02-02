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
    var onLoginValidationError: Observer<String>? { get set }
    func doLogin(email: String, password: String)
}

final class LoginViewModel: LoginViewModelProtocol {
    var onLogginStateChange: Observer<Bool>?
    var onInvestorLogin: Observer<Investor>?
    var onChange: Observer<LoginViewModel>?
    var onLoginValidationError: Observer<String>?
    
    private let authenticationService: AuthenticationService
    
    init (authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    private(set) var isLogging: Bool = false {
        didSet {onChange?(self)}
    }
    
    func doLogin(email: String, password: String) {
        onLogginStateChange?(true)
        let errors = validate(email: email, password: password)
        
        if errors == (nil,nil) {
            onLogginStateChange?(true)
            authenticationService.authenticate(email: email,password: password) { [weak self] result in
                switch result {
                case .success(let investor):
                    self?.onInvestorLogin?(investor)
                case .failure(let error):
                    print("Inform view that an error has occuried, \(error)")
                }
                self?.onLogginStateChange?(false)
            }
        } else {
            sendErrorsMessage(errors: errors)
            onLogginStateChange?(false)
        }
    }
    
    func validate(email: String, password: String) -> (emailError: String?, passwordError: String?) {
        
        var errors: (emailError: String?, passwordError: String?)
        
        if email.isEmpty {
            errors.emailError = "Email não pode ser vazio"
        } else if !isValidEmail(email: email) {
            errors.emailError = "Digite um email válido."
        }
        if password.isEmpty {
            errors.passwordError = "Password não pode ser vazio."
        } else {
            if password.trimmingCharacters(in: .whitespaces).isEmpty {
                errors.passwordError = "Password não conter espaços."
            }
        }
        
        return errors
    }
    
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func sendErrorsMessage (errors: (emailError: String?, passwordError: String?)){
        switch errors {
        case (let .some(emailError), let .some(passwordError)):
            onLoginValidationError?(" - \(emailError)\n - \(passwordError)")
        case (_, let .some(passwordError)):
            onLoginValidationError?("- \(passwordError)")
        case (let .some(emailError), _):
            onLoginValidationError?("- \(emailError)")
        default:
            break
        }
    }
}

extension String {
    var isEmptyOrWhitespace : Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
