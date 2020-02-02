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
        
        navigationController?.title = enterprise?.enterpriseName
        
        if let description = enterprise?.enterprisDescription {
            enterpriseDescriptionLabel.text = description
        }
    }
}
