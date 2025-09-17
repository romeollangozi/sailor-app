//
//  DocumentConfirmScreen.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 4.3.25.
//

import SwiftUI
import VVUIKit

protocol DocumentConfirmScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var document: TravelDocumentDetails { get set }
    var fieldValues: [String: String] { get set }
//    var draftFieldValues: [String: String] { get set }
    var rejectionReasons: [String] { get }
    var lookupOptions: [String: [Option]] { get }
    var shouldShowBackButton: Bool { get }
    var primaryButtonText: String { get }
    var secondaryButtonText: String { get }
    func secondayBttonAction()
    func binding(for fieldName: String) -> Binding<String>
    func onProceed() async
    func navigateBack()
    func onClose()
    func onRefresh()
    func onAppear()
    func loadDetails() async
    func loadLookupOptions() async
    func onReplaceDocument()
    var isReplaceImage: Bool { get set }
    var scanDocumentScreenViewModel: ScanDocumentViewModelProtocol { get }
    var isConfirmReplace: Bool { get set }
    var shouldShowPassportExpireWarning: Bool { get set }
    func onConfirmReplaceDocument()
    func onCancelReplaceDocument()
    var replaceImagePopupTitle : String { get }
    var replaceImagePopupMessage : String { get }
    var replaceImagenPopupConfirmTitle : String { get }
    var replaceImagePopupCancelTitle : String { get }
    var isSecondScan: Bool { get set }
    var fieldErrors: [String: String] { get }
    func isInputValid()->Bool
	func getDropdownOptions(for field: TravelDocumentDetails.Field) -> [Option]
    func confirmDocumentAfterExpiryWarning()
    // Multi-citizenship variables
    var isShowingCitizenshipSelection: Bool { get set }
    var multiCitizenshipOptions: [String : String] { get }
    var selectedCitizenship: String? { get set }
    var didConfirmCitizenship: Bool { get set }
    var multiCitizenshipTitle: String { get }
    var multiCitizenshipDescription: String { get }
    var multiCitizenshipButtonTitle: String { get }
}

struct DocumentConfirmScreen: View {
    let shouldShowPassportExpire: Bool
    @State var viewModel: DocumentConfirmScreenViewModelProtocol
    @StateObject private var keyboard = KeyboardResponder()

