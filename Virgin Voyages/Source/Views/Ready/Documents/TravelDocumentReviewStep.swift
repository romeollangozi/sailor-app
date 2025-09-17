//
//  TravelDocumentReviewStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/5/24.
//

import SwiftUI

struct TravelDocumentReviewStep: View {
	@Environment(TravelDocumentTask.self) var travel
	@Environment(\.dismiss) var dismiss
	@Environment(\.contentSpacing) var spacing
	var page: TravelDocumentTask.ReviewPage
	
    var body: some View {
		SailableReviewStepScrollable(imageUrl: page.imageUrl) {
			VStack(alignment: .leading, spacing: spacing) {
				Text(page.title)
					.fontStyle(.largeTitle)
				
				VSpacer(spacing)
				
				VStack(alignment: .leading, spacing: spacing * 2) {
					ForEach(page.documents, id: \.id) { document in
						if let url = document.photo.url {
							VStack(alignment: .leading) {
								Text(travel.documentName(for: document.type))
									.fontStyle(.title)
								VStack(alignment: .trailing) {
                                    ZStack {
                                        AuthenticatedProgressImage(url: url, cornerRadius: 8)

                                        if let sailTask = travel.sailTask, sailTask.isRejected(documentType: document.type.id) {
                                            rejectionView(message: sailTask.failedDocumentErrorText)
                                        }
                                    }

									Button {
										switch document {
										case let passport as TravelDocumentTask.Passport:
											travel.step = .passport(passport)
										case let visa as TravelDocumentTask.Visa:
											travel.step = .visa(visa)
										default:
											break
										}
									} label: {
										Label("Edit", systemImage: "pencil.circle")
									}
								}
							}
						}
					}
				}
				
				if travel.postVoyageIsRequired {
					VSpacer(spacing)
					
					Button {
						travel.step = .postVoyage(.init(content: travel.content.postCruiseInfo))
					} label: {
						HStack {
							VStack(alignment: .leading, spacing: 4) {
								Text(page.postVoyageRowTitle)
									.fontStyle(.headline)
								Text(page.postVoyageRowDescription)
									.fontStyle(.body)
									.foregroundStyle(.secondary)
							}
							.tint(.primary)
							
							Spacer()
							Image(systemName: "arrow.right")
						}
					}
				}
				
				Divider()
				
				Text(page.description.markdown)
					.multilineTextAlignment(.center)
					.fontStyle(.body)
					.foregroundStyle(.secondary)
					.padding()
				
				Button("Ok, got it") {
					dismiss()
				}
				.buttonStyle(PrimaryButtonStyle())
			}
		}
    }
}

extension TravelDocumentReviewStep {
    func rejectionView(message: String?) -> some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 64, height: 64, alignment: .center)
                .foregroundStyle(.white, .orange)

            Text(message ?? "There's an issue with the document(s) you uploaded. Please review and re-upload.")
                .multilineTextAlignment(.center)
                .fontStyle(.subheadline)
                .foregroundStyle(Color.orange)
        }
        .padding(34)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.white, .orange)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}
