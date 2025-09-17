//
//  MultipartBuilder.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 4/30/25.
//


import Foundation

final class MultipartBuilder {
    func createImageData(imageData: Data, fileName: String, mimeType: String, boundary: String) -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    func createFormData(parameters: [String: String], files: [FileData]?, boundary: String) -> Data {
        var body = Data()
        parameters.forEach {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\($0.value)\r\n".data(using: .utf8)!)
        }
        files?.forEach {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\($0.fieldName)\"; filename=\"\($0.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \($0.mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append($0.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}