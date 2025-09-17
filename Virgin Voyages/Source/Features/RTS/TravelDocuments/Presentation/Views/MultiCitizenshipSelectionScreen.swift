//
//  MultiCitizenshipSelectionScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.8.25.
//

import SwiftUI
import VVUIKit

struct MultiCitizenshipSelectionScreen: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let description: String
    let buttonTitle: String
    let options: [String: String]
    @State private var screenState: ScreenState = .content
    @Binding var selectedCitizenshipCode: String?
    @State private var selection: String? = nil
    @State private var showError = false
    let onSave: () -> Void
    
    init(title: String, description: String, buttonTitle: String, options: [String: String], selectedCitizenshipCode: Binding<String?>, onSave: @escaping () -> Void) {
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.options = options
        self._selectedCitizenshipCode = selectedCitizenshipCode
        self.selection = selectedCitizenshipCode.wrappedValue
        self.onSave = onSave

    }

    var body: some View {
        DefaultScreenView(state: $screenState, toolBarOptions: ToolBarOption(
            onCloseTapped: { dismiss() }
        )){
            VStack(alignment: .leading, spacing: Spacing.space24) {
               
                Text(title)
                    .font(.vvHeading3Bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                Text(description)
                    .font(.vvSmall)
                    .foregroundStyle(.vvDarkGray)
                    .padding(.trailing, Spacing.space12)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                if showError {
                   errorView()
               }
                VVRadioGroup(
                    label: "",
                    options: options.map { .init(value: $0.key, label: $0.value) },
                    selected:  Binding(
                        get: { selection ?? "" },
                        set: { newValue in
                            selection = newValue
                        }
                    ),
                    errorMessage: "",
                    required: false
                )
                .padding(.top, -Spacing.space32)
                
                Button(buttonTitle) {
                    if let selected = selection, !selected.isEmpty {
                        selectedCitizenshipCode = selected
                        onSave()
                        dismiss()
                    } else {
                        showError = true
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
        } onRefresh: { }
        .presentationDetents([.height(600)])
    }
    
    private func errorView() -> some View {
        HStack(alignment: .top, spacing: Spacing.space12){
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 24, height: 24, alignment: .center)
                .foregroundStyle( Color.lightError)
            VStack(alignment: .leading){
                Text("There is a problem")
                    .multilineTextAlignment(.center)
                    .font(.vvSmallBold)
                    .foregroundStyle(Color.lightError)
                Text("Please select one of the passport types")
                    .multilineTextAlignment(.center)
                    .font(.vvSmall)
                    .foregroundStyle(Color.lightError)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.space12)
        .foregroundStyle(Color.lightError)
        .background(Color.lightErrorBackground)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.lightError, lineWidth: 1)
        )
    }
}

struct MultiCitizenshipSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultiCitizenshipSelectionScreen(title: "Which passport are you traveling under?", description: "We are asking so we can calculate any visa requirements.", buttonTitle: "Done", options: ["CN": "Mainland China", "HK": "Hong Kong", "MO": "Macau"], selectedCitizenshipCode: .constant(nil), onSave: { })
    }
}
    
