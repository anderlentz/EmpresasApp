//
//  HomeViewController.swift
//  EmpresasApp
//
//  Created by Anderson on 30/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - IBActions
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(strongSelf.searchController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationLayout()
        setupSearchController()
        
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
    
    private func setupSearchController() {
        
        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        //navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        // Pink color search bar background
        searchController.searchBar.barTintColor = UIColor(named: "darkishPink")
        
        // White background on search text
        searchController.searchBar.searchTextField.backgroundColor = .white
        
        // Cursor color to brown grey
        searchController.searchBar.searchTextField.tintColor = UIColor(named: "brownGrey")
        
        // Set Cancel button color to white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)
        
        changeClearIconColor()
    }
    
    private func changeClearIconColor() {
        
        let clearImage = UIImage(systemName: "xmark.circle.fill")
        searchController.searchBar.setImage(clearImage, for: .clear, state: .normal)
        
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField, let clearButton = searchTextField.value(forKey: "clearButton") as? UIButton {
           // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
           // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
           // Finally, set the image color
           clearButton.tintColor = UIColor(named: "darkishPink")
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
}
