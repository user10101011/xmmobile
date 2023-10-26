//
//  SurveyStartView.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 24/10/23.
//

import ComposableArchitecture
import SwiftUI

struct SurveyStartView: View {
    let store: StoreOf<SurveyStartReducer>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            VStack {
                WithViewStore(self.store, observe: { $0 }) { viewStore in
                    HStack {
                        NavigationLink(state: QuestionReducer.State(questions: viewStore.questions)) {
                            Text("Start Survey")
                                .font(.system(size: 26, weight: .light))
                            Image(systemName: "questionmark.bubble")
                                
                        }
                        .foregroundColor(.black)
                    }.onAppear {
                        viewStore.send(.startSurveyButtonDidTap)
                    }

                    if viewStore.isLoading {
                        ProgressView()
                    } else if !viewStore.questions.isEmpty {
                        Text("We got survey materials!")
                    } else {
                        Text("Oops! There are no questions for survey :(")
                        Button {
                            viewStore.send(.startSurveyButtonDidTap)
                        } label: {
                            HStack {
                                Image(systemName: "bolt.horizontal.circle")
                                Text("Reaload questions")
                            }.foregroundColor(.black)
                        }
                    }
                }
            }
        } destination: { store in
            QuestionView(store: store)
        }
    }
}

struct SurveyStartPreview: PreviewProvider {
    static var previews: some View {
        SurveyStartView(store: Store(initialState: SurveyStartReducer.State()) {
            SurveyStartReducer()
        })
    }
}
