//
//  QMTrackError.swift
//  Virgin Voyages
//
//  Created by Ljupcho Gjorgjiev on 20.2.25.
//

typealias QMError = (id: Int, value: String)

enum QMTrackError {
    case customError(error: QMError)
    
    var details: QMError {
        switch self {
        case .customError(let error):
            return error
        }
    }
}
