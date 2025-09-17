//
//  Utilities.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.10.24.
//

import UIKit

func callPhone(number: String) {
    if let phoneURL = URL(string: "tel://\(number)") {
        if UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Phone call not available.")
        }
    }
}

func getQueryParameter(from urlString: String, parameterName: String) -> String? {

    guard let urlComponents = URLComponents(string: urlString) else { return nil }

    if let value = urlComponents.queryItems?.first(where: { $0.name == parameterName })?.value {
        return value
    }

    if let nestedLink = urlComponents.queryItems?.first(where: { $0.name == "link" })?.value,
       let decodedNestedLink = nestedLink.removingPercentEncoding,
       let nestedURLComponents = URLComponents(string: decodedNestedLink) {
        return nestedURLComponents.queryItems?.first(where: { $0.name == parameterName })?.value
    }

    return nil
}

func sendMail(to email: String, subject: String, body: String) {
    guard
        let subject = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
        let body = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    else {
        print("Error: Can't encode subject or body.")
        return
    }

    let urlString = "mailto:\(email)?subject=\(subject)&body=\(body)"
    if let mailURL = URL(string: urlString) {
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
        } else {
            print("Sending mail is not available.")
        }
    }
}
