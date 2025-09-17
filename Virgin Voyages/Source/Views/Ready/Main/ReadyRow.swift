//
//  ReadyRow.swift
//  Virgin Voyages
//
//  Created by Chris DeSalvo on 4/23/24.
//

import SwiftUI
import VVUIKit

struct ReadyRow: View {
	var sail: ReadyToSail
	var task: SailTask
	@Binding var selectedTask: SailTask?
	
	var body: some View {
		let rts = sail.task(task)
		ReadyLayoutView {
			Button {
				selectedTask = task
			} label: {
				ZStack {
					FlexibleProgressImage(url: URL(string: rts.imageURL), heightRatio: 1.0, backgroundColor: Color(hex: rts.backgroundColorCode))
					
					if let text = rts.failedStateText, let colorCode = rts.failedStateTextColorCode {
						Circle()
							.foregroundStyle(.black.opacity(0.7))
							.padding(10)
						
						Text(text)
							.multilineTextAlignment(.center)
							.fontStyle(.headline)
							.foregroundStyle(Color(hex: colorCode))
							.padding(40)
					}
				}
			}
			.scrollTransition { content, phase in
				content
					.offset(x: phase.isIdentity ? 0 : phase.value * -80)
			}
			.mask {
				Circle()
					.padding(12)
			}
			.overlay {
				ZStack {
					Circle()
						.strokeBorder(style: .init(lineWidth: 4))
						.foregroundStyle(.white)
						.opacity(0.5)
					
					ProgressArc(percent: sail.taskPercentCompletion(task))
						.strokeBorder(style: .init(lineWidth: 4))
						.foregroundStyle(.white)
				}
				.scrollTransition { content, phase in
					content
						.opacity(phase.isIdentity ? 1 : 0)
				}
				
				Circle()
					.strokeBorder(style: .init(lineWidth: 4))
					.foregroundStyle(.white)
					.padding(10)
			}
		} header: {
			HStack {
				Text("\(sail.indexOf(task: task))")
				Rectangle()
					.frame(width: 40, height: 2)
				Text("\(sail.tasksOrder.count)")
			}
			.fontStyle(.headline)
			.foregroundStyle(.white)
			.scrollTransition { content, phase in
				content
					.opacity(phase.isIdentity ? 1 : 0)
			}
		} footer: {
			Button {
				selectedTask = task
			} label: {
				VStack(spacing: 25) {
					Text(rts.title)
						.fontStyle(.largeTitle)
					
					Text(rts.caption)
						.textCase(.uppercase)
						.fontStyle(.button)
				}
				.tint(.white)
			}
			.scrollTransition { content, phase in
				content
					.opacity(phase.isIdentity ? 1 : 0)
			}
		}
	}
}
