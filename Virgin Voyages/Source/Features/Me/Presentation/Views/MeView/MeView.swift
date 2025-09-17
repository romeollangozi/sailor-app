//
//  MeView.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 3.3.25.
//

import SwiftUI
import VVUIKit

enum MeSectionTab: Hashable {
    case myAgenda
    case myAddOns
}

protocol MeViewModelProtocol {
    var myVoyageAddOns: MyVoyageAddOns { get }
    var myVoyageHeader: MyVoyageHeaderModel { get }
    var myVoyageAgenda: MyVoyageAgenda { get }
    var myAppointmentsForDay: [MyVoyageAgenda.Appointment] { get }
    var screenState: ScreenState { get set }
    var selectedTab: MeSectionTab { get set }
    var sailingMode: SailingMode { get }
    var scrollToTime: Date? { get set }
    var selectedDate: Date { get set }
    var itineraryDates: [Date] { get }
    
    func goToBenefitsView()
    func goToReceiptView(appointment: MyVoyageAgenda.Appointment)
    func goToAddonReceipt(addonCode: String)
    func goToAddonsList()
    func goToProfileSettingScreen()
    func goToLineUpScreen()
    func onFirstAppear()
    func onReAppear()
    func goToWallet()
    func onDaySelected()
    func handleSectionChange(section: MeNavigationSection)
    func addToPlanner()
    
    func navigateToSpecificDate(_ date: Date)
    func resetToCurrentDate()
}

extension MeView {
    @MainActor
    static func createDefault(section: MeNavigationSection) -> MeView {
        MeView(viewModel: MeViewModel(), section: section)
    }
}

struct MeView: View {
    @State private var viewModel: MeViewModelProtocol
    let section: MeNavigationSection

    init(viewModel: MeViewModelProtocol, section: MeNavigationSection) {
        self._viewModel = State(wrappedValue: viewModel)
        self.section = section
    }

    var body: some View {
        DefaultScreenView(state: $viewModel.screenState) {
            ZStack{
                VStack(spacing: .zero) {
                    headerView()
                    tabView()
                    dateSelectorView()
                    contentView()
                }
                .background(Color.softGray)
                .navigationBarTitleDisplayMode(.inline)
                //FloatingBottomCornerButton(icon: "plus", action: {  viewModel.addToPlanner()})
                
            }
        } onRefresh: {}
        .onAppear(
            onFirstAppear: {
                viewModel.onFirstAppear()
            },
            onReAppear: {
                viewModel.onReAppear()
            }
        )
        .onAppear {
            viewModel.handleSectionChange(section: section)
        }
        .onChange(of: section) { oldSection, newSection in
            viewModel.handleSectionChange(section: newSection)
        }
    }
    
    private func headerView() -> some View {
        VStack {
            HStack {
                Spacer()
                HorizontalTextImageButton(viewModel.myVoyageHeader.buttonSettingsTitle, image: Image("Union"), action: {
                    viewModel.goToProfileSettingScreen()
                })
            }
            .padding()

            Spacer()

            VStack {
                HStack(spacing: Spacing.space12) {
                    profileView()
                    headerButtonsView()
                }
            }
            .padding(.horizontal, Spacing.space24)
            .padding(.vertical, Spacing.space32)
        }
        .background(headerBackground)
        .frame(height: Sizes.defaultImageHeight234)
        .frame(maxWidth: .infinity)
    }

