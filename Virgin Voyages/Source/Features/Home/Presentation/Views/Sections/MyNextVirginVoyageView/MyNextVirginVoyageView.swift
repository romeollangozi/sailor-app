//
//  MyNextVirginVoyageView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/18/25.
//

import SwiftUI
import VVUIKit

protocol MyNextVirginVoyageViewModelProtocol {
    var myNextVoyageSection: MyNextVoyageSection { get }
    var sailingMode: SailingMode { get }
    var shouldShowDaysRemaining: Bool { get }
    
    func didTapMyNextVirginVoyage()
}

struct MyNextVirginVoyageView: View {
    
    @State var viewModel: MyNextVirginVoyageViewModelProtocol
    
    init(viewModel: MyNextVirginVoyageViewModelProtocol) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        ZStack(alignment: .topLeading) {
            
            if !viewModel.myNextVoyageSection.imageURL.isEmpty {
                
                FlexibleProgressImage(url: URL(string: viewModel.myNextVoyageSection.imageURL))
            } else {
                Color.gray.opacity(0.3)
            }
            
            LinearGradient(
                gradient: Gradient(colors: [
                    .black.opacity(0.40),
                    .black.opacity(0.40)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
            
            VStack() {
                
                myNextVirginVoyageTopSection()
                    .padding(.trailing, 80)
                
                Spacer()
                
                myNextVirginVoyageBottomSection()
                
            }
            
        }
        .frame(height: 238)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        .shadow(color: .black.opacity(0.07), radius: 24, x: 0, y: 8)
        .padding(Spacing.space16)
        .onTapGesture {
            viewModel.didTapMyNextVirginVoyage()
        }
    }
    
    func myNextVirginVoyageTopSection() -> some View {
        VStack(alignment: .leading,
               spacing: Spacing.space8) {
            
            if viewModel.shouldShowDaysRemaining {
                Text(viewModel.myNextVoyageSection.dayRemaining)
                    .textCase(.uppercase)
                    .font(.vvSmallBold)
                    .foregroundStyle(Color.vvWhite)
            }
            
            Text(viewModel.myNextVoyageSection.title)
                .font(.vvHeading4Bold)
                .foregroundStyle(Color.vvWhite)
            
            Text(viewModel.myNextVoyageSection.subTitle)
                .font(.vvSmall)
                .foregroundStyle(Color.vvWhite)
            
        }
               .frame(maxWidth: .infinity, alignment: .leading)
               .padding([.horizontal, .top], Spacing.space24)
    }
    
    func myNextVirginVoyageBottomSection() -> some View {
        HStack {
            Text("Claim your exclusive offer")
                .font(.vvSmall)
                .foregroundStyle(Color.vvWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image("forwardWhite")
        }
        .padding(.leading, Spacing.space24)
        .padding(.trailing, Spacing.space16)
        .frame(height: 59)
        .background(Color.vvWhite.opacity(0.3))
    }
    
}

#Preview("PreCruise") {
    MyNextVirginVoyageView(viewModel: MyNextVirginVoyageViewModel(sailingMode: .preCruise))
}

#Preview("PostCruise") {
    MyNextVirginVoyageView(viewModel: MyNextVirginVoyageViewModel(sailingMode: .postCruise))
}
