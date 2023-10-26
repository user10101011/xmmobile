//
//  SubmissionClient.swift
//  xmmobile
//
//  Created by Alexander Bakhmut on 25/10/23.
//

import Foundation
import ComposableArchitecture

struct SubmissionClient {
    var post: ((Int, String)) async throws -> Int
}

extension SubmissionClient: DependencyKey {
    static let liveValue: SubmissionClient = Self(post: { payload in
        let stringUrl = "https://xm-assignment.web.app/question/submit"
        if let url = URL(string: stringUrl) {
            let json: [String: Any] = ["id" : payload.0, "answer" : payload.1]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = jsonData
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpResponse = response as? HTTPURLResponse {
                    return httpResponse.statusCode
                } else {
                    print("Wow! Unexpected response casting error has occurred!")
                }
            } catch {
                print("Oops! An error has occurred during POST request: \(error.localizedDescription)")
            }
        } else {
            print("Unable create initiate from string: \(stringUrl)")
        }
        
        return 400
    })
}

extension DependencyValues {
    var submissionClient: SubmissionClient {
        get {
            self[SubmissionClient.self]
        }
        set {
            self[SubmissionClient.self] = newValue
        }
    }
}
