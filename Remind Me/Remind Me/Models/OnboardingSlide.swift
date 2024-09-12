//
//  OnboardingSlide.swift
//  Remind Me
//
//  Created by huy.dang on 9/12/24.
//

import Foundation
import UIKit

struct OnboardingSlide {
    let title: String
    let subtitle: String
    let image: UIImage
    
    static func setupIntroSlide() -> [OnboardingSlide] {
        var slides: [OnboardingSlide] = [OnboardingSlide]()
        slides.append(contentsOf: [OnboardingSlide(title: "Manage your tasks", subtitle: "You can easily manage all of your daily tasks in Remind Me for free", image: UIImage(named: "onboard1")!),
                                   OnboardingSlide(title: "Create daily routine", subtitle: "In Remind Me you can create your personalized routine to stay productive", image: UIImage(named: "onboard2")!),
                                   OnboardingSlide(title: "Organize Your Tasks", subtitle: "You can organize your daily tasks by adding your tasks into separate categories", image: UIImage(named: "onboard3")!)])
        return slides
    }
}
