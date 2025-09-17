//
//  EmbarkationTask.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 6/1/24.
//

import Foundation

@Observable class EmbarkationTask: Sailable {
	var content: Endpoint.GetEmbarkationSlotTask.Response
	let airlines: [Endpoint.GetLookupData.Response.LookupData.Airline]
    var reviewable = true
	var task: SailTask = .stepAboard
	var flyingIn: FlightStep?
	var flyingOut: FlightStep?
	var transportationStep: TransportationStep?
	var boardingStep: BoardingStep?
	var arrivingWithYouStep: CabinMatesStep?
	var arrivalFlight: FlightInfo
	var departureFlight: FlightInfo
	var portName: String
	var partyMembersWithSlot: [PartyMember]
	var partyMembersWithoutSlot: [PartyMember]
	var postVoyagePartyMembers: [PartyMember]
    var partyMembers: [PartyMember]
    var taskStatus: Double?

    init(embarkation: Endpoint.GetEmbarkationSlotTask.Response, reservation: VoyageReservation, airlines: [Endpoint.GetLookupData.Response.LookupData.Airline], ports: [Endpoint.GetLookupData.Response.LookupData.Port], taskStatus: Double?) {
		self.content = embarkation
		self.airlines = airlines
		self.portName = ports.first { $0.code == reservation.embarkPortCode }?.name ?? reservation.embarkPortCode
        self.taskStatus = taskStatus

        let arrivalFlight = FlightInfo(title: embarkation.pageDetails.flightDetailsPage.question.replacingOccurrences(of: "{date}", with: reservation.startDate.format(.dateTitle)), body: embarkation.pageDetails.flightDetailsPage.description, airline: embarkation.flightDetails?.airlineCode ?? "", flightNumber: embarkation.flightDetails?.number ?? "", time: embarkation.flightDetails?.arrivalTime?.time ?? nil)

        let departureFlight = FlightInfo(title: embarkation.pageDetails.postVoyagePlansContent.flightDetailsQuestion, body: nil, airline: embarkation.postCruiseInfo?.flightDetails?.airlineCode ?? "", flightNumber: embarkation.postCruiseInfo?.flightDetails?.number ?? "", time: embarkation.postCruiseInfo?.flightDetails?.arrivalTime?.time ?? nil)

		self.arrivalFlight = arrivalFlight
		self.departureFlight = departureFlight
		
		if let flyingIn = embarkation.isFlyingIn {
			self.flyingIn = flyingIn ? (arrivalFlight.complete ? .complete : .yes) : .no
		} else {
			reviewable = false
		}
		
		if let flyingOut = embarkation.postCruiseInfo?.isFlyingOut {
			self.flyingOut = flyingOut ? (departureFlight.complete ? .complete : .yes) : .no
		} else {
			reviewable = false
		}

        if !embarkation.isVip || !embarkation.isRockStarBoardingGuest {
            if let slot = embarkation.selectedSlotInfo {
                boardingStep = .select(.init(time: slot.time, number: slot.number, optedByReservationGuestIds: []))
            } else {
                reviewable = false
            }
        }

		if let parking = embarkation.isParkingOpted {
			transportationStep = parking ? .yes : .no
		} else {
			reviewable = false
		}
		
		let partyMembersWithSlot: [PartyMember] = embarkation.partyMembers.filter {
			$0.isSlotSelected
		}.map {
			.init(partyMember: $0)
		}
		
		let partyMembersWithoutSlot: [PartyMember] = embarkation.partyMembers.filter {
			!$0.isSlotSelected
		}.map {
			.init(partyMember: $0)
		}
		
		if (partyMembersWithSlot + partyMembersWithoutSlot).contains(where: { $0.selected }) {
			arrivingWithYouStep = .complete
		}
		
		self.partyMembersWithSlot = partyMembersWithSlot
		self.partyMembersWithoutSlot = partyMembersWithoutSlot
		
		postVoyagePartyMembers = embarkation.postCruiseInfo?.partyMembers.map {
            .init(reservationGuestId: $0.reservationGuestId, name: $0.name, imageURL: URL(string: $0.photoURL), selected: $0.isPostCruiseInfoAvailable ?? false)
        } ?? embarkation.partyMembers.map {
            .init(partyMember: $0)
        }

        self.partyMembers = embarkation.partyMembers.map {
            .init(reservationGuestId: $0.reservationGuestId, name: $0.name, imageURL: URL(string: $0.photoURL), selected: false)
        }

        if isOutboundSkiped || StepStatus(rawValue: taskStatus ?? 0.0) == .completed {
            reviewable = true
        }
	}

