//
//  PlanAndBookSectionView.swift
//  Virgin Voyages
//
//  Created by Kevin Topollaj on 3/11/25.
//

import SwiftUI
import VVUIKit

protocol VoyageActivitiesViewModelProtocol {
    var screenState: ScreenState { get set }
    var sectionModel: VoyageActivitiesSection { get }
    
	func onAppear()
	func reload(sailingMode: SailingMode)
    func navigateToActivityDetail(for activity: VoyageActivitiesSection.VoyageActivityItem)
    func openAddAFriend()
}

struct PlanAndBookSectionView: View {
    
    @State var viewModel: VoyageActivitiesViewModelProtocol
    @State var isBookActivity = false
    
    @State private var bookGridHeight: CGFloat = 0
    @State private var exploreGridHeight: CGFloat = 0
    
    init(viewModel: VoyageActivitiesViewModelProtocol = VoyageActivitiesMockViewModel()) {
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        DefaultScreenView(state: $viewModel.screenState) {
            
            VStack {
                
                title()
                
                // Toggle
                ZStack {
                    Capsule()
                        .fill(Color.vvWhite)
                        .frame(width: 206, height: 45)
                    
                    HStack {
                        ZStack {
                            Capsule()
                                .fill(Color.vvRed)
                                .frame(width: 99,height: 37)
                                .offset(x: isBookActivity ? 99 : 0)
                                .animation(.easeOut(duration: 0.2), value: isBookActivity)
                                .padding(.leading, Spacing.space4)
                            
                            Text("Book")
                                .foregroundStyle(isBookActivity ? Color.blackText : Color.vvWhite)
                                .font(.vvBodyBold)
                                .onTapGesture {
                                    isBookActivity = false
                                }
                        }
                        
                        ZStack {
                            Capsule()
                                .fill(.clear)
                                .frame(width: 99,height: 37)
                            
                            Text("Explore")
                                .foregroundStyle(isBookActivity ? Color.vvWhite : Color.blackText)
                                .font(.vvBodyBold)
                                .onTapGesture {
                                    isBookActivity = true
                                }
                        }
                        
                    }
                    
                }
                .zIndex(2)
                .padding(.bottom, Spacing.space8)
                
                // Dynamic Grid Layout
                ZStack(alignment: .top) {
                    if !isBookActivity {
                        PlanAndBookActivityGridView(activities: viewModel.sectionModel.bookActivities) { activityItem in
                            viewModel.navigateToActivityDetail(for: activityItem)
                        }
                            .background(GeometryReader { geometry in
                                Color.clear.preference(key: HeightPreferenceKey.self,
                                                       value: geometry.size.height)
                            })
                            .opacity(isBookActivity ? 0 : 1)
                            .scaleEffect(isBookActivity ? 0.8 : 1)
                    }
                    
                    if isBookActivity {
                        PlanAndBookActivityGridView(activities: viewModel.sectionModel.exploreActivities) { activityItem in
                            viewModel.navigateToActivityDetail(for: activityItem)
                        }
                            .background(GeometryReader { geometry in
                                Color.clear.preference(key: HeightPreferenceKey.self,
                                                       value: geometry.size.height)
                            })
                            .opacity(isBookActivity ? 1 : 0)
                            .scaleEffect(isBookActivity ? 1 : 0.8)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isBookActivity)
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    if isBookActivity {
                        exploreGridHeight = height
                    } else {
                        bookGridHeight = height
                    }
                }
                .padding(.top, Spacing.space12)
                .padding(.bottom, Spacing.space16)
                
                
                // Add a friend
                ZStack {
                    
                    HStackLayout(spacing: Spacing.space16) {
                        
                        ZStack {
                            Image("Ellipse")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 58, height: 58)
                            
                            Image("AddFriend")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            Image("Appended Icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 17, height: 17)
                        }
                        
                        VStack(alignment: .leading, spacing: Spacing.space4) {
                            
                            HStack(spacing: Spacing.space4){
                                Text("Add a friend")
                                    .font(.vvBodyBold)
                                    .foregroundStyle(Color.charcoalBlack)
                                
                                Image("Chevron-Right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)
                                    .padding(.top, Spacing.space4)
                            }
                            
                            Text("Add contacts so you can make group bookings pre-cruise and shipboard.")
                                .font(.vvBody)
                                .foregroundStyle(Color.slateGray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    .padding(Spacing.space16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .background(Color.vvWhite)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.top, isBookActivity ? exploreGridHeight : bookGridHeight)
                .padding(.bottom, Spacing.space40)
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 1,
                    x: 0, y: 1
                )
                .onTapGesture {
                    viewModel.openAddAFriend()
                }
            }
            
        } onRefresh: {
            viewModel.onAppear()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .padding(.top, Spacing.space32)
        .padding(.horizontal, Spacing.space16)
        .background(Color.softGray)
        .clipShape(
            RoundedCorners(topLeft: 16,
                           topRight: 16,
                           bottomLeft: 0,
                           bottomRight: 0)
        )
    }
    
    private func title() -> some View {
        Text("Plan and book \n your voyage activities")
            .font(.vvHeading2Bold)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(.clear)
            .padding(.bottom, Spacing.space24)
    }
    
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ScrollView {
        PlanAndBookSectionView(viewModel: VoyageActivitiesMockViewModel())
    }
}
