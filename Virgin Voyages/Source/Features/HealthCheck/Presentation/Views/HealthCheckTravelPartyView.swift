//
//  HealthCheckTravelPartyView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 6/9/25.
//

import SwiftUI
import VVUIKit

struct HealthCheckTravelPartyView: View {
    
    @State private var isExpanded = false
    @State private var notSignedCheckedMembers: [Bool]
    @State private var signedCheckedMembers: [Bool]
    
    let travelParty: HealthCheckDetail.LandingPage.QuestionsPage.TravelParty
    let onSelectionChanged: (Set<String>) -> Void
    
    init(travelParty: HealthCheckDetail.LandingPage.QuestionsPage.TravelParty,
         onSelectionChanged: @escaping (Set<String>) -> Void) {
        
        self.travelParty = travelParty
        self.onSelectionChanged = onSelectionChanged
        
        _notSignedCheckedMembers = State(initialValue: Array(repeating: false, count: travelParty.partyMembers.notSigned.count))
        _signedCheckedMembers = State(initialValue: Array(repeating: false, count: travelParty.partyMembers.alreadySigned.count))
    }
    
    private func notifySelectionChanged() {
        var selectedIds = Set<String>()
        
        // Add selected not-signed members
        for (index, isChecked) in notSignedCheckedMembers.enumerated() {
            if isChecked {
                selectedIds.insert(travelParty.partyMembers.notSigned[index].reservationGuestId)
            }
        }
        
        // Add selected already-signed members
        for (index, isChecked) in signedCheckedMembers.enumerated() {
            if isChecked {
                selectedIds.insert(travelParty.partyMembers.alreadySigned[index].reservationGuestId)
            }
        }
        
        onSelectionChanged(selectedIds)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Spacing.space0) {
            
            VVUIKit.DoubleDivider(color: Color.vvBlack, lineHeight: 1)
                .padding(.bottom, Spacing.space24)
            
            HStack(spacing: Spacing.space16) {
                
                Text(travelParty.title)
                    .foregroundStyle(Color.blackText)
                    .font(.vvHeading5Bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button {
                    
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        isExpanded.toggle()
                    }
                    
                } label: {
                    
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.darkGray)
                        .symbolEffect(.bounce, value: isExpanded)
                        .rotationEffect(.degrees(isExpanded ? -180 : 0))
                        .frame(width: 24, height: 24)
                }
            }
            
            Text(travelParty.description)
                .foregroundStyle(Color.darkGray)
                .font(.vvSmall)
                .padding(.top, Spacing.space12)
            
            
            if isExpanded {
                
                VStack(alignment: .leading) {
                    
                    ForEach(Array(travelParty.partyMembers.notSigned.enumerated()), id: \.element.id) { index, member in
                        
                        HealthCheckCabinMateItem(
                            isChecked: Binding(
                                get: { notSignedCheckedMembers[index] },
                                set: { newValue in
                                    notSignedCheckedMembers[index] = newValue
                                    notifySelectionChanged()
                                }
                            ),
                            imageUrl: member.imageURL,
                            name: member.name
                        )
                        
                    }
                    
                    if !travelParty.partyMembers.alreadySigned.isEmpty {
                        Text(travelParty.alreadySignedTitle)
                            .foregroundStyle(Color.darkGray)
                            .font(.vvSmallBold)
                            .padding(.top, Spacing.space24)
                            .padding(.bottom, Spacing.space16)
                            .multilineTextAlignment(.leading)
                    }
                    
                    ForEach(Array(travelParty.partyMembers.alreadySigned.enumerated()), id: \.element.id) { index, member in
                        
                        HealthCheckCabinMateItem(
                            isChecked: Binding(
                                get: { signedCheckedMembers[index] },
                                set: { newValue in
                                    signedCheckedMembers[index] = newValue
                                    notifySelectionChanged()
                                }
                            ),
                            imageUrl: member.imageURL,
                            name: member.name
                        )
                        
                    }
                    
                }
                .padding(.top, Spacing.space10)
                
            }
            
            VVUIKit.DoubleDivider(color: Color.vvBlack, lineHeight: 1)
                .padding(.top, Spacing.space32)
        }
        .padding(Spacing.space24)
        
    }
}

#Preview {
    HealthCheckTravelPartyView(
        travelParty: HealthCheckDetail.sample().landingPage.questionsPage.travelParty,
        onSelectionChanged: { selectedIds in
            print("Selected IDs: \(selectedIds)")
        }
    )
}