    enum StepStatus {
        case uncompleted
        case completed
        case partiallyCompleted

        init?(rawValue: Double) {
            switch rawValue {
            case 0.0:
                self = .uncompleted
            case 1.0:
                self = .completed
            default:
                self = .partiallyCompleted
            }
        }
    }

    var isOutboundSkiped: Bool {
        if let taskStatus, let status = StepStatus(rawValue: taskStatus), status == .partiallyCompleted, content.postCruiseInfo?.isFlyingOut == nil {
            return true
        }
        return false
    }

	var isPriorityGuest: Bool {
		content.isPriorityBoardingGuest || content.isVip || content.isRockStarBoardingGuest
	}
	
	var terminalArrivalTimeText: String? {
		if let slotStartTime = content.slotStartTime, let slotEndTime = content.slotEndTime {
			return "\(slotStartTime)–\(slotEndTime)"
		}
		
		switch boardingStep {
		case .select(let slot):
			return slot.time.time?.format(.time)
		default:
			return nil
		}
	}

    var isMegaRockStar: Bool {
        isPriorityGuest && content.isCarBookingRequired
    }

	var terminalArrivalTimeLabel: String {
		content.pageDetails.boardingWindowContent.terminalArrivalTime
	}
	
	var arrivalTimeLabel: String {
		content.pageDetails.boardingWindowContent.arrivalTime
	}
	
	var locationLabel: String {
		content.pageDetails.labels.location
	}

    func airlineName(from code: String) -> String {
        self.airlines.first { $0.code == code }?.name ?? ""
    }

    func airlineCode(from name: String) -> String {
        self.airlines.first { $0.name == name }?.code ?? ""
    }

	func reload(_ sailor: Endpoint.SailorAuthentication) async throws {
		
	}
	
	var navigationMode: NavigationMode {
		switch step {
		case .areYouFlyingIn, .review, .save:
			.dismiss
		case .flyingInDetails, .priorityBoarding, .standardBoarding, .areYouFlyingOut, .flyingOutDetails, .arrivingWithYou, .carServiceForm, .carServiceRequest, .parking, .leavingWithYou:
			.both
		}
	}
	
	func startInterview() {
		
	}
	
	func startOver() {
		
	}
	
	func back() {
		switch step {
		case .flyingInDetails:
			flyingIn = nil
			
		case .priorityBoarding, .standardBoarding:
			flyingIn = flyingIn == .complete ? .yes : nil
			
		case .carServiceRequest:
			boardingStep = nil
			
		case .carServiceForm:
			transportationStep = nil
			
		case .areYouFlyingOut:
			if arrivingWithYouStep == .complete {
				arrivingWithYouStep = nil
			} else {
                if !isMegaRockStar {
                    boardingStep = nil
                } else {
                    transportationStep = nil
                }
			}
			
		case .flyingOutDetails:
			flyingOut = nil
			
		case .parking:
			boardingStep = nil
			
		case .arrivingWithYou:
			transportationStep = nil
			
		case .leavingWithYou:
			flyingOut = flyingOut == .complete ? .yes : .no
			
		default:
			break
		}
	}
	
