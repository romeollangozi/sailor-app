//
//  BuildConfigurationView.swift
//  Virgin Voyages
//
//  Created by Abel Duarte on 1/31/25.
//

import SwiftUI

struct BuildConfigurationView<DebugView: View, ReleaseView: View>: View {
    let debugView: DebugView
    let releaseView: ReleaseView

    init(@ViewBuilder debugView: () -> DebugView, @ViewBuilder releaseView: () -> ReleaseView) {
        self.debugView = debugView()
        self.releaseView = releaseView()
    }

    var body: some View {
        Group {
            if AppConfig.shared.buildConfiguration == .debug {
                debugView
            } else {
                releaseView
            }
        }
    }
}

struct VVToDoBuildConfigurationView<ReleaseView: View>: View {
	var title: String
	let releaseView: ReleaseView

	init(title: String, @ViewBuilder releaseView: () -> ReleaseView) {
		self.title = title
		self.releaseView = releaseView()
	}

	var body: some View {
		BuildConfigurationView {
			VVToDoView(title: title)
		} releaseView: {
			releaseView
		}
	}
}
