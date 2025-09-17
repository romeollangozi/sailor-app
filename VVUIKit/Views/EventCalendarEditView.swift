//
//  EventCalendarEditView.swift
//  VVUIKit
//
//  Created by Enxhi Kondakciu on 10.4.25.
//

import SwiftUI
import EventKit
import EventKitUI

public struct EventCalendarEditView: UIViewControllerRepresentable {
    public var title: String
    public var startDate: Date
    public var endDate: Date

    @Environment(\.presentationMode) var presentationMode

    public init(title: String, startDate: Date, endDate: Date) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents

        let controller = EKEventEditViewController()
        controller.event = event
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator

        return controller
    }

    public func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {}

    public class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventCalendarEditView

        public init(_ parent: EventCalendarEditView) {
            self.parent = parent
        }

        public func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
