//
//  DownloadFileRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 25.10.24.
//

import Foundation

struct DownloadFileRequest: AuthenticatedFileRequestProtocol {
    var fileURL: String
}

extension NetworkServiceProtocol {
    func downloadFile(fileURL: String) async -> ApiResponse<Data?> {
        let request = DownloadFileRequest(fileURL: fileURL)
        return await self.downloadFile(autheticatedFileRequest: request)
    }
}
