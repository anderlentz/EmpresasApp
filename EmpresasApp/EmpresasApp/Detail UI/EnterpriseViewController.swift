//
//  EnterpriseViewController.swift
//  EmpresasApp
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class EnterpriseViewController: UIViewController {
    
    var enterprise: Enterprise?

    
    @IBOutlet weak var enterpriseDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationLayout()
                
        if let description = enterprise?.enterprisDescription {
            enterpriseDescriptionLabel.text = description
        }
    }
    
    private func setupNavigationLayout() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named:"darkishPink")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.title = enterprise?.enterpriseName
    }
}
