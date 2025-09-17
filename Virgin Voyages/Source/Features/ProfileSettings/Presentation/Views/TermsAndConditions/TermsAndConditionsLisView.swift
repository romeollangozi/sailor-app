//
//  TermsAndConditionsLisView.swift
//  Virgin Voyages
//
//  Created by Timur Xhabiri on 1.11.24.
//

import SwiftUI

struct TermsAndConditionsListView: View {
    
    let menuItems: [TermsAndConditionsListItemModel]
    
    init(menuItems: [TermsAndConditionsListItemModel]) {
        self.menuItems = menuItems
    }
    
    var body: some View {
        VStack(spacing: Paddings.defaultVerticalPadding16) {
            ForEach(menuItems) { item in
                NavigationLink {
                    TermsAndConditionsDetailsView(detailsItem: item)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: Paddings.cellTitleSubtitlePadding) {
                            Text(item.heading)
                                .font(.custom(FontStyle.button.fontName, size: FontStyle.body.pointSize))
                                .foregroundColor(.vvGray)
                        }
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(.accentColor)
                            .font(.system(size: FontStyle.lightTitle.pointSize, weight: .light))
                        
                    }
                    .padding(.vertical, Paddings.defaultVerticalPadding)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                Divider()
            }
        }
    }
}


#Preview {
    NavigationStack {
        // Create the view with dummy data
        let mockRepository = PreviewMockTermsAndConditionsRepository()
        let mockUseCase = GetTermsAndConditionsContentUseCase(termsAndConditionsRepository: mockRepository)
        let mockModel = TermsAndConditionViewModel(getContenUseCase: mockUseCase)
        TermsAndConditionsListView(menuItems: mockModel.screenModel.menuItems)
            .padding()
    }
}
