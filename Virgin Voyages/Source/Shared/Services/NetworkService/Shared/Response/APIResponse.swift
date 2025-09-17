//
//  APIResponse.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 16.10.24.
//

import Foundation

struct ApiResponse<T> {
    var response:T?
    var error: NetworkServiceError?
}
