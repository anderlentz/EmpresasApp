//
//  EnterpriseViewController.swift
//  EmpresasApp
//
//  Created by Anderson on 02/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class EnterpriseViewController: UIViewController {
    
    var enterprise: Enterprise
    var coordinator: EnterpriseDetailsCoordinator?
    
    @IBOutlet weak var enterpriseDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, enterprise: Enterprise) {
        self.enterprise = enterprise
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an enterprise")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationLayout()
        
        // Set description content
        enterpriseDescriptionLabel.text = enterprise.enterprisDescription
        
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
        navigationItem.title = enterprise.enterpriseName
    }
}
