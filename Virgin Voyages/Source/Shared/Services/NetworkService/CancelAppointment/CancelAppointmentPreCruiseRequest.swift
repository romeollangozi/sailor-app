//
//  CancelAppointmentPreCruiseRequest.swift
//  Virgin Voyages
//
//  Created by Darko Trpevski on 10.2.25.
//

extension NetworkServiceProtocol {
    func cancelAppointmentFromPreCruise(requestBody: CancelAppointmentRequestBody) async throws -> CancelAppointmentResponse {
        let request = CancelAppointmentRequest(input: requestBody)
        let result = try await self.requestV2(request, responseModel: CancelAppointmentResponse.self)
        return result
    }
}
