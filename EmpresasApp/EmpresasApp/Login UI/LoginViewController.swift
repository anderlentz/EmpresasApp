//
//  LoginViewController.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

protocol LoginViewModelProtocol {
    var onLogginStateChange: ((Bool) -> Void)? { get set }
    var onInvestorLogin: ((Investor) -> Void)? { get set }
    var onChange: ((LoginViewModel) -> Void)? { get set }
    
    func doLogin(email: String, password: String)
}

final class LoginViewModel: LoginViewModelProtocol {
    var onLogginStateChange: ((Bool) -> Void)?
    var onInvestorLogin: ((Investor) -> Void)?
    var onChange: ((LoginViewModel) -> Void)?
    
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
            switch result {
            case .success(let investor):
                print("Do something, \(investor)")
                self?.onInvestorLogin?(investor)
            case .failure(let error):
                print("Inform view that an error has occuried, \(error)")
            }
            self?.onLogginStateChange?(false)
        }
    }
    
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    public var viewModel: LoginViewModelProtocol?
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - IBActions
    @IBAction func loginButtonAction(_ sender: UIButton) {
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //it doens not work on viewDidLoad
        setupTextFieldLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    // MARK: - Helpers
    
    private func addOnLeft(of textField: UITextField,anImage img: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
        imageView.image = img
        textField.leftView = imageView
        textField.leftView?.contentMode = .scaleAspectFit
        textField.leftViewMode = .always
    }
    
    private func addBottonLine(on textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(named: "CharcoalGrey")?.cgColor
        textField.borderStyle = UITextField.BorderStyle.none
        textField.layer.addSublayer(bottomLine)
    }
    
    func setupTextFieldLayout() {
        
        // Set image on text fields
        if let emailImage = UIImage(named: "icEmail") {
             addOnLeft(of: emailTextField, anImage: emailImage)
        }
        
        if let passwordImage = UIImage(named: "icCadeado") {
             addOnLeft(of: passwordTextField, anImage: passwordImage)
        }
        
        //Add botton line
        addBottonLine(on: emailTextField)
        addBottonLine(on: passwordTextField)
    }
}
