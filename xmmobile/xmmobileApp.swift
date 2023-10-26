//
//  xmmobileApp.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 24/10/23.
//

import SwiftUI
import ComposableArchitecture
import XCTestDynamicOverlay

@main
struct xmmobileApp: App {
    static let store = Store(initialState: SurveyStartReducer.State()) {
        SurveyStartReducer()
    }
    
    var body: some Scene {
        WindowGroup {
            if !_XCTIsTesting {
                SurveyStartView(store: xmmobileApp.store)
            }
        }
    }
}
