import Foundation

class OTStrongViewModel: ObservableObject {
    
    @Published var title: String?
    @Published var muscleGroups: [String]?
    @Published var equipment: [String]?
    @Published var exercises: [OTStrong.Exercises] = []
    
    private let semaphore = DispatchSemaphore(value: 1)
    @Published var rateLimitStatus: String?
    @Published var status: String?
    
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
                    DispatchQueue.main.async {
                        
                        self.status = "HTTP Status Code: \(httpResponse.statusCode) . GET-ing/Fetching the data! \n"
                        print("HTTP Status Code: \(httpResponse.statusCode) . GET-ing/Fetching the data! \n")
                        
                        if httpResponse.statusCode == 429 {
                            
                            self.rateLimitStatus = "Rate limit exceeded. Try again later."
                            self.status = nil
                            self.semaphore.wait()
                            return
                        }
                        self.semaphore.signal()
                        self.status = "HTTP Status Code: \(httpResponse.statusCode) . GET-ing/Fetching the data! \n"
                        
                        if let data = data {
                            if let decodedResponse = try? JSONDecoder().decode(OTStrong.self, from: data) {
                                
                                self.title = decodedResponse.title
                                self.muscleGroups = decodedResponse.muscleGroups
                                self.equipment = decodedResponse.equipment
                                
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
    
    func createApi(completion: @escaping () -> Void) {
        guard let baseURL = URL(string: "http://localhost:3000"),
              let name = title,
              let date = muscleGroups,
              let description = equipment else {
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
            title: title,
            muscleGroups: muscleGroups,
            equipment: equipment,
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
                DispatchQueue.main.async {
                    print("HTTP Status Code: \(httpResponse.statusCode) . POST-ing the data! \n")
                    self.status = "HTTP Status Code: \(httpResponse.statusCode) . POST-ing the data! \n"
                    
                    if let data = data {
                        if let resultString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(resultString) \n")
                        }
                    }
                    
                    if httpResponse.statusCode == 201 {
                        completion()
                    }
                }
            }
        }.resume()
    }
    
    func updateApi() {
        guard let baseURL = URL(string: "http://localhost:3000"),
              let name = title else {
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
            title: title,
            muscleGroups: muscleGroups,
            equipment: equipment,
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
                DispatchQueue.main.async {
                    print("HTTP Status Code: \(httpResponse.statusCode). PUT. Updating the data! \n")
                    self.status = "HTTP Status Code: \(httpResponse.statusCode). PUT. Updating the data! \n"
                    
                    if let data = data {
                        if let resultString = String(data: data, encoding: .utf8) {
                            print("\(resultString) \n")
                        }
                    }
                }
            }
        }.resume()
    }
    
    func deleteApi(completion: @escaping () -> Void) {
        guard let baseURL = URL(string: "http://localhost:3000"),
              let name = title else {
            return
        }
        
        let deleteURL = baseURL.appendingPathComponent("/oldtimestrong/\(name)")
        
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    print("HTTP Status Code: \(httpResponse.statusCode) . The data was DELETED. \n")
                    self.status = "HTTP Status Code: \(httpResponse.statusCode) . The data was DELETED. \n"
                    
                    if httpResponse.statusCode == 204 {
                        
                        self.title = nil
                        self.muscleGroups = nil
                        self.equipment = nil
                        self.exercises = []
                        
                        completion()
                    }
                }
            }
        }.resume()
    }
    
    struct OTStrong: Decodable {
        let title: String
        let muscleGroups: [String]
        let equipment: [String]
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
        let title: String?
        let muscleGroups: [String]?
        let equipment: [String]?
        let exercises: [ExerciseUpdate]
        
        struct ExerciseUpdate: Encodable {
            let name: String
            let weight: [Int]
            let reps: [Int]
            let sets: [Int]
        }
    }
    
}
