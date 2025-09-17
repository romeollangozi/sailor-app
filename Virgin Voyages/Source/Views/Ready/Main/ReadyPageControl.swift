//
//  ReadyScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/17/23.
//

import SwiftUI

struct ReadyPageControl: View {
    var sail: ReadyToSail
    @Binding var pagedTask: SailTask?

    var body: some View {
        HStack {
            Spacer()
            ForEach(sail.tasks.dropFirst()) { task in
                Button {
                    pagedTask = task
                } label: {
					ZStack {
						switch sail.task(task).caption.lowercased() {
						case "start":
							Image(systemName: "circle")
								.resizable()
								.foregroundStyle(.white)
						case "partially complete":
							Image(systemName: "circle.bottomhalf.filled")
								.resizable()
								.foregroundStyle(.white)
						case "redo":
							Image(systemName: "exclamationmark.circle.fill")
								.resizable()
								.foregroundStyle(.white, .orange)							
						default:
							Image(systemName: sail.task(task).pageImageName)
								.resizable()
								.foregroundStyle(Color.accentColor, .white)
						}
					}
					.opacity(task == pagedTask ? 1 : 0.5)
					.frame(width: 30, height: 30)
                }
                Spacer()
            }
        }
        .opacity(pagedTask == .welcome ? 0 : 1)
        .padding()
        .foregroundStyle(.white)
    }
}
