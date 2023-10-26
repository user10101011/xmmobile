//
//  NetworkServise.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 25/10/23.
//

import Foundation
import ComposableArchitecture

struct SurveyClient {
    var get: () async throws -> [Question]
}

extension SurveyClient: DependencyKey {
    static let liveValue: SurveyClient = Self(get: {
        do {
            let stringUrl = "https://xm-assignment.web.app/questions"
            if let url = URL(string: stringUrl) {
                let (data, _) = try await URLSession.shared.data(from: url)
                let questions = try JSONDecoder().decode([Question].self, from: data)
                return questions
            } else {
                print("Unable create initiate from string: \(stringUrl)")
            }
        } catch {
            print("Oops! An error has occurred during GET request: \(error.localizedDescription)")
        }
        
        return []
    })
}

extension DependencyValues {
    var surveyClient: SurveyClient {
        get {
            self[SurveyClient.self]
        }
        set {
            self[SurveyClient.self] = newValue
        }
    }
}
