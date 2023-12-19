import Foundation

class OTStrongViewModel: ObservableObject {
    
    @Published var name: String?
    @Published var date: String?
    @Published var description: String?
    @Published var exercises: [OTStrong.Exercises] = []
    
    func fetchData(endpoint: String) {
        let baseURL = "http://localhost:3000"
        let fullURL = baseURL + endpoint
        
        if let url = URL(string: fullURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode) . GET-ing/Fetching the data! \n")
                    
                    if let data = data {
                        if let decodedResponse = try? JSONDecoder().decode(OTStrong.self, from: data) {
                            DispatchQueue.main.async {
                                self.name = decodedResponse.name
                                self.date = decodedResponse.date
                                self.description = decodedResponse.description
                                
                                // Generate unique identifiers for exercises
                                self.exercises = decodedResponse.exercises.enumerated().map { index, exercise in
                                    var mutableExercise = exercise
                                    mutableExercise.id = UUID()
                                    return mutableExercise
                                }
                            }
                        }
                    }
                }
            }.resume()
        }
    }

    struct OTStrong: Decodable {
        let name: String
        let date: String
        let description: String
        let exercises: [Exercises]
        
        struct Exercises: Identifiable, Decodable {
            var id: UUID?
            let name: String
            let weight: [Int]
            let reps: [Int]
            let sets: [Int]
        }
    }
    
    struct UpdateRequest: Encodable {
            let name: String?
            let date: String?
            let description: String?
            let exercises: [ExerciseUpdate]
            
            struct ExerciseUpdate: Encodable {
                let name: String
                let weight: [Int]
                let reps: [Int]
                let sets: [Int]
            }
        }
    
    func createApi(completion: @escaping () -> Void) {
        guard let baseURL = URL(string: "http://localhost:3000"),
              let name = name,
              let date = date,
              let description = description else {
            return
        }
        
        let createURL = baseURL.appendingPathComponent("/oldtimestrong")
        
        let exerciseUpdates: [UpdateRequest.ExerciseUpdate] = exercises.map {
            UpdateRequest.ExerciseUpdate(
                name: $0.name,
                weight: $0.weight,
                reps: $0.reps,
                sets: $0.sets
            )
        }
        
        let createRequest = UpdateRequest(
            name: name,
            date: date,
            description: description,
            exercises: exerciseUpdates
        )
        
        guard let createData = try? JSONEncoder().encode(createRequest) else {
            return
        }
        
        var request = URLRequest(url: createURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = createData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode) . POST-ing the data! \n")
                
                if let data = data {
                    if let resultString = String(data: data, encoding: .utf8) {
                        print("Response Data: \(resultString) \n")
                    }
                }
                
                // Assuming successful creation, refresh the data in ContentView
                if httpResponse.statusCode == 201 {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        }.resume()
    }
        
    func updateApi() {
        guard let baseURL = URL(string: "http://localhost:3000"),
              let name = name else {
            return
        }
        
        let updateURL = baseURL.appendingPathComponent("/oldtimestrong/\(name)")
        
        let exerciseUpdates: [UpdateRequest.ExerciseUpdate] = exercises.map {
            UpdateRequest.ExerciseUpdate(
                name: $0.name,
                weight: $0.weight,
                reps: $0.reps,
                sets: $0.sets
            )
        }
        
        let updateRequest = UpdateRequest(
            name: name,
            date: date,
            description: description,
            exercises: exerciseUpdates
        )
        
        guard let updatedOldTimeStrongData = try? JSONEncoder().encode(updateRequest) else {
            return
        }
        
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = updatedOldTimeStrongData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode). PUT. Updating the data! \n")
                if let data = data {
                    if let resultString = String(data: data, encoding: .utf8) {
                        print("\(resultString) \n")
                    }
                }
            }
        }.resume()
    }
    
    func deleteApi(completion: @escaping () -> Void) {
        guard let baseURL = URL(string: "http://localhost:3000"),
              let name = name else {
            return
        }
        
        let deleteURL = baseURL.appendingPathComponent("/oldtimestrong/\(name)")
        
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode) . The data was DELETED. \n")
                
                // Assuming successful deletion, refresh the data in ContentView
                if httpResponse.statusCode == 204 {
                    DispatchQueue.main.async {
                        // Clear the data in ContentView or trigger a data refresh
                        self.name = nil
                        self.date = nil
                        self.description = nil
                        self.exercises = []
                        
                        // Notify ContentView to update
                        completion()
                    }
                }
            }
        }.resume()
    }


}
