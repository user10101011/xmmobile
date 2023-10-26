//
//  02-xmmobileTest.swift
//  xmmobileTests
//
//  Created by Alexander Bakhmut on 26/10/23.
//

import XCTest
import ComposableArchitecture

@testable import xmmobile

@MainActor
final class _2_xmmobileTest: XCTestCase {
    func testPostSubmissionRequest() async {
        let store = TestStore(initialState: QuestionReducer.State()) {
            QuestionReducer()
        } withDependencies: {
            $0.submissionClient.post = {
                $0.id
            }
        }
        
        await store.send(.submitButtonDidTap(Answer(id: 1, answer: "Green"))) {
            $0.isLoading = true
        }
        
        await store.receive(.submissionResponse(1)) {
            $0.isLoading = false
            $0.submissionStatus = [1: false]
        }
    }
}
