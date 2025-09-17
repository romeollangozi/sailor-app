//
//  APIEndpoint.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 16.9.24.
//

import Foundation

struct NetworkServiceEndpoint {
    static let resetPasswordPath = "/user-account-service/resetpassword"
    static let clientTokenPath = "/identityaccessmanagement-service/oauth/token"
    static let signUpPath = "/user-account-service/signup"
    static let signUpSocialPath = "/user-account-service/signup/social"
    static let getSignupEmailValidation = "/user-account-service/validateemail"
    static let uploadImagePath = "/dxpcore/mediaitems"
    static let updateUserProfile = "/user-account-service/userprofile"
    static let getUserProfile = "/user-account-service/userprofile"
    static let getActivitiesGuestList = "/guest-bff/ars/guestactivities"
    static let getAddOnPaymentPagePath = "/guest-bff/v2/addon/pay"
    static let dashboardLandingPath = "/guest-bff/guest-dashboard/landing"
    static let getUserPaymentMethods = "/guest-bff/voyage-account-settings/user/payment"
    static let getAddonDetails = "/guest-bff/addon/details/v2"
    static let cancelAddon = "/guest-bff/addon/remove"
    
    // Messages
    static let getReadMessages = "/messaging-service/getAllReadNotification"
    static let getUnreadMessages = "/messaging-service/getAllUnreadNotification"
    static let getMessengerContacts = "/guest-bff/messaging/contacts"
    static let addFriendToContacts = "/guest-bff/messaging/contacts"
    static let addContact = "/guest-bff/messaging/contact/preferences"
    static let markNotificationMessagesAsRead = "/messaging-service/markNotificationRead"
    static let getChatThreads = "/guest-bff/nsa/messenger/chat-threads"
    static let getSailorChatData = "/api/v1/users/me/support_queue"
    static let getChatThreadMessages = "/guest-bff/nsa/messenger"
    static let sendCrewChatMessage = "/api/v1/messages"
    static let sendChatMessage = "/api/v1/support_queue/messages"
    static let markSupportChatMessageAsRead = "/api/v1/support_queue/messages/flags"
    static let markCrewChatMessageAsRead = "/api/v1/messages/flags"
    static let registerForChatPolling = "/api/v1/registration"
    static let pollChatMessages = "/api/v1/events"
    
    // Home
    static let getHomeGeneral = "/guest-bff/nsa/home/general"
    static let getHomeCheckInTask = "/guest-bff/nsa/home/check-in-tasks"
    static let getPlanAndBook = "/guest-bff/nsa/home/voyage-activities"
    static let getHomeUnreadMessages = "/guest-bff/nsa/messenger/unread-messages"
    
    // Mustering
    static let getMusterDrill = "/cabin-bff/nsa/mustering"
    static let markMusterDrillVideoAsWatched = "/svc/cabin-bff/stateroom/muster/watcher/"
    
    static let getHomeComingGuide = "/guest-bff/nsa/home/home-coming-guide"
    static let getItineraryDetails = "/guest-bff/v2/itinerary"
    static let getHomePlanner = "/guest-bff/nsa/home/planner"
    
    // Boarding Pass
    static let getBoardingPass = "/guest-bff/nsa/boardingpass"
    static let getAppleWalletForBoardingPass = "/wallet-bff/nsa/apple-wallet-pass"
    
    //Identity
    static let getClientToken = "/identityaccessmanagement-service/oauth/token"
    static let registerDeviceToken = "/messaging-service/pushNotificationRegister"
    static let unregisterDeviceToken = "/messaging-service/pushNotificationUnregister"
    
    // Settings and Profile
    static let getSettingsProfileScreen = "/guest-bff/voyage-account-settings/landing"
    static let getSettingsProfileTermsAndConditionsScreen = "/guest-bff/voyage-account-settings/content/legal"
	static let setPin = "/guest-bff/voyage-account-settings/account/setpin"

    // Reservations
    static let sailorReservations = "/guest-bff/voyage-account-settings/user/reservations"
    static let sailorReservationSummary = "/dxpcore/reservation/summary"
    static let getMyVoyageStatus = "/guest-bff/guest/v1/sailing-status"
    
    
    // Booking
    static let bookActivityVPS = "/guest-bff/v2/activity/book"        // VPS → ShoreEx & Spa, only for pre-cruise booking
    static let bookActivityVXP = "/guest-bff/ars/v2/book"             // VXP → General booking, editing, canceling
    static let bookActivityDiningOnly = "/guest-bff/dining/book"      // VXP → Eatery booking only
    
    // Claim booking
    static let claimBooking = "/guest-bff/claimBooking"
    
    // Appointments
    static let activityAppointmentDetails = "/guest-bff/ars/appointments"
    
