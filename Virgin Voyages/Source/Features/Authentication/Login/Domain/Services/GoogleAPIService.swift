//
//  GoogleAPIService.swift
//  Virgin Voyages
//
//  Created by TX on 29.11.24.
//

import Foundation

protocol GoogleAPIServiceProtocol {
    func configure(with accessToken: String)
    func runAPIRequest<T>(request: GoogleAPIServiceRequestType) async -> T?
}

enum GoogleAPIServiceRequestType {
    case fetchBirthdate

    var apiURL: URL {
        switch self {
        case .fetchBirthdate:
            return URL(string: "https://people.googleapis.com/v1/people/me?personFields=birthdays")!
        }
    }
}

class GoogleAPIService: GoogleAPIServiceProtocol {
    
    private var accessToken: String?
    
    func configure(with accessToken: String) {
        self.accessToken = accessToken
    }

    // Run API request based on endpoint type
    func runAPIRequest<T>(request: GoogleAPIServiceRequestType) async -> T? {
        switch request {
        case .fetchBirthdate:
            return await fetchUserBirthdate(requestType: request) as? T
        }
    }
    
    private func requestData(for apiType: GoogleAPIServiceRequestType) async -> Data? {
        
        guard let accessToken else {
            print("GoogleAPIService Error - Service is not configured.")
            return nil
        }
        
        do {
            let urlRequest = URLRequest(url: apiType.apiURL)
            var requestWithHeaders = urlRequest
            requestWithHeaders.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let (data, _) = try await URLSession.shared.data(for: requestWithHeaders)
            return data
        } catch {
            print("GoogleAPIService Error - Failed to fetch birthdate: \(error.localizedDescription)")
            return nil
        }

    }

    // Fetch user birthdate and return Date
    private func fetchUserBirthdate(requestType: GoogleAPIServiceRequestType) async -> Date? {
        guard let data = await requestData(for: requestType) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
        return parseDateFromUsersAccount(from: json)
    }

    private func parseDateFromUsersAccount(from json: [String: Any]) -> Date? {
        
        if let birthdays = json["birthdays"] as? [[String: Any]] {
            // We fetch only birthday of the "ACCOUNT"
            let accountBirthday = birthdays.first { birthday in
                if let metadata = birthday["metadata"] as? [String: Any],
                   let source = metadata["source"] as? [String: Any],
                   let type = source["type"] as? String,
                   type == "ACCOUNT" {
                    return true
                }
                return false
            }
            
            // Extract date from the first available ACCOUNT birthday
            if let date = accountBirthday?["date"] as? [String: Int],
               let year = date["year"], let month = date["month"], let day = date["day"] {
                
                let calendar = Calendar.current
                let dateComponents = DateComponents(year: year, month: month, day: day)
                
                if let birthDate = calendar.date(from: dateComponents) {
                    return birthDate
                }
            } else {
                print("GoogleAPIService Error - No complete birthdate available from ACCOUNT.")
                return nil
            }
        }
        
        print("GoogleAPIService Error - Error parsing birthdate from ACCOUNT. No birthdays found.")
        return nil
    }
}
