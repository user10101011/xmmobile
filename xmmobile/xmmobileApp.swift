//
//  xmmobileApp.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 24/10/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct xmmobileApp: App {
    static let store = Store(initialState: SurveyStartReducer.State()) {
        SurveyStartReducer()
    }
    
    var body: some Scene {
        WindowGroup {
            SurveyStartView(store: xmmobileApp.store)
        }
    }
}
