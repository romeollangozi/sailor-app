//
//  UploadMediaRequest.swift
//  Virgin Voyages
//
//  Created by Pajtim on 12.3.25.
//

import Foundation

struct UploadMediaRequest: AuthenticatedHTTPRequestProtocol {
    var imageData: Data

    var path: String {
        return NetworkServiceEndpoint.uploadImagePath
    }

    var method: HTTPMethod {
        return .POST
    }

    var headers: (any HTTPHeadersProtocol)? {
        guard let token = self.tokenManager.token?.accessToken else { return nil }
        return HTTPHeaders(["Content-Type": "multipart/form-data",
                            "Authorization": "Bearer \(token)",
                           ])
    }

    var queryItems: [URLQueryItem]? {
        let mediagroupid: URLQueryItem = .init(name: "mediagroupid", value: ConstantParameters.mediagroupid)
        return [mediagroupid]
    }

    var body: [String : Any]? {
        return ["imageData": imageData]
    }
    
    var timeoutInterval: TimeInterval {
        return 120.0
    }
}

extension NetworkServiceProtocol {
    func uploadMedia(imageData: Data) async throws -> String? {
        let request = UploadMediaRequest(imageData: imageData)
        return try await mediaUploadRequest(request, responseModel: String.self)
    }
}
