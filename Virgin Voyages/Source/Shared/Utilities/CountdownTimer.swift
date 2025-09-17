//
//  CountdownTimer.swift
//  Virgin Voyages
//
//  Created by Enxhi Kondakciu on 10.4.25.
//

import Foundation
import Combine

import Foundation
import Combine

class CountdownTimer: ObservableObject {
    @Published var countdownText: String = ""
    
    private var timer: Timer?
    private var secondsLeft: Int?

    func startCountdown(secondsLeft: Int) {

        self.secondsLeft = secondsLeft
        updateCountdown()

        invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    private func tick() {
        guard var secondsLeft = self.secondsLeft else { return }

        secondsLeft -= 1
        self.secondsLeft = secondsLeft
        updateCountdown()
    }

    private func updateCountdown() {
        guard let secondsLeft else { return }

        if secondsLeft <= 0 {
            countdownText = ""
            invalidate()
            return
        }

        let days = secondsLeft / 86400
        let hours = (secondsLeft % 86400) / 3600
        let minutes = (secondsLeft % 3600) / 60

        var result = ""
        if days > 0 {
            result += "\(days)d "
        }
        if hours > 0 || days > 0 {
            result += "\(hours)h "
        }
        result += "\(minutes)m"

        DispatchQueue.main.async {
            self.countdownText = result
        }
    }

    func invalidate() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        invalidate()
    }
}
