//
//  PdfViewer.swift
//  Virgin Voyages
//
//  Created by Pajtim on 29.11.24.
//

import SwiftUI
import PDFKit

public struct PDFViewerWithShare: View {
    let pdfData: Data
    @State private var showShareSheet = false

    public init(pdfData: Data, showShareSheet: Bool = false) {
        self.pdfData = pdfData
        self.showShareSheet = showShareSheet
    }

    public var body: some View {
        VStack {
            if let document = PDFDocument(data: pdfData) {
                PDFKitView(document: document)
                    .edgesIgnoringSafeArea(.all)
            }

            Button(action: {
                showShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .trailing)
            .foregroundColor(.blue)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [pdfData])
        }
    }
}
#Preview {
    Color.clear.sheet(isPresented: .constant(true)) {
        PDFViewerWithShare(pdfData: Data())
    }
}
