//
//  EnterpriseTableViewCell.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class EnterpriseTableViewCell: UITableViewCell {

    @IBOutlet weak var enterpriseImage: UIImageView!
    @IBOutlet weak var enterpriseName: UILabel!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