    private func headerButtonsView() -> some View {
        VStack(alignment: .leading, spacing: Spacing.space8) {
            if viewModel.myVoyageHeader.type.isRockStar {
                Text(viewModel.myVoyageHeader.type.rawValue.uppercased())
                    .font(.vvTinyBold)
                    .kerning(1)
                    .padding(.horizontal, Spacing.space8)
                    .padding(.vertical, Spacing.space4)
                    .foregroundStyle(Color.blackText)
                    .background(Color.goldenBeige)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            Text(viewModel.myVoyageHeader.name)
                .font(.vvHeading3Bold)
                .foregroundColor(.white)
            HStack(spacing: Spacing.space8) {
                MeHeaderButton(image: "Cabin", text: viewModel.myVoyageHeader.cabinNumber, action: {})
                MeHeaderButton(image: "Wallet", text: viewModel.myVoyageHeader.buttonMyWalletTitle) {
                    viewModel.goToWallet()
                }
            }
        }
    }

    private func profileView() -> some View {
        ZStack {
            Circle()
                .stroke(viewModel.myVoyageHeader.type.isRockStar ? Color.goldenBeige : Color.white, lineWidth: 2)
                .frame(width: Sizes.meProfileImageSize, height: Sizes.meProfileImageSize)

            AuthURLImageView(imageUrl: viewModel.myVoyageHeader.profileImageUrl, size: Sizes.meProfileImageSize - Spacing.space4, clipShape: .circle, defaultImage: "ProfilePlaceholder")

            if viewModel.myVoyageHeader.type.isRockStar {
                Image("Star")
                    .frame(width: Sizes.meProfileStarImageSize, height: Sizes.meProfileStarImageSize)
                    .background(Circle().fill(Color.goldenBeige))
                    .offset(x: Sizes.meProfileImageSize / 2 - Spacing.space10, y: Sizes.meProfileImageSize / 2 - Spacing.space10)
            }
        }
        .onTapGesture {
            viewModel.goToBenefitsView()
        }
    }

    private func tabView() -> some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Button(action: {
                    viewModel.selectedTab = .myAgenda
                }) {
                    VStack {
                        Text(viewModel.myVoyageHeader.tabMyAgendaTitle)
                            .font(.vvBodyBold)
                            .foregroundColor(viewModel.selectedTab == .myAgenda ? .vvRed : .borderGray)

                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(viewModel.selectedTab == .myAgenda ? .vvRed : .borderGray)
                            .padding(.top, 2)
                    }
                }
                Button(action: {
                    viewModel.selectedTab = .myAddOns
                }) {
                    VStack {
                        Text(viewModel.myVoyageHeader.tabAddOnsTitle)
                            .font(.vvBodyBold)
                            .foregroundColor(viewModel.selectedTab == .myAddOns ? .vvRed : .borderGray)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(viewModel.selectedTab == .myAddOns ? .vvRed : .borderGray)
                            .padding(.top, 2)
                    }
                }
            }
            .padding(.horizontal, Spacing.space24)
            .padding(.vertical, Spacing.space16)
            .background(Color.white)
        }
    }

    @ViewBuilder
    private func dateSelectorView() -> some View {
        if viewModel.selectedTab == .myAgenda {
            VStack(spacing: .zero) {
                DateSelector(
                    selected: $viewModel.selectedDate,
                    options: viewModel.itineraryDates,
                    isPastDateDisabled: false,
                    onSelected: { date in
                        viewModel.onDaySelected()
                    }
                )
                .padding(.top, Spacing.space8)
                .padding(.bottom, Spacing.space16)
            }
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
            .padding(.bottom, Spacing.space4)
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        switch viewModel.selectedTab {
        case .myAddOns:
            MeAddonsView(
                myVoyageAddons: viewModel.myVoyageAddOns,
                myVoyageHeader: viewModel.myVoyageHeader,
                sailingMode: viewModel.sailingMode,
                navigateToAddons: {
                    viewModel.goToAddonsList()
                }, navigateToAddonsReceipt: { addonCode in
                    viewModel.goToAddonReceipt(addonCode: addonCode)
                }
            )
        case .myAgenda:
            MeAgendaView(
                viewModel: viewModel,
                onAppointmentClick: { appointment in
                    viewModel.goToReceiptView(appointment: appointment)
                }, onLineUpClick: {
                    viewModel.goToLineUpScreen()
                }
            )
            
        }
    }

    private var headerBackground: some View {
        AuthURLImageView(imageUrl: viewModel.myVoyageHeader.imageUrl)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(gradientOverlay)
            .ignoresSafeArea(edges: .top)
    }
    
    private var gradientOverlay: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.black.opacity(0.0), location: 0.0),
                    .init(color: Color.black.opacity(0.3), location: 0.9115)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
}
