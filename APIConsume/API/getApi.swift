import Foundation

class OldTimeStrongViewModel: ObservableObject {
    
    @Published var name: String?
    @Published var date: String?
    @Published var description: String?
    @Published var exercises: [OldTimeStrong.Exercises] = []
    
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
            }.resume()
        }
    }
    
    struct OldTimeStrong: Decodable {
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
}
