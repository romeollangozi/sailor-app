//
//  PDFKitView.swift
//  VVUIKit
//
//  Created by Pajtim on 4.5.25.
//

import SwiftUI
import PDFKit

public struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    public init(document: PDFDocument) {
        self.document = document
    }

    public func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = document
        return pdfView
    }

    public func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}

#Preview {
    PDFKitView(document: PDFDocument(url: URL(fileURLWithPath: ""))!)
}
