//
//  QuestionReducer.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 24/10/23.
//

import ComposableArchitecture

struct QuestionReducer: Reducer {
    struct State: Equatable {
        var elementCounter: Int = 1
        var questions: Array<Question> = []
        var answerInput: String = ""
        var isSubmitButtonDisabled = true
        var isLoading = false
        var submissionStatus: [Int: Bool] = [:]
        var successfulSubmisionsCount: Int = 0
    }
    
    enum Action: Equatable {
        case nextButtonDidTap
        case backButtonDidTap
        case setAnswerInput(String)
        case submitButtonDidTap(Answer)
        case submissionResponse(Int)
    }
    
    @Dependency(\.submissionClient) var submissionClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .nextButtonDidTap:
                state.elementCounter += 1
                return .none
            case .backButtonDidTap:
                state.elementCounter -= 1
                return .none
            case let .setAnswerInput(input):
                state.answerInput = input
                state.isSubmitButtonDisabled = input.isEmpty
                return .none
            case let .submitButtonDidTap(answer):
                state.isLoading = true
                return .run { send in
                    try await send(.submissionResponse(self.submissionClient.post((answer))))
                }
            case let .submissionResponse(statusCode):
                state.isLoading = false
                if statusCode == 200 {
                    state.successfulSubmisionsCount += 1
                    state.submissionStatus.updateValue(true, forKey: state.elementCounter)
                } else {
                    state.submissionStatus.updateValue(false, forKey: state.elementCounter)
                }
                return .none
            }
        }
    }
}