    // Dining
    static let eateriesList = "/guest-bff/discover/spacetype/eateries/listing"
    static let eateriesSlots = "/guest-bff/nsa/discover/spacetype/eateries/slots"
    static let bookSlot = "/guest-bff/dining/book"
    static let eateriesConflicts = "/guest-bff/discover/spacetype/eateries/conflicts"
    static let updateBookSlot = "/guest-bff/dining/book"
    static let eateriesDetails = "/guest-bff/discover/spacetype/Eateries"
    static let eateriesOpeningTimes = "/guest-bff/discover/spacetype/eateries/opening-time"
    static let eateriesAppointments = "/guest-bff/nsa/eateries/appointments"
    
    // Line up
    static let lineUp = "/guest-bff/nsa/line-ups"
    static let lineUpAppointmentDetails = "/guest-bff/nsa/line-ups/appointments"
    
    // Ship spaces
    static let shipSpacesCategories = "/guest-bff/nsa/ship-spaces"
    static let shipSpaceCategoryDetails = "/guest-bff/nsa/ship-spaces/categories"
    static let treatmentsAppointmentDetails =  "/guest-bff/nsa/treatments/appointments"
    
    // Entertainment
    static let cancelAppointment = "/guest-bff/ars/v2/book"
    
    //Discover
    static let discoverLanding = "/guest-bff/nsa/discover"
    
    //RTS
    static let getTravelDocuments = "/rts-bff/nsa/travel-docs"
    static let getMyDocuments = "/rts-bff/nsa/travel-docs/my-documents"
    static let saveTravelDocuments = "/rts-bff/nsa/travel-docs/save"
    static let getPostVoyagePlans = "/rts-bff/nsa/travel-docs/post-voyage-plans"
    static let saveCitizenship = "/rts-bff/guest/update"

    //Sailors
    static let mySailors = "/guest-bff/nsa/sailors"
    static let sailorProfile = "/guest-bff/nsa/sailors/profile"
    
    // Me
    static let myVoyageHeader = "/guest-bff/nsa/my-voyage/header"
    static let myVoyageAddons = "/guest-bff/nsa/my-voyage/add-ons"
    static let myVoyageAgenda = "/guest-bff/nsa/my-voyage/agenda"
    static let getVipBenefits = "/guest-bff/myvoyages/vipbenefits/v2"
    
    //Bookables Conflicts
    static let bookableConflicts = "/guest-bff/nsa/bookables/conflicts"
    
    // CheckInStatus
    static let fetchCheckInStatus = "/guest-bff/guest/check-in-status"
    
    // Home
    static let homeNotification = "/guest-bff/nsa/home/notifications"
    static let notifications = "/guest-bff/nsa/notifications"
    static let statusBannerNotifications = "/guest-bff/nsa/status-banners"
    
    // All Aboard Times
    static let allAboardTimes = "/dxpcore/voyages/search/findbyvoyagenumber"
    static let shipTime = "/dxpcore/shiptimes/search/findbyshipcode"
    
    // Cabin Services
    static let cabinServices = "/cabin-bff/nsa/services/cabin"
    static let createCabinServiceRequest = "/cabin-bff/housekeeping/createRequest"
    static let cancelCabinServiceRequest = "/svc/cabin-bff/housekeeping/updateRequest"
    static let createMaintenanceServiceRequest = "/cabin-bff/housekeeping/maintenance"
    static let cancelMaintenanceServiceRequest = "/cabin-bff/housekeeping/maintenance"
    
    // Health Check
    static let healthCheckDetail = "/rts-bff/healthcheck"
    static let updateHealthCheckDetail = "/rts-bff/healthcheck" 
    
    // Help and Support
    static let helpAndSupport = "/guest-bff/help-support/helps/v1"
    
    // Sign in
    static let signInWithEmail = "/user-account-service/signin/email"
    
    //Resources and assets
    static let stringResources = "/guest-bff/nsa/resource-mapping"
    static let assetResources = "/guest-bff/nsa/assets"
    
    //Shorex
    static let shorexAppointmentDetails = "/guest-bff/nsa/shore-excursions/appointments"
    
    static let shorexList = "/guest-bff/nsa/ports/shore-excursions"
    static let shorexPorts = "/guest-bff/nsa/ports"
    
    // Shake For Champagne
    static let shakeForChampagneLanding = "/sailor-app-bff/shake-for-champagne/landing"
    static let shakeForChampagneOrder = "/sailor-app-bff/shake-for-champagne/order"
    static let shakeForChampagneCancelOrder = "/sailor-app-bff/shake-for-champagne/order"
    
    // Beacon
    static let beacon = "/sailor-app-bff/beacon"
    
    //Folio
    static let getFolio = "/guest-bff/nsa/folio"
    static let downloadFolioInvoice = "/dxpcore/folio/invoice"

    // ComponentSettings
    static let componentSettings = "/svc/dxpcore/componentSettings"
    
    //Voyage reservation
    static let voyageReservations = "/guest-bff/voyage-account-settings/user/reservations"
	
	//Feature Flags
	static let featureFlags = "/sailor-app-bff/feature-flags"

}
