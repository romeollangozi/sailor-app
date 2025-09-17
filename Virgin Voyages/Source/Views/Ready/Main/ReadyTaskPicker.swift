//
//  ReadyScreen.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 5/17/23.
//

import SwiftUI

struct ReadyTaskPicker: View {
    var sail: ReadyToSail
    @Binding var pagedTask: SailTask?
    @Binding var selectedTask: SailTask?

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(sail.tasks) { task in
                    if task == .welcome {
                        ReadyWelcomeScreen(landing: sail.landingIntroStart)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .id(task)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0)
                            }
                            .opacity(task == pagedTask ? 1 : 0)
                    } else if task == .securityPhoto {
						ZStack(alignment: .leading) {
							ReadyRow(sail: sail, task: task, selectedTask: $selectedTask)

							VStack {
								Spacer()
								Button {
									pagedTask = .securityPhoto
								} label: {
									ZStack {
										Circle()
											.frame(width: 64, height: 64)
											.foregroundColor(Color.accentColor)

										Image("continue.arrow")
											.resizable()
											.renderingMode(.template)
											.frame(width: 16, height: 16)
											.foregroundColor(.white)
									}
								}
								.offset(x: -32)
								.scrollTransition { content, phase in
									content
										.opacity(phase.isIdentity ? 0 : 1)
								}
								Spacer()
							}
						}
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        .id(task)
                    } else {
                        ReadyRow(sail: sail, task: task, selectedTask: $selectedTask)
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                            .id(task)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, 40.0, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $pagedTask)
    }
}
