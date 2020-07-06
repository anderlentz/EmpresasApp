//
//  LoginViewController.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    // Exposed as public so that we can inject these dependencies on LoginUIComposer
    public var viewModel: LoginViewModelProtocol?
    public var navigationCoordinator: LoginCoordinator?
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginIndicatorView: UIView!
    
   
    // MARK: - IBActions
    @IBAction func loginButtonAction(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            viewModel?.doLogin(email: email, password: password)
        }
    }
    
    // MARK: - Overriden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loginIndicatorView?.isHidden = true
        
        viewModel?.onLogginStateChange = {[weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.loginIndicatorView.isHidden = false
                } else {
                    self?.loginIndicatorView.isHidden = true
                }
            }
        }
        
        viewModel?.onInvestorLogin = { [weak self] loggedInvestor in
            DispatchQueue.main.async {
                self?.navigationCoordinator?.performTransition(transition: .showHomeView)
            }
        }
        
        viewModel?.onLoginValidationError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrosAlert(title: "Credenciais inválidas",message: errorMessage)
            }
        }
        
        viewModel?.onAuthenticationError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrosAlert(title: "Falha na autenticação",message: errorMessage)
            }
        }
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
    
    private func showErrosAlert(title: String,message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
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
