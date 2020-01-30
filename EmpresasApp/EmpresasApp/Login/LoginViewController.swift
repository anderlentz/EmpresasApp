//
//  LoginViewController.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
