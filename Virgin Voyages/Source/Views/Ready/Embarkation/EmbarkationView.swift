//
//  EmbarkationView.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/21/24.
//

import SwiftUI

struct EmbarkationView: View {
	@State private var content: Model.Content?
	@State var sailTask: ReadyToSail.Task
	@State var screenTask = ScreenTask()
    var completionPercentage: Double

	var body: some View {
        ScreenView(name: sailTask.title, viewModel: Model(taskstatus: completionPercentage), content: $content) { task in
			EmbarkationScreen(embarkation: task)
		}
	}
	
	struct Model: Viewable {
		typealias Content = EmbarkationTask
		var requiresRefresh = true
		var showsTitle = false
		var sailor: Sailor?
        var taskstatus: Double?

		func fetch(authentication: Endpoint.SailorAuthentication) async throws -> Content {
			let content = try await authentication.fetch(Endpoint.GetEmbarkationSlotTask(reservation: authentication.reservation))
			let lookup = try await authentication.fetch(Endpoint.GetLookupData()).referenceData
            return .init(embarkation: content, reservation: authentication.reservation, airlines: lookup.airlines, ports: lookup.ports, taskStatus: taskstatus)
		}
		
		func load(authentication: Endpoint.SailorAuthentication) throws -> Content? {
			guard let content = try authentication.load(Endpoint.GetEmbarkationSlotTask(reservation: authentication.reservation)) else {
				return nil
			}
			
			guard let lookup = try authentication.load(Endpoint.GetLookupData()) else {
				return nil
			}
			
            return .init(embarkation: content, reservation: authentication.reservation, airlines: lookup.referenceData.airlines, ports: lookup.referenceData.ports, taskStatus: taskstatus)
		}
	}
}
