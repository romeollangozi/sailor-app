//
//  FolioImageUseCase.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 8.7.25.
//

import Foundation

protocol FolioImageUseCaseProtocol {
    func authenticatedImageURL(from urlString: String?) -> URL?
}

final class FolioImageUseCase: FolioImageUseCaseProtocol {
    
    // MARK: - Properties
    private let tokenManager: TokenManagerProtocol
    
    // MARK: - Init
    init(tokenManager: TokenManagerProtocol = TokenManager()) {
        self.tokenManager = tokenManager
    }
    
    func authenticatedImageURL(from urlString: String?) -> URL? {
        guard
            let urlString, !urlString.isEmpty,
            var components = URLComponents(string: urlString),
            let token = tokenManager.token?.accessToken
        else {
            return nil
        }
        
        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: "access_token", value: token))
        components.queryItems = queryItems
        
        return components.url
    }
}
