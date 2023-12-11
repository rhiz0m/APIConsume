//
//  ContentView.swift
//  APIConsume
//
//  Created by Andreas Antonsson on 2023-12-11.
//

import SwiftUI

struct ContentView: View {
    @State private var apiResponse: String = "Loading..."
    private let baseURL = "http://localhost:3000/"
    private let testEndpoint = "test"
    
    var body: some View {
        Text(apiResponse)
            .onAppear {
                fetchData()
            }
    }

    func fetchData() {
        
        // Make a GET request to Express API
        if let url = URL(string: baseURL+testEndpoint) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let apiResponse = String(data: data, encoding: .utf8) {
                        // Update the UI on the main thread
                        DispatchQueue.main.async {
                            self.apiResponse = apiResponse
                        }
                    }
                }
            }.resume()
        }
    }
}

#Preview {
    ContentView()
}
