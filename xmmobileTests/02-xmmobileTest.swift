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
    func testPostSubmissionFailedRequest() async {
        let store = TestStore(initialState: QuestionReducer.State()) {
            QuestionReducer()
        } withDependencies: {
            $0.submissionClient.post = { statusCode in
                400
            }
        }
        
        await store.send(.submitButtonDidTap(Answer(id: 1, answer: "Green"))) {
            $0.isLoading = true
        }
        
        await store.receive(.submissionResponse(400)) {
            $0.isLoading = false
            $0.successfulSubmisionsCount = 0
            $0.submissionStatus = [1: false]
        }
    }
    
    func testPostSubmissionSucceedRequest() async {
        let store = TestStore(initialState: QuestionReducer.State()) {
            QuestionReducer()
        } withDependencies: {
            $0.submissionClient.post = { statusCode in
                200
            }
        }
        
        await store.send(.submitButtonDidTap(Answer(id: 1, answer: "Grey"))) {
            $0.isLoading = true
        }
        
        await store.receive(.submissionResponse(200)) {
            $0.isLoading = false
            $0.successfulSubmisionsCount = 1
            $0.submissionStatus = [1: true]
        }
    }
}
