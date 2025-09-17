//
//  HTTPURLResponse+printJsonBody.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 23.1.25.
//

import Foundation

extension HTTPURLResponse {
    /// Prints the HTTP response body as JSON.
    /// - Parameter data: The response body `Data` returned from the network call.
    func printResponse(from data: Data) {
        print("HTTP Status Code: \(self.statusCode)")

        // Attempt to decode the data as JSON
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyPrintedData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let jsonString = String(data: prettyPrintedData, encoding: .utf8) {
                print("Response Body (JSON):\n\(jsonString)")
            } else {
                print("Failed to convert JSON data to String.")
            }
        } catch {
            print("Failed to parse response body as JSON: \(error.localizedDescription)")

            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body String:\n\(responseString)")
            }
        }
    }
}
