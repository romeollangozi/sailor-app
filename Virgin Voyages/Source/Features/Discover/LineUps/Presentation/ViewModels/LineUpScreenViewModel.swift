//
//  LineUpScreenViewModel.swift
//  Virgin Voyages
//
//  Created by Kreshnik Balani on 13.1.25.
//

import Foundation
import Combine

@Observable class LineUpScreenViewModel: BaseViewModel, LineUpScreenViewModelProtocol {
    private let getLineUpUseCase: GetLineUpUseCaseProtocol
    private let getSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol
	private let itineraryDatesUseCase : GetItineraryDatesUseCaseProtocol
	private var cancellables = Set<AnyCancellable>()
	private var bookingEventsNotificationService: BookingEventsNotificationService
	private var listenerKey = "LineUpScreenViewModel"

    var lineUp: LineUp = LineUp.empty()
    var selectedDate: Date = Date() {
        didSet {
            if isSameDay(date1: selectedDate, date2: sailorDate) {
                scrollToNextLineup()
            } else {
                scrollToTime = "top"
            }
        }
    }
    var firstUpcomingEventIndex: Int {
        lineUp.filterByDate(selectedDate).firstIndex { event in
            event.items.contains { $0.selectedSlot?.status != .passed && $0.selectedSlot?.status != .closed }
        } ?? 0
    }
    
    let countdownTimer = CountdownTimer()
    var openingTitle: String = ""
    var sailorDate: Date = Date()
    var scrollToTime: String? = nil
	var itineraryDays: [ItineraryDay] = []
	private var itineraryDates: [Date] = []
	
    var screenState: ScreenState = .loading
    var isLoadingData: Bool = false
    
    init(getLineUpsUseCase: GetLineUpUseCaseProtocol = GetLineUpUseCase(),
         getSailorDateAndTimeUseCase: GetSailorDateAndTimeUseCaseProtocol = GetSailorDateAndTimeUseCase(),
		 itineraryDatesUseCase: GetItineraryDatesUseCaseProtocol = GetItineraryDatesUseCase(),
         bookingEventsNotificationService: BookingEventsNotificationService = .shared) {
        self.getLineUpUseCase = getLineUpsUseCase
        self.getSailorDateAndTimeUseCase = getSailorDateAndTimeUseCase
		self.itineraryDatesUseCase = itineraryDatesUseCase
		self.bookingEventsNotificationService = bookingEventsNotificationService
		
        super.init()
		self.startObservingEvents()
    }

    func onFirstAppear() {
        Task {
            await loadSailorDateAndTime()
            
			await loadItineraryDates()
		
			await loadLineUp()
            
			await executeOnMain({
                self.scrollToNextLineup()
            })
        }
    }
	
	func onReAppear() {
		Task {
            await loadSailorDateAndTime()

			await loadLineUp()
            
            await executeOnMain({
                self.scrollToNextLineup()
            })
		}
	}
	
    func onRefresh() {
        Task {
            await loadSailorDateAndTime()

			await loadItineraryDates()
			
            await loadLineUp()
			
            await executeOnMain({
                self.scrollToNextLineup()
            })
        }
    }
	
	private func loadItineraryDates() async {
		await executeOnMain {
			self.itineraryDays = itineraryDatesUseCase.execute()
			self.itineraryDates = self.itineraryDays.getDates()
		}
		
		await executeOnMain {
			self.selectedDate = itineraryDays.findItineraryDateOrDefault(for: sailorDate)
            self.scrollToNextLineup()
		}
	}

    func isNextDateAvailable() -> Bool {
		guard let currentIndex = itineraryDates.firstIndex(of: selectedDate),
              currentIndex < itineraryDates.count - 1 else {
            return false
        }

        return true
    }

    func goToNextDate() {
		guard let currentIndex = itineraryDates.firstIndex(of: selectedDate),
              currentIndex < itineraryDates.count - 1 else {
            return
        }

		selectedDate = itineraryDates[currentIndex + 1]
    }
    
    func scrollToNextLineup() {
        for event in lineUp.events {
            for item in event.items {
                if let eventDate = item.selectedSlot?.startDateTime, isSameDay(date1: selectedDate, date2: sailorDate),
                   eventDate >= sailorDate {
                    scrollToTime = event.time
                    return
                }
            }
        }
    }

	private func loadLineUp(useCache: Bool = true) async {
        if let result = await executeUseCase({
			try await self.getLineUpUseCase.execute(useCache: useCache)
        }) {
            await executeOnMain {
                self.lineUp = result
                self.isLoadingData = false

				if let leadTime = self.lineUp.leadTime {
					self.countdownTimer.startCountdown(secondsLeft: leadTime.timeLeftToBookingStartInSeconds)
					self.observeCountdown()
				}
				
				self.screenState = .content
            }
		} else {
			await executeOnMain {
				self.screenState = .error
			}
		}
    }
    
    private func loadSailorDateAndTime() async {
        self.sailorDate = await getSailorDateAndTimeUseCase.execute()
        await executeOnMain {
            self.sailorDate = sailorDate
        }
    }
    
    private func observeCountdown() {
        countdownTimer.$countdownText
            .receive(on: RunLoop.main)
            .sink { [weak self] countdown in
                guard let self else { return }
                self.openingTitle = "The Event Line-Up opens in \(countdown)"
                //Refresh page when minutes left to opening times == 0
                if countdown.isEmpty {
                    self.onRefresh()
                }
            }
            .store(in: &cancellables)
    }

	deinit {
		stopObservingEvents()
	}

    func addToPlanner(){
        navigationCoordinator.executeCommand(HomeTabBarCoordinator.ShowAddToPlannerAnimationFullScreenCommand())
    }
}

// MARK: - Event Handling
extension LineUpScreenViewModel {

	func startObservingEvents() {
		bookingEventsNotificationService.listen(key: listenerKey) { [weak self] event in
			guard let self else { return }
			self.handleEvent(event)
		}
	}

	func stopObservingEvents() {
		bookingEventsNotificationService.stopListening(key: listenerKey)
	}

	func handleEvent(_ event: BookingEventNotification) {
		switch event {
		case .userDidMakeABooking, .userDidCancelABooking, .userDidUpdateABooking:
			onReAppear()
		}
	}
}
