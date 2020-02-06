//
//  EnterpriseServiceSpy.swift
//  EmpresasAppTests
//
//  Created by Anderson on 06/02/20.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation
@testable import EmpresasApp

class EnterpriseServiceSpy: EnterpriseService {
    
    var wasCalled = false
    var callingCount = 0
    var onGetEnterprisesCalled: (Int) -> Void = {_ in}
    
    var onCompleteGetEnterprises: ((Result<[Enterprise], RemoteEnterpriseService.EnterpriseServiceError>) -> Void) = { _ in}
    
    
    func completeGetEnterprisesWithSuccess(enterprise: Enterprise) {
        onCompleteGetEnterprises(.success([enterprise]))
      
    }
    
    func completeGetEnterprisesWithEmptyEnterprises() {
        onCompleteGetEnterprises(.success([]))
      
    }
    
    func completeGetEnterprisesWithError(error: RemoteEnterpriseService.EnterpriseServiceError) {
        onCompleteGetEnterprises(.failure(error))
    }
    
    func getEnterprises(containingName: String, completion: @escaping (Result<[Enterprise], RemoteEnterpriseService.EnterpriseServiceError>) -> Void) {
        wasCalled = true
        callingCount += 1
        onGetEnterprisesCalled(callingCount)
        
        onCompleteGetEnterprises = completion
    }
}
