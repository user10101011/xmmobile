//
//  xmmobileTests.swift
//  xmmobileTests
//
//  Created by Alexander Bakhmut on 25/10/23.
//

import XCTest
import ComposableArchitecture

@testable import xmmobile

@MainActor
final class _1_xmmobileTests: XCTestCase {
    func testGetSurveyRequest() async {
        let store = TestStore(initialState: SurveyStartReducer.State()) {
            SurveyStartReducer()
        } withDependencies: {
            $0.surveyClient.get = {
                [Question(id: 0, question: "Why?")]
            }
        }
        
        await store.send(.startSurveyButtonDidTap) {
            $0.isLoading = true
        }
        
        await store.receive(.surveyResponse([Question(id: 0, question: "Why?")])) {
            $0.isLoading = false
            $0.questions = [Question(id: 0, question: "Why?")]
        }
    }
    
    
}