	var step: Step {
		if reviewable {
			return .review
		}
		
		switch flyingIn {
        case .none, .skip:
			return .areYouFlyingIn
		case .yes:
			return .flyingInDetails
		case .no, .complete:
			switch boardingStep {
			case .confirm, .select:
				if isPriorityGuest {
					switch transportationStep {
					case .yes:
						return .carServiceForm
					case .no, .skip, .complete:
						switch flyingOut {
						case .yes:
							return .flyingOutDetails
						case .complete:
							return .leavingWithYou
                        case .no, .none, .skip:
							return .areYouFlyingOut
						}
						
					case .none:
						return .carServiceRequest
					}
				} else {
					switch transportationStep {
					case .none:
						return .parking
						
					default:
						if arrivingWithYouStep == nil, (partyMembersWithSlot.count + partyMembersWithoutSlot.count) > 0 {
							return .arrivingWithYou
						}
						
						switch flyingOut {
                        case .yes:
							return .flyingOutDetails
						case .complete:
							return .leavingWithYou
                        case .no, .none, .skip:
							return .areYouFlyingOut
						}
					}
				}
			case .none:
				if content.isPriorityBoardingGuest {
					return .priorityBoarding(.init(content, page: content.pageDetails.boardingWindowContent.priorityBoarding))
				}
				
				if content.isVip || content.isRockStarBoardingGuest {
					return .priorityBoarding(.init(content, page: content.pageDetails.boardingWindowContent.vipBoarding))
				}
				
				return .standardBoarding
			}
		}
	}
	
	private var arrivingWithGuestIds: [String] {
		(partyMembersWithSlot + partyMembersWithoutSlot).filter {
			$0.selected
		}.map {
			$0.id
		}
	}
	
	private var leavingWithGuestIds: [String] {
		postVoyagePartyMembers.filter {
			$0.selected
		}.map {
			$0.id
		}
	}
	
	var saveRequest: Endpoint.UpdateEmbarkationSlotTask.Request {
        .init(flightDetails: flyingIn?.value == true ? .init(number: arrivalFlight.flightNumber, airlineCode: arrivalFlight.airline, arrivalTime: arrivalFlight.time?.format(.hour24)) : nil, isPriorityBoardingGuest: content.isPriorityBoardingGuest, isVIPGuest: content.isVIPGuest, slotNumber: boardingStep?.slotNumber, isParkingOpted: transportationStep?.optedIn, optedByReservationGuestIds: arrivingWithGuestIds, isFlyingIn: flyingIn?.value, isRockStarBoardingGuest: content.isRockStarBoardingGuest, postCruiseInfo: flyingOut != .skip ? .init(optedByReservationGuestIds: leavingWithGuestIds, flightDetails: flyingOut?.value == true ?  .init(number: departureFlight.flightNumber, airlineCode: departureFlight.airline, arrivalTime: departureFlight.time?.format(.hour24)) : nil, isFlyingOut: flyingOut?.value) : Endpoint.UpdateEmbarkationSlotTask.Request.PostCruiseInfo())
	}

    var updateInboundFlight: Endpoint.UpdateFlight.Request {
        .init(flightDetails: .init(airlineCode: arrivalFlight.airline, number: arrivalFlight.flightNumber, arrivalTime: arrivalFlight.time?.format(.hour24)), isFlyingIn: flyingIn?.value ?? true)
    }
}

extension EmbarkationTask {
	enum Step {
		case areYouFlyingIn
		case flyingInDetails
		case priorityBoarding(PriorityBoardingPage)
		case standardBoarding
		case carServiceForm
		case carServiceRequest
		case parking
		case areYouFlyingOut
		case flyingOutDetails
		case arrivingWithYou
		case save
		case review
		case leavingWithYou
	}

	enum TransportationStep {
		case yes
		case no
		case skip
		case complete
		
		var optedIn: Bool {
			switch self {
			case .yes, .complete: true
			case .no, .skip: false
			}
		}
	}
	
	enum FlightStep {
		case yes
		case no
		case complete
        case skip

