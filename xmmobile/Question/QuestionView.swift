//
//  QuestionView.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 24/10/23.
//

import ComposableArchitecture
import SwiftUI

struct QuestionView: View {
    let store: StoreOf<QuestionReducer>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("Question \(viewStore.elementCounter) of \(viewStore.questions.count)")
                
                HStack {
                    Button {
                        viewStore.send(.backButtonDidTap)
                        viewStore.send(.setAnswerInput(""))
                    } label: {
                        Image(systemName: "chevron.left")
                    }.disabled(viewStore.elementCounter - 1 == 0)
                    
                    if !viewStore.questions.isEmpty {
                        Text("\(viewStore.questions[viewStore.elementCounter - 1].question)")
                    } else {
                        Text("There is no question available :(")
                    }
                    
                    Button {
                        viewStore.send(.nextButtonDidTap)
                        viewStore.send(.setAnswerInput(""))
                    } label: {
                        Image(systemName: "chevron.right")
                    }.disabled(viewStore.elementCounter == viewStore.questions.count)
                }
                
                TextField("Type your answer here", text: viewStore.binding(get: \.answerInput, send: { .setAnswerInput($0) }))
                    .padding([.leading, .trailing], 78)
                    .disabled(viewStore.submissionStatus[viewStore.elementCounter] ?? false)
                
                Button {
                    let answer = Answer(id: viewStore.elementCounter, answer: viewStore.answerInput)
                    viewStore.send(.submitButtonDidTap(answer))
                    viewStore.send(.setAnswerInput(""))
                } label: {
                    Text(viewStore.submissionStatus[viewStore.elementCounter] ?? false ? "Alredy submitted" : "Submit")
                }
                .disabled(viewStore.isSubmitButtonDisabled).padding(.bottom)
                
                if let isValidSubmission = viewStore.submissionStatus[viewStore.elementCounter] {
                    Text(isValidSubmission ? "Success" : "Failure")
                        .foregroundColor(isValidSubmission ? .green : .red)
                }
                
                Text("Questions submitted: \(viewStore.successfulSubmisionsCount)")
            }
        }
    }
}

struct QuestionPreview: PreviewProvider {
    static var previews: some View {
        QuestionView(store: Store(initialState: QuestionReducer.State()) {
            QuestionReducer()
        })
    }
}
