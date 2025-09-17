//
//  ShipWiFiConnectivityService.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 03/07/25.
//

import Foundation

enum ShipWiFiConnectivityConnectionState {
	case precruise
	case noDataConnection
	case noDataConnectionWelcomeAboard
	case offlineModePortDay
	case troubleshooting
	case connectedToShipWiFi
}

extension ShipWiFiConnectivityConnectionState {
	var shouldShowConnectToWiFi: Bool {
		if self == .noDataConnection || self == .noDataConnectionWelcomeAboard || self == .troubleshooting {
			return true
		}

		return false
	}

	var isOfflineModePortDay: Bool {
		if self == .offlineModePortDay {
			return true
		}

		return false
	}
}

protocol ShipWiFiConnectivityServiceProtocol {
	var state: ShipWiFiConnectivityConnectionState { get }
	func checkConnection() async
	func addObserver(_ observer: ShipWiFiConnectivityServiceObserver)
	func removeObserver(_ observer: ShipWiFiConnectivityServiceObserver)
}

protocol ShipWiFiConnectivityServiceObserver: AnyObject {
	func connectivityDidUpdate()
}

private class ShipWiFiConnectivityServiceObserverWrapper {
	weak var observer: ShipWiFiConnectivityServiceObserver?

	init(observer: ShipWiFiConnectivityServiceObserver) {
		self.observer = observer
	}
}

class ShipWiFiConnectivityService: ShipWiFiConnectivityServiceProtocol {

	private let currentSailorManager: CurrentSailorManagerProtocol
	private let shipNetworkDetector: ShipNetworkDetectorProtocol
	private let reservationRepository: ReservationsRepositoryProtocol
	private let checkInStatusRepository: CheckInStatusRepositoryProtocol
	private let dateTimeRepository: DateTimeRepositoryProtocol
	private let networkMonitor: NetworkMonitorProtocol

	private var observers = [ShipWiFiConnectivityServiceObserverWrapper]()

	var state: ShipWiFiConnectivityConnectionState = .precruise

	static let shared = ShipWiFiConnectivityService()

	private init(
		currentSailorManager: CurrentSailorManagerProtocol = CurrentSailorManager(),
		shipNetworkDetector: ShipNetworkDetectorProtocol = ShipNetworkDetector(),
		reservationRepository: ReservationsRepositoryProtocol = ReservationsRepository(),
		checkInStatusRepository: CheckInStatusRepositoryProtocol = CheckInStatusRepository(),
		dateTimeRepository: DateTimeRepositoryProtocol = DateTimeRepository(),
		networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared
	) {
		self.currentSailorManager = currentSailorManager
		self.shipNetworkDetector = shipNetworkDetector
		self.reservationRepository = reservationRepository
		self.checkInStatusRepository = checkInStatusRepository
		self.dateTimeRepository = dateTimeRepository
		self.networkMonitor = networkMonitor
	}

	func checkConnection() async {
		state = await determineConnectionState()
		notifyObservers()
	}

	private func determineConnectionState() async -> ShipWiFiConnectivityConnectionState {
		guard let sailor = currentSailorManager.getCurrentSailor() else {
			return .precruise
		}

		let isShipNetworkReachable = await shipNetworkDetector.isShipNetworkReachable()

		if isShipNetworkReachable {
			return .connectedToShipWiFi
		}

		let reservationGuestID = sailor.reservationGuestId
		let checkInStatus = try? await checkInStatusRepository.fetchCheckInStatus(
			reservationNumber: sailor.reservationNumber,
			reservationGuestID: reservationGuestID
		)

		if let checkInStatus = checkInStatus, checkInStatus.isGuestCheckedIn == false {
			return .precruise
		}

		if let checkInStatus = checkInStatus,
		   checkInStatus.isGuestCheckedIn,
		   checkInStatus.isGuestOnBoard == false,
		   let embarkationDate = sailor.embarkDate.fromYYYYMMDD(),
			embarkationDate.isToday,
			!isShipNetworkReachable {
			return .precruise
		}

		if let checkInStatus = checkInStatus,
		   checkInStatus.isGuestOnBoard,
		   let embarkationDate = sailor.embarkDate.fromYYYYMMDD(),
			embarkationDate.isToday,
			!isShipNetworkReachable {
			return .noDataConnectionWelcomeAboard
		}

		let dateTime = await dateTimeRepository.fetchDateTime()

		let isPortDay = sailor.itineraryDays.first(where: {
			!$0.isSeaDay && isSameDay(date1: $0.date, date2: dateTime.getCurrentDateTime())
		}) != nil

		let isSeaDay = sailor.itineraryDays.first(where: {
			$0.isSeaDay && isSameDay(date1: $0.date, date2: dateTime.getCurrentDateTime())
		}) != nil

		if isPortDay {
			return .offlineModePortDay
		}

		if isSeaDay {
			return .troubleshooting
		}

		guard checkInStatus != nil else {
			return .noDataConnection
		}

		if !networkMonitor.isConnected {
			return .noDataConnection
		}

		return .precruise
	}

	private func notifyObservers() {
		observers.forEach { $0.observer?.connectivityDidUpdate() }
	}

	func addObserver(_ observer: ShipWiFiConnectivityServiceObserver) {
		if !observers.contains(where: { $0.observer === observer }) {
			observers.append(ShipWiFiConnectivityServiceObserverWrapper(observer: observer))
		}
	}

	func removeObserver(_ observer: ShipWiFiConnectivityServiceObserver) {
		observers.removeAll(where: { $0.observer === observer || $0.observer == nil })
	}
}