    init(
        shouldShowPassportExpire: Bool,
        document: TravelDocumentDetails,
        input: ScanTravelDocumentInputModel, isEditing: Bool = false, documentCode: String
    ) {
        self.shouldShowPassportExpire = shouldShowPassportExpire
        viewModel =  DocumentConfirmViewModel(document: document, isEditing: isEditing, input: input, documentCode: documentCode, shouldDisplayWarning: shouldShowPassportExpire)
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ScrollView{
                ZStack{
                    Color.clear
                        .contentShape(Rectangle())
                        .allowsHitTesting(true)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                    VStack {
                        toolbar
                            .ignoresSafeArea()
                        VStack(alignment: .leading, spacing: Spacing.space24) {
                            
                            Text(viewModel.document.title)
                                .font(.vvHeading1Bold)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(viewModel.document.description)
                                .font(.vvHeading5Light)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            if !viewModel.rejectionReasons.isEmpty{
                                RejectionReasonView(title: "Reason for rejection", reasons: viewModel.rejectionReasons)
                            }
                            fieldsView()
                            Spacer()
                            Button(viewModel.primaryButtonText) {
                                Task{
                                    await viewModel.onProceed()
                                }
                            }
                            .primaryButtonStyle(isDisabled: !viewModel.isInputValid())
                            Button(viewModel.secondaryButtonText) {
                                viewModel.secondayBttonAction()
                            }
                            .buttonStyle(TertiaryButtonStyle())
                        }
                        .padding(.horizontal, Spacing.space24)
                        .padding(.top, -Spacing.space24)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: keyboard.keyboardHeight)
            }
            .ignoresSafeArea()
        } onRefresh: {
            viewModel.onRefresh()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(isPresented: $viewModel.isShowingCitizenshipSelection) {
            MultiCitizenshipSelectionScreen(title: viewModel.multiCitizenshipTitle,
                                            description: viewModel.multiCitizenshipDescription,
                                            buttonTitle: viewModel.multiCitizenshipButtonTitle,
                                            options: viewModel.multiCitizenshipOptions,
                                            selectedCitizenshipCode: $viewModel.selectedCitizenship,
                                            onSave: {
                                                viewModel.didConfirmCitizenship = true
                                                Task{
                                                    await viewModel.onProceed()
                                                }
                                            })
        }
        .fullScreenCover(isPresented: $viewModel.isReplaceImage) {
            ScanDocumentScreen(viewModel: viewModel.scanDocumentScreenViewModel) {
                viewModel.isReplaceImage = false
            }
                .navigationBarBackButtonHidden(true)
        }
        .fullScreenCover(isPresented: $viewModel.isConfirmReplace) {
            ConfirmationPopupAlert(
                title: viewModel.replaceImagePopupTitle,
                message: viewModel.replaceImagePopupMessage,
                confirmButtonText: viewModel.replaceImagenPopupConfirmTitle ,
                cancelButtonText: viewModel.replaceImagePopupCancelTitle,
                isLoading: .constant(false), // TODO: implement loading state in viewModel.onUseExistingDocument
                onConfirm: {
                    viewModel.onConfirmReplaceDocument()
                },
                onCancel: {
                    viewModel.onCancelReplaceDocument()
                }
            )
        }.onChange(of: shouldShowPassportExpire) { newValue in
            if !newValue {
                viewModel.confirmDocumentAfterExpiryWarning()
            }
        }
    }
    
    var toolbar: some View {
        HStack(alignment: .top, spacing: .zero) {
            if viewModel.shouldShowBackButton {
                BackButton({
                    viewModel.navigateBack()
                })
                .opacity(0.8)
                .padding(.top, Paddings.defaultVerticalPadding64)
                .padding(.leading, Paddings.defaultVerticalPadding16)
            }
            Spacer()
                .background(.red)
            Image("HeaderSemaphore")
        }
        .background(.clear)
    }
    
    private func fieldsView() -> some View {
        VStack(alignment: .leading) {
            ForEach($viewModel.document.fields.filter { !$0.hidden.wrappedValue }) { $field in
                switch field.type {
                case .image:
                    ZStack(alignment: .topLeading) {
                        if viewModel.fieldErrors[field.name] != nil || (field.value.isEmpty && field.required){
                            imageMissingView(message: viewModel.fieldErrors[field.name] ?? "There is an error with document \(field.label) you uploaded.")
                        }else{
                            imagePlaceholderView()
                            if !field.isSecure{
                                AuthURLImageView(imageUrl: $viewModel.fieldValues[field.name].wrappedValue ?? "")
                                    .frame(width: Sizes.defaultSize240)
                                    .frame(height: Sizes.defaultSize150)
                                    .cornerRadius(Sizes.defaultSize8)
                                    .id(viewModel.fieldValues[field.name].value)
                            }
                        }
                        if !field.readonly {
                            RoundedImageButton(imageName: "Camera") {
                                viewModel.isSecondScan = field.name == "backPhotoUrl"
                                viewModel.onReplaceDocument()
                            }
                            .padding(.top, -Spacing.space24)
                            .padding(.leading, 216)
                        }
                    }
                    .padding(.bottom, Spacing.space16)
                case .string, .number:
                    VVTextField(
                        label: field.label,
                        value: viewModel.binding(for: field.name),
                        errorMessage: viewModel.fieldErrors[field.name] ?? "",
                        readonly: field.readonly,
                        required: field.required,
                        isSecure: false,
                        hasError: viewModel.fieldErrors[field.name] != nil,
                        maskedValue: field.isSecure ? field.maskedValue : nil
                    )
                    .padding(.bottom, Spacing.space16)
                case .date:
                    VVDateField(
                        label: field.label,
                        date: Binding(
                            get: {
                                viewModel.fieldValues[field.name]?.fromMMMMdYYYY()
                            },
                            set: { newDate in
                                if let newDate = newDate{
                                    viewModel.fieldValues[field.name] = newDate.toMonthDDYYY()
                                } else {
                                    viewModel.fieldValues[field.name] = ""
                                }
                            }
                        ),
                        errorMessage: viewModel.fieldErrors[field.name] ?? "",
                        readonly: field.readonly,
                        required: field.required,
                        isSecure: false,
                        maskedValue: field.isSecure ? "****" : nil,
                        hasError: viewModel.fieldErrors[field.name] != nil
                    )
                    .padding(.bottom, Spacing.space16)
                case .dropdown:
					VVPickerField(label: field.label, options: viewModel.getDropdownOptions(for: field), selected: Binding<String?>(
                        get: { viewModel.binding(for: field.name).wrappedValue },
                        set: { viewModel.binding(for: field.name).wrappedValue = $0 ?? "" }
                    ),
                                              errorMessage: viewModel.fieldErrors[field.name] ?? "",
                                              readonly: field.readonly,
                                              required: field.required,
                                  isSecure: false,
                                  maskedValue: field.isSecure ? field.maskedValue : nil,
                                  hasError: viewModel.fieldErrors[field.name] != nil)
                    .padding(.bottom, Spacing.space16)
                }
            }
        }
    }
    
    private func imagePlaceholderView() -> some View {
        VStack(spacing: Spacing.space32) {
            Text("You have uploaded your \(viewModel.document.title)")
                .font(.vvSmallMedium)
                .foregroundStyle(Color.darkGray)
                .multilineTextAlignment(.center)
        }
        .frame(width: Sizes.defaultSize240)
        .frame(height: Sizes.defaultSize150)
        .background(Color.documentLightGreenBackground)
        .cornerRadius(8)
    }
    
    private func imageMissingView(message: String?) -> some View {
        VStack(alignment: .center, spacing: 24) {
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 54, height: 54, alignment: .center)
                .foregroundStyle(.white, .orange)

            Text(message ?? "There is an error with the document you uploaded.")
                .multilineTextAlignment(.center)
                .fontStyle(.subheadline)
                .foregroundStyle(Color.orange)
        }
        .padding(.horizontal, Sizes.defaultSize8)
        .frame(width: Sizes.defaultSize240)
        .frame(height: Sizes.defaultSize150)
        .foregroundStyle(.white, .orange)
        .background(Color.black.opacity(0.7))
        .cornerRadius(8)
    }
}

struct DocumentConfirmScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DocumentConfirmScreen(
                shouldShowPassportExpire: false, document: TravelDocumentDetails.sample(), input: ScanTravelDocumentInputModel.empty(), documentCode: "P"
            )
        }
    }
}
