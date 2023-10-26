//
//  SurveyStart.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 24/10/23.
//

import ComposableArchitecture
import Foundation

struct SurveyStartReducer: Reducer {
    struct State: Equatable {
        var isLoading = false
        var questions: Array<Question> = []
        var path = StackState<QuestionReducer.State>()
    }
    
    enum Action: Equatable {
        case startSurveyButtonDidTap
        case surveyResponse([Question])
        case path(StackAction<QuestionReducer.State, QuestionReducer.Action>)
    }
    
    @Dependency(\.surveyClient) var surveyClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startSurveyButtonDidTap:
                state.isLoading = true
                return .run { send in
                    try await send(.surveyResponse(self.surveyClient.get()))
                }
            case let .surveyResponse(questions):
                state.questions = questions
                state.isLoading = false
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: /Action.path) {
            QuestionReducer()
        }
    }
}
