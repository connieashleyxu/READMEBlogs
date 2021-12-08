//
//  HapticsManager.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 12/1/21.
//

import Foundation
import UIKit

class HapticsManager {
    static let shared = HapticsManager()

    private init() {}

    //haptic touch feat for select
    func vibrateForSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    //func for vibrate haptic touch
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
