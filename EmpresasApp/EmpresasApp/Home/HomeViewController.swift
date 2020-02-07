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
    public var navigationCoordinator: HomeCoordinator?
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel: HomeViewModelProtocol?
    private var enterprises: [Enterprise]?
    
    // MARK: - IBOutles
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var initialBackgroundView: UIView!
    @IBOutlet var noEnterprisesBackgroundView: UIView!
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        noEnterprisesBackgroundView.accessibilityIdentifier = ""
        setupSearchController()
        setupNavigationLayout()
                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = initialBackgroundView
                
        viewModel?.onEnterprisesLoad = { [weak self] enterprises in
            self?.enterprises = enterprises
            DispatchQueue.main.async {
                self?.tableView.backgroundView?.isHidden = true
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.onEmptyEnterprisesLoad = {
            DispatchQueue.main.async { [weak self] in
                self?.showEmptyEnterprisesBackgroundResult()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.changeClearIconColor()
        }
    }
 
    // MARK: - Helpers
    
    func showEmptyEnterprisesBackgroundResult() {
        self.tableView.backgroundView = self.noEnterprisesBackgroundView
        self.tableView.reloadData()
    }
    
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
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        // Pink color search bar background
        searchController.searchBar.barTintColor = UIColor(named: "darkishPink")
        
        // White background on search text
        searchController.searchBar.searchTextField.backgroundColor = .white
        
        // Cursor color to brown grey
        searchController.searchBar.searchTextField.tintColor = UIColor(named: "brownGrey")
        
        // Keep text at searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        
        // Set Cancel button color to white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getAllEnterprises(enterpriseName: searchText)
    }
}

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enterprises?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "enterpriseCell", for: indexPath)
            as! EnterpriseTableViewCell
        cell.enterpriseName.text = enterprises?[indexPath.row].enterpriseName
        cell.businessLabel.text = enterprises?[indexPath.row].enterpriseType.enterpriseTypeName
        cell.countryLabel.text = enterprises?[indexPath.row].country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let enterprise = enterprises?[indexPath.row] {
            navigationCoordinator?.performTransition(transition: HomeCoordinatorTransition.showEnterpriseDetails(enterprise))
        }
    }
}
