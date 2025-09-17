//
//  MessengerErrorState.swift
//  Virgin Voyages
//
//  Created by TX on 20.8.25.
//

public enum MessengerErrorState: ErrorBoxErrorStateProtocol {
    case retryAvailable
    case retryUnavailable
    
    public var title: String {
        switch self {
        case .retryAvailable:
            return "Please try again"
        case .retryUnavailable:
            return "Please try again later"
        }
    }
    
    public var description: String {
        switch self {
        case .retryAvailable:
            return "There was a connection error. Please try again."
        case .retryUnavailable:
            return "We seem to have a problem in engineering! Please try again later, or contact Sailor Services if urgent."
        }
    }
}