		var value: Bool? {
			switch self {
			case .yes, .complete: true
			case .no: false
            case .skip: nil
			}
		}
	}
	
	enum CabinMatesStep {
		case complete
	}
	
	enum BoardingStep {
		case confirm(Endpoint.GetEmbarkationSlotTask.Response.Slot?)
		case select(Endpoint.GetEmbarkationSlotTask.Response.Slot)

		var slotNumber: Int? {
			switch self {
            case .select(let slot): slot.number
            case .confirm(let slot):
                slot?.number
			}
		}
	}
	
	struct PriorityBoardingPage {
		var header: String
		var body: AttributedString
		var buttonLabel: String
		
		init(_ content: Endpoint.GetEmbarkationSlotTask.Response, page: Endpoint.GetEmbarkationSlotTask.Response.BoardingWindowContent.PriorityBoarding) {
			header = page.header
			
			if let slotStartTime = content.slotStartTime, let slotEndTime = content.slotEndTime {
				body = page.description.replacingOccurrences(of: "{TIME}", with: "**\(slotEndTime)**").replacingOccurrences(of: slotStartTime, with: "**\(slotStartTime)**").markdown
			} else {
				body = page.description.markdown
			}

			buttonLabel = "Ok, got it"
		}
	}
	
	@Observable class FlightInfo {
		var title: String
		var body: String?
		var airline: String
		var flightNumber: String // "1965"
		var time: Date? // "10:30:00"

		init(title: String, body: String?, airline: String, flightNumber: String, time: Date?) {
			self.title = title
			self.body = body
			self.airline = airline
			self.flightNumber = flightNumber
			self.time = time
		}
		
		var complete: Bool {
			!airline.isEmpty && !flightNumber.isEmpty
		}
	}
	
	@Observable class PartyMember: Identifiable, Equatable {
		var id: String { reservationGuestId }
		var reservationGuestId: String // "c01f3c77-a072-40d6-a463-3c924d11f6ae"
		var name: String // "Tisha lubowitzsec"
		var imageURL: URL?
		var selected: Bool // false
		
		static func == (lhs: EmbarkationTask.PartyMember, rhs: EmbarkationTask.PartyMember) -> Bool {
			lhs.reservationGuestId == rhs.reservationGuestId
		}
		
		init(partyMember: Endpoint.GetEmbarkationSlotTask.Response.PartyMember) {
			reservationGuestId = partyMember.reservationGuestId
			name = partyMember.name
			imageURL = URL(string: partyMember.photoURL)
			selected = partyMember.isSameSlotSelected
		}
		
		init(reservationGuestId: String, name: String, imageURL: URL?, selected: Bool) {
			self.reservationGuestId = reservationGuestId
			self.name = name
			self.imageURL = imageURL
			self.selected = selected
		}
	}
}

// MARK: Authenticable

extension Endpoint.SailorAuthentication {
	@discardableResult func save(embarkation: EmbarkationTask) async throws -> Endpoint.GetReadyToSail.UpdateTask {
        try await fetch(Endpoint.UpdateEmbarkationSlotTask(task: embarkation, reservation: reservation))
	}

    @discardableResult
    func updateInboundFlight(embarkation: EmbarkationTask) async throws -> Endpoint.UpdateFlight.Response {
        let slots = try await fetch(Endpoint.UpdateFlight(task: embarkation, reservation: reservation))
        return slots
    }
}

extension EmbarkationTask {
    func editingInbound() {
        reviewable = false
        flyingIn = nil
        boardingStep = nil
        transportationStep = nil
        if arrivingWithYouStep == .complete, (partyMembersWithSlot.count + partyMembersWithoutSlot.count) > 0 {
            arrivingWithYouStep = nil
        }
        flyingOut = nil
    }

    func editingOutbound() {
        reviewable = false
        transportationStep = .complete
        arrivingWithYouStep = .complete
        flyingOut = nil
    }
}
