//
//  ShoreThingsPortView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 14.5.25.
//

import SwiftUI
import VVUIKit

protocol ShoreThingPortScreenViewModelProtocol {
    var screenState: ScreenState { get set }
    var shoreThingPorts: ShoreThingPorts { get set }
    var selectedPort: ShoreThingPort { get set }
    var showGuide: ShoreThingPort? { get set }
    var showEventEditView: Bool { get set }
    var countdownTitle: String { get set }
   
    func onFirstAppear()
    func onReAppear()
    func onRefresh()
}

struct ShoreThingPortScreen: View {
    
    @State private var viewModel: ShoreThingPortScreenViewModelProtocol
    private let onViewListTapped: ((String, Date?, Date?) -> Void)?
    private let onBackClick: VoidCallback?
    
    // MARK: - Init
    init(
        viewModel: ShoreThingPortScreenViewModelProtocol,
		onViewListTapped: ((String, Date?, Date?) -> Void)? = nil,
		onBackClick: @escaping VoidCallback
    ) {
        _viewModel = State(wrappedValue: viewModel)
        self.onViewListTapped = onViewListTapped
        self.onBackClick = onBackClick
    }
    
    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ZStack(alignment: .top) {
                VStack {
                    if let leadTime = viewModel.shoreThingPorts.leadTime {
                        openingTimeView(for: leadTime)
                    } else {
                        TabView(selection: $viewModel.selectedPort) {
                            ForEach(viewModel.shoreThingPorts.items, id: \.sequence) { port in
                                portTabView(port: port)
                            }
                        }
                        .tabViewStyle(.page)
                        .background(.white)
                        .sheet(item: $viewModel.showGuide) { port in
                            if let url = URL(string: port.actionURL) {
                                WebContentView(url: url)
                            }
                        }
                    }
                }
                toolbar()
                    .padding(.horizontal, Spacing.space24)
                    .padding(.top, Spacing.space48)
            }
        } onRefresh: { viewModel.onRefresh()}
		.onAppear(
			onFirstAppear: {
				viewModel.onFirstAppear()
			},
			onReAppear: {
				viewModel.onReAppear()
		})
        .navigationBarHidden(true)
        .ignoresSafeArea(.container, edges: .top)
    }
    
    private func openingTimeView(for leadTime: LeadTime) -> some View {
        ZStack(alignment: .top){
            let titleText = leadTime.isCountdownStarted ? viewModel.countdownTitle : leadTime.title
            let action = leadTime.isCountdownStarted ? nil : {
                viewModel.showEventEditView = !(leadTime.isCountdownStarted)
            }
            OpeningTimeView(
                imageURL: leadTime.imageUrl,
                title: titleText ,
                subtitle: leadTime.description,
                buttonTitle: "Add to my calendar",
                buttonAction: action
            )
            .sheet(isPresented: $viewModel.showEventEditView) {
                EventCalendarEditView(
                    title: "Virgin Voyages - Shore thing booking opens",
                    startDate: leadTime.date,
                    endDate: leadTime.date
                )
            }
        }
    }
    
    private func portTabView(port: ShoreThingPort) -> some View {
        ZStack {
            if let url = URL(string: port.imageURL) {
                FlexibleProgressImage(url: url)
                    .overlay {
                        LinearGradient(colors: [.clear, .black.opacity(0.6)],
                                       startPoint: .top,
                                       endPoint: .bottom)
                    }
                    .ignoresSafeArea(.container, edges: .top)
            }
            
            VStack(spacing: 60) {
                Spacer()
                
                if !port.name.isEmpty {
                    Text(port.name)
                        .fontStyle(.display)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Paddings.defaultVerticalPadding32)
                }
                
                VStack(spacing: 25) {
                    VStack(spacing: .zero) {
                        Text(port.departureArrivalDateText)
                            .textCase(.uppercase)
                            .fontStyle(.headline)
                        
                        Text(port.departureArrivalTimeText.replacingOccurrences(of: ",", with: "\n"))
                            .textCase(.uppercase)
                            .fontStyle(.headline)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    
                    if port.dayType == .passed{
                        SecondaryButton("Book a shore thing", isDisabled: true) {}
                            .frame(maxWidth: 220)
                    } else {
                        PrimaryButton("Book a Shore Thing") {
							onViewListTapped?(port.code, port.arrivalDateTime, port.departureDateTime)
                        }
                        .frame(maxWidth: 220)
                    }
                }
                
                ShoreThingPortCodePicker(ports: viewModel.shoreThingPorts.items, selectedPort: $viewModel.selectedPort)
                    .contentStyle()
                
                if !port.name.isEmpty {
                    Button {
                        viewModel.showGuide = port
                    } label: {
                        Label(port.guideText, systemImage: "map")
                            .textCase(.uppercase)
                            .fontStyle(.smallButton)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                
                VSpacer(0)
            }
            .foregroundStyle(.white)
        }
        .tag(port)
    }
    
    func toolbar() -> some View {
        HStack(alignment: .top, spacing: Spacing.space24) {
			BackButton({
				onBackClick?()
			})
                .opacity(0.8)
            Spacer()
        }
    }
}
