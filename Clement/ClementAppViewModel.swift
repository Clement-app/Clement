//
//  ClementAppViewModel.swift
//  Clement
//
//  Created by Alex Catchpole on 23/09/2024.
//

import SwiftUI

extension ClementApp {
    @Observable
    class ViewModel {
        func setOnboardingComplete() {
            UserDefaults.standard.set(true, forKey: Constants.HAS_ONBOARDED)
        }
    }
}
