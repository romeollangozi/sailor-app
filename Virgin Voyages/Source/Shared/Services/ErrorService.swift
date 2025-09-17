//
//  ErrorService.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 6.11.24.
//

import Observation

protocol ErrorServiceProtocol {
    var error: VVDomainError? { get set }
}

@Observable class ErrorService: ErrorServiceProtocol {

    static var shared = ErrorService()

    var error: VVDomainError?

}
