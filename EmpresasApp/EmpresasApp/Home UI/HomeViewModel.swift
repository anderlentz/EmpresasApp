//
//  HomeViewModel.swift
//  EmpresasApp
//
//  Created by Anderson on 31/01/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

final class HomeViewModel {
    let enterpriseService: EnterpriseService
    
    // We keep track of the pending work item as a property
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    init(enterpriseService: EnterpriseService) {
        self.enterpriseService = enterpriseService
    }
    
    func getAllEnterprises(enterpriseName: String) {
        
        pendingRequestWorkItem?.cancel()
        if enterpriseName.count >= 3 {
            // Wrap our request in a work item
            let requestWorkItem = DispatchWorkItem { [weak self] in
                self?.enterpriseService.getEnterprises(containingName: enterpriseName) { result in
                    //print(result)
                }
            }

            // Save the new work item and execute it after 300 ms
            pendingRequestWorkItem = requestWorkItem
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300),
                                      execute: requestWorkItem)
        }
    }
}
