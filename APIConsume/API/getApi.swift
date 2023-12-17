//
//  getApi.swift
//  APIConsume
//
//  Created by Andreas Antonsson on 2023-12-17.
//

import Foundation

class OldTimeStrongViewModel: ObservableObject {
    
    @Published var name: String?
    @Published var reps: Int?
    @Published var sets: Int?
    @Published var exercises: [String] = []
    
    func fetchData() {
        let baseURL = "http://localhost:3000"
        let oldTimeStrongEndpoint = "/oldtimestrong"
        
        // Making a GET request to Express API
        if let url = URL(string: baseURL + oldTimeStrongEndpoint) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(OldTimeStrong.self, from: data) {
                        DispatchQueue.main.async {
                            self.name = decodedResponse.name
                            self.reps = decodedResponse.reps
                            self.sets = decodedResponse.sets
                            self.exercises = decodedResponse.exercises
                            
                
                        }
                    }
                }
            }.resume()
        }
    }
    
    struct OldTimeStrong: Decodable {
        let name: String
        let reps: Int
        let sets: Int
        let exercises: [String]
        
    /*    struct Exercises: Decodable {
        let exercise: String
        } */
    }
}
