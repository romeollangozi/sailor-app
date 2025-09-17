import Observation
import SwiftUI

@MainActor
@Observable
class MeViewModel: BaseViewModelV2, MeViewModelProtocol {
    private let getMyVoyageHeaderUseCase: GetMyVoyageHeaderUseCaseProtocol
    private let getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol
    private let getMyVoyageAddOnsUseCase: GetMyVoyageAddOnsUseCaseProtocol
    private let getSailingModeUseCase: GetSailingModeUseCaseProtocol
    private let getSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol
    private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
    private var appCoordinator: AppCoordinator = .shared

    var myVoyageHeader: MyVoyageHeaderModel = MyVoyageHeaderModel.empty()
    var myVoyageAgenda: MyVoyageAgenda = MyVoyageAgenda.empty()
    var myVoyageAddOns: MyVoyageAddOns = MyVoyageAddOns.empty()
    var screenState: ScreenState = .loading
    var selectedTab: MeSectionTab = .myAgenda
    var sailingMode: SailingMode = .undefined
    var sailorDate = Date()
    var scrollToTime: Date? = nil
    var itineraryDays: [ItineraryDay] = []
    var selectedDate: Date = Date()
    var itineraryDates: [Date] = []
    var myAppointmentsForDay: [MyVoyageAgenda.Appointment] = []
    
    private var isDateSetByNavigation = false

    init(getMyVoyageHeaderUseCase: GetMyVoyageHeaderUseCaseProtocol = GetMyVoyageHeaderUseCase(),
         getMyVoyageAddOnsUseCase: GetMyVoyageAddOnsUseCaseProtocol = GetMyVoyageAddOnsUseCase(),
         getMyVoyageAgendaUseCase: GetMyVoyageAgendaUseCaseProtocol = GetMyVoyageAgendaUseCase(),
         getSailingModeUseCase: GetSailingModeUseCaseProtocol = GetSailingModeUseCase(),
         getSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol = GetSailorDateAndTimeUseCase(),
         itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase()
    ) {
        self.getMyVoyageHeaderUseCase = getMyVoyageHeaderUseCase
        self.getMyVoyageAddOnsUseCase = getMyVoyageAddOnsUseCase
        self.getMyVoyageAgendaUseCase = getMyVoyageAgendaUseCase
        self.getSailingModeUseCase = getSailingModeUseCase
        self.getSailorDateAndTimeUseCase = getSailorDateAndTimeUseCase
        self.itineraryDatesUseCase = itineraryDatesUseCase
    }

    func onFirstAppear() {
        Task {
            await loadMyVoyageHeader()
            await loadItineraryDates()
            await loadMyVoyageAgenda()
            filterAppointmentsForSelectedDate()
            screenState = .content
        }

        Task {
            await loadSailingMode()
        }

        Task {
            await loadAddons()
        }
    }

    func onReAppear() {
        Task {
            await loadMyVoyageHeader()
            await loadItineraryDates()
            await loadMyVoyageAgenda(useCache: false)
            filterAppointmentsForSelectedDate()
            screenState = .content
        }

        Task {
            await loadSailingMode()
        }

        Task {
            await loadAddons(useCache: false)
        }
    }

    func onDaySelected() {
        filterAppointmentsForSelectedDate()
    }
    
    func navigateToSpecificDate(_ date: Date) {
        selectedDate = date
        isDateSetByNavigation = true
        filterAppointmentsForSelectedDate()
    }

    func resetToCurrentDate() {
        selectedDate = itineraryDays.findItineraryDateOrDefault(for: sailorDate)
        isDateSetByNavigation = false
        filterAppointmentsForSelectedDate()
    }
    
    func handleSectionChange(section: MeNavigationSection) {

        switch section {
        case .agenda:
            resetToCurrentDate()
            selectedTab = .myAgenda
            
        case .addOns:
            selectedTab = .myAddOns
            
        case .agendaOnSpecificDate(let date):
            navigateToSpecificDate(date)
            selectedTab = .myAgenda
        }
    }
    
    private func filterAppointmentsForSelectedDate() {
        myAppointmentsForDay = myVoyageAgenda.filterByDate(selectedDate)
    }
    
    private func loadMyVoyageHeader() async {
        if let result = await executeUseCase({
            try await self.getMyVoyageHeaderUseCase.execute(useCache: true)
        }) {
            self.myVoyageHeader = result
        }
    }
    
    private func loadMyVoyageAgenda(useCache: Bool = true) async {
        if let result = await executeUseCase({
            try await self.getMyVoyageAgendaUseCase.execute(useCache: useCache)
        }) {
            self.myVoyageAgenda = result
        }
    }

    private func loadAddons(useCache: Bool = true) async {
        if let result = await executeUseCase({
            try await self.getMyVoyageAddOnsUseCase.execute(useCache: useCache)
        }) {
            self.myVoyageAddOns = result
        }
    }
    
    private func loadSailingMode() async {
        if let result = await executeUseCase({
            try await self.getSailingModeUseCase.execute()
        }) {
            sailingMode = result
        }
    }

    private func loadItineraryDates() async {
        self.itineraryDays = itineraryDatesUseCase.execute()
        self.itineraryDates = self.itineraryDays.getDates()

        let sailorDate = await getSailorDateAndTimeUseCase.execute()

        self.sailorDate = sailorDate
        if !self.isDateSetByNavigation {
            self.selectedDate = self.itineraryDays.findItineraryDateOrDefault(for: sailorDate)
        }
    }
    
    func goToBenefitsView() {
        if myVoyageHeader.type.isRockStar {
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenVipBenefitsCommand())
        }
    }

    func goToAddonsList() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddonsListCommand())
    }

    func goToAddonReceipt(addonCode: String) {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenAddonReceipeCommand(addonCode: addonCode))
    }

    func goToReceiptView(appointment: MyVoyageAgenda.Appointment) {
        switch appointment.bookableType {
        case .eatery:
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenEateryReceipeCommand(appointmentId: appointment.id))
        case .shoreExcursion:
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenShoreExcursionReceipeCommand(appointmentId: appointment.id))
        case .treatment:
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenTreatmentReceipeCommand(appointmentId: appointment.id))
        case .entertainment:
            appCoordinator.executeCommand(HomeTabBarCoordinator.OpenEntertainmentReceipeCommand(appointmentId: appointment.id))
        case .addOns:
            break
        case .undefined:
            break
        }
    }

    func goToProfileSettingScreen() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenUserProfileCommand())
    }

    func goToLineUpScreen() {
        appCoordinator.homeTabBarCoordinator.selectedTab = .discover(section: .events)
    }

    func goToWallet() {
        appCoordinator.executeCommand(HomeTabBarCoordinator.OpenWalletFromMeCommand())
    }
    
    func addToPlanner(){
        appCoordinator.executeCommand(HomeTabBarCoordinator.ShowAddToPlannerAnimationFullScreenCommand())
    }
}


