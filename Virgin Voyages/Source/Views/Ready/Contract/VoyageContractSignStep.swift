//
//  VoyageContractReviewStep.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/31/24.
//

import SwiftUI
import VVUIKit

struct VoyageContractSignStep: View {
	var authenticationService: AuthenticationServiceProtocol = AuthenticationService.shared
	@Environment(\.contentSpacing) var spacing
	@Environment(\.dismiss) var dismiss
	@Bindable var contract: VoyageContractTask
	@State private var screenTask = ScreenTask()
	@State private var expanded = true
    @State private var pdfData: Data?
    @State private var showPDF = false
    @State private var downloadTask = ScreenTask()

    var body: some View {
		SailableReviewStepScrollable {
			VStack(alignment: .leading, spacing: spacing) {
				Text(contract.content.contractStartPage.title)
					.fontStyle(.largeTitle)
				Text(contract.string)
					.fontStyle(.lightBody)
				
				if contract.numberOfDependents > 0 {
					VStack(alignment: .leading, spacing: spacing * 1.5) {
						VSpacer(spacing)
						ThinDoubleDivider()
						
						VStack(alignment: .leading, spacing: spacing) {
							Button {
								expanded.toggle()
							} label: {
								HStack {
									Text(contract.content.dependentPage.title)
										.fontStyle(.headline)
									
									Spacer()
									
									Image(systemName: expanded ? "chevron.down" : "chevron.up")
										.imageScale(.small)
								}
							}
							.tint(.primary)
							
							Text(contract.content.dependentPage.description)
								.fontStyle(.subheadline)
								.foregroundStyle(.secondary)
							
							if expanded {
								ForEach($contract.dependents) { $dependent in
									Toggle(isOn: $dependent.selected) {
										HStack {
											if let url = dependent.imageUrl {
												ProgressImage(url: url)
													.frame(width: 40, height: 40)
											}
											
											Text(dependent.name)
										}
									}
									.fontStyle(.body)
								}
								
								if contract.alreadySignedDependents.count > 0 {
									Text(contract.content.dependentPage.alreadySignedTitle)
										.fontStyle(.subheadline)
										.foregroundStyle(.secondary)
									
									ForEach(contract.alreadySignedDependents) { dependent in
										HStack {
											if let url = dependent.imageUrl {
												ProgressImage(url: url)
													.frame(width: 40, height: 40)
											}
											
											Text(dependent.name)
											Spacer()
											Image(systemName: "checkmark.circle.fill")
												.imageScale(.large)
												.foregroundStyle(.green)
										}
										.opacity(0.6)
									}
								}
							}
						}
						
						ThinDoubleDivider()
					}
					.animation(.easeInOut, value: expanded)
				}

                VSpacer(spacing)

                Text(contract.content.dependentPage.question)
                    .fontStyle(.boldTagline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.lightGreyColor)
                VSpacer(spacing)

				TaskButton(title: "Sign contract", task: screenTask) {
					try await authenticationService.currentSailor().sign(voyageContract: contract, signed: true)
					dismiss()
				}
				.buttonStyle(PrimaryButtonStyle())
				
				Button("Not right now") {
					contract.startOver()
				}
				.buttonStyle(TertiaryButtonStyle())
			}
		}
        .sheet(isPresented: $showPDF) {
            if let pdfData = pdfData {
                PDFViewerWithShare(pdfData: pdfData)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                downloadContractButton()
            }
        }
    }

    fileprivate func downloadContractButton() -> some View {
        TaskButton(systemImage: "arrow.down.to.line", task: downloadTask) {
            pdfData = try await authenticationService.currentSailor().downloadContract(voyageContract: contract)
            showPDF.toggle()
        }
        .padding(.trailing)
        .fontWeight(.regular)
        .foregroundStyle(.black, .clear)
    }
}
