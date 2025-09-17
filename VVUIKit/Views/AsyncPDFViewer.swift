//
//  AsyncPDFViewer.swift
//  VVUIKit
//
//  Created by Pajtim on 4.5.25.
//

import SwiftUI
import PDFKit

public struct AsyncPDFViewer: View {
    @State private var document: PDFDocument?
    @State private var isLoading = true

    let url: URL?
    let action: () -> Void

    public init(url: URL?, action: @escaping () -> Void) {
        self.url = url
        self.action = action
    }

    public var body: some View {
        LoaderWrapper(isLoading: isLoading) {
            VStack {
                HStack {
                    Spacer()
                    SailableCloseButton(action: action)
                        .padding(EdgeInsets(top: 24.0, leading: 16.0, bottom: 0, trailing: 16))
                }

                if let document = document {
                    PDFKitView(document: document)
                } else {
                    EmptyView()
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: [.bottom])
        }
        .onAppear(perform: loadPDF)
    }

    private func loadPDF() {
        DispatchQueue.global(qos: .background).async {
            if let url {
                let doc = PDFDocument(url: url)
                DispatchQueue.main.async {
                    self.document = doc
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    AsyncPDFViewer(url: URL(fileURLWithPath: ""), action: {})
}
