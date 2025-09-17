//
//  WiFiSheet.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 1/25/24.
//

import SwiftUI

struct WiFiSheet: View {
	@State private var appEnvironment: AppEnvironment = AppConfig.shared.appEnvironment

    var body: some View {
		VStack(alignment: .leading) {
			Text("**Environment**")
            // MARK: - Connection Type Selection
            Picker("Connection Type", selection: $appEnvironment) {
				ForEach(AppEnvironment.allCases) { type in
                    Text(type.description)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
			Spacer()
        }
		.padding()
        .onChange(of: appEnvironment) {
			AppConfig.shared.appEnvironment = appEnvironment
        }
    }
}
