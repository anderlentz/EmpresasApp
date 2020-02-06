//
//  HomeViewModel.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    typealias Observer<T> = (T) -> Void
    
    
    var onEnterprisesLoad: Observer<[Enterprise]>? {get set}
    var onErrorLoad: Observer<String>?  {get set}
    var onChange: Observer<HomeViewModel>?  {get set}
    
    func getAllEnterprises(enterpriseName: String) 
}

final class HomeViewModel: HomeViewModelProtocol {
    
    var onEnterprisesLoad: Observer<[Enterprise]>?
    var onErrorLoad: Observer<String>?
    var onChange: Observer<HomeViewModel>?
    
    private let enterpriseService: EnterpriseService
    
    // We keep track of the pending work item as a property
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    init(enterpriseService: EnterpriseService) {
        self.enterpriseService = enterpriseService
    }
    
    func getAllEnterprises(enterpriseName: String) {
        
        pendingRequestWorkItem?.cancel()
        if enterpriseName.count >= 1 {
            // Wrap our request in a work item
            let requestWorkItem = DispatchWorkItem { [weak self] in
            
                self?.enterpriseService.getEnterprises(containingName: enterpriseName) { [weak self] result in
                    switch result {
                    case .success(let enterprises):
                        self?.onEnterprisesLoad?(enterprises)
                    case .failure(let error):
                        self?.onErrorLoad?("Algo deu errado, tente novamente.")
                        print("Inform view that an error has occuried, \(error)")
                    }
                }
            }

            // Save the new work item and execute it after 300 ms
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
        }
    }
}
