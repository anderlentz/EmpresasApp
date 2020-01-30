//
//  HomeViewController.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationLayout()
       
  
    }
    
    // MARK: - Helpers
    private func setupNavigationLayout() {
        
        // Color and appearence
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named:"darkishPink")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.lightText] // With a red background, make the title more readable.
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        
        // Title image
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 25))
        imageView.contentMode = .scaleAspectFit

        let image = UIImage(named: "logoNav")
        imageView.image = image

        navigationItem.titleView = imageView
    }

}
