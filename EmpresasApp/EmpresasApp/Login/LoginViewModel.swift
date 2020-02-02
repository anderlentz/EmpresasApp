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
    
    var onAuthenticationError: Observer<String>? { get set }
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
    var onAuthenticationError: Observer<String>?
    
    private let authenticationService: AuthenticationService
    private(set) var isLogging: Bool = false {
        didSet {onChange?(self)}
    }
    
    enum ErrorMessage: String {
        case onAuthenticationFailure = "Não foi possível realizar o login. Verifique se os dados informados estão corretos."
        case onEmptyEmail = "Email não pode ser vazio"
        case onInvalidEmail = "Digite um email válido."
        case onEmptyPassword = "Password não pode ser vazio."
        case onPasswordWithWhitespace = "Password não pode conter espaços."
        
    }
    
    init (authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
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
                case .failure:
                    self?.onAuthenticationError?(ErrorMessage.onAuthenticationFailure.rawValue)
                }
                self?.onLogginStateChange?(false)
            }
        } else {
            sendErrorsMessage(errors: errors)
            onLogginStateChange?(false)
        }
    }
    
    // MARK: - Helpers
    private func validate(email: String, password: String) -> (emailError: String?, passwordError: String?) {
        
        var errors: (emailError: String?, passwordError: String?)
        
        if email.isEmpty {
            errors.emailError = ErrorMessage.onEmptyEmail.rawValue
        } else if !isValidEmail(email: email) {
            errors.emailError = ErrorMessage.onInvalidEmail.rawValue
        }
        if password.isEmpty {
            errors.passwordError = ErrorMessage.onEmptyPassword.rawValue
        } else {
            if password.trimmingCharacters(in: .whitespaces).isEmpty {
                errors.passwordError = ErrorMessage.onPasswordWithWhitespace.rawValue
            }
        }
        
        return errors
    }
    
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func sendErrorsMessage (errors: (emailError: String?, passwordError: String?)){
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
