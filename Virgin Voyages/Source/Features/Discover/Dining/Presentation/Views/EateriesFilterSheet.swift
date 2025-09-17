//
//  EateriesFilterSheet.swift
//  Virgin Voyages
//
//  Created by Nick Balani on 29.11.24.
//

import SwiftUI
import VVUIKit

struct EateriesFilterSheet: View {
    @State var selectedDate: Date = Date()
    @State var selectedMealPeriod: MealPeriod = MealPeriod.dinner
    @State var selectedSailors: [SailorModel] = []
	@State var showAddFriend = false
    @State var showInfoDrawer = false

    var availableSailors: [SailorModel]
    var availableDates: [Date]
    let infoDrawerModel: InfoDrawerModel

    let onSearch: (Date, MealPeriod, [SailorModel]) -> Void
        
    init(filter: EateriesSlotsInputModel,
         availableSailors: [SailorModel],
         availableDates: [Date],
         infoDrawerModel: InfoDrawerModel,
         onSearch: @escaping (Date, MealPeriod, [SailorModel]) -> Void) {
        self.availableSailors = availableSailors
        self.availableDates = availableDates
        
        self.selectedDate = filter.searchSlotDate
        self.selectedMealPeriod = filter.mealPeriod
        self.selectedSailors = filter.guests
        self.infoDrawerModel = infoDrawerModel

        self.onSearch = onSearch
    }
    
    var body: some View {
        VStack(spacing: Paddings.defaultVerticalPadding32) {
            
            VStack(alignment: .center, spacing: 5) {
                Text("Search for a Table")
                    .fontStyle(.lightBody)
                
                Text("\(self.selectedMealPeriod.rawValue.capitalizedFirstLetter()) for \(self.selectedSailors.count) – \(self.selectedDate.toDayWithOrdinal())")
                    .fontStyle(.title)
            }
            
            VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
                VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
                    
                    VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
                        HStack(spacing: Spacing.space4) {
                            Text("Select your party")
                                .fontStyle(.headline)
                            Button {
                                self.showInfoDrawer = true
                            } label: {
                                Image(.info)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }

                        SailorPickerV2(sailors: availableSailors, selected: $selectedSailors, onAddNew: {
							DispatchQueue.main.async {
								self.showAddFriend = true
							}
                        })
                    }
                    
                    VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
                        Divider()
                        
                        Text("Select day")
                            .fontStyle(.headline)
						
						DateSelector(selected: $selectedDate, options: availableDates)
							
                        Divider()
                    }
                    
                    VStack(alignment: .leading, spacing: Paddings.defaultVerticalPadding16) {
                        Text("Select Meal Period")
                            .fontStyle(.headline)
                        
                        HStack(spacing: Paddings.defaultVerticalPadding16) {
                            Button {
                                selectedMealPeriod = .brunch
                            } label: {
                                Text(MealTime.brunch.description)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                            }
                            .fontStyle(.smallButton)
                            .foregroundStyle(.primary)
                            .overlay {
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(style: .init(lineWidth: 2))
                                    .foregroundStyle(selectedMealPeriod == .brunch ? Color("Tropical Blue") : Color(uiColor: .systemGray4))
                            }
                            
                            Button {
                                selectedMealPeriod = .dinner
                            } label: {
                                Text(MealTime.dinner.description)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                            }
                            .fontStyle(.smallButton)
                            .foregroundStyle(.primary)
                            .overlay {
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(style: .init(lineWidth: 2))
                                    .foregroundStyle(selectedMealPeriod == .dinner ? Color("Tropical Blue") : Color(uiColor: .systemGray4))
                            }
                        }
                    }
                    
                }.padding(Paddings.defaultVerticalPadding16)
                
                Divider()
                
                VStack() {
                    Button("Check Availability") {
                        onSearch(selectedDate, selectedMealPeriod, selectedSailors)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }.padding(Paddings.defaultVerticalPadding16)
            }
        }
        .sheet(isPresented: $showAddFriend, content: {
			AddFriendFlow(onDismiss: {
				showAddFriend = false
			})
        })
        .sheet(isPresented: $showInfoDrawer) {
            InfoDrawerView(title: infoDrawerModel.title, description: infoDrawerModel.description, buttonTitle: infoDrawerModel.buttonTitle, buttonStyle: SecondaryButtonStyle()) {
                showInfoDrawer = false
            }
            .presentationDetents([.height(450)])
        }
    }
}

#Preview {
    let filter = EateriesSlotsInputModel.sample
    
    NavigationStack {
        EateriesFilterSheet(filter: filter,
                            availableSailors: filter.guests,
                            availableDates: DateGenerator.generateDates(from: Date(), totalDays: 5),
                            infoDrawerModel: InfoDrawerModel(title: "", description: "", buttonTitle: ""),
                            onSearch: {_,_,_ in EmptyView()})
    }
}
