//
//  ContentView.swift
//  APIConsume
//
//  Created by Andreas Antonsson on 2023-12-11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = OldTimeStrongViewModel()
    @State private var apiResponse: String = "Loading..."

    var body: some View {
        VStack(alignment: .leading) {
            Text("Name: \(viewModel.name ?? "")")
            Text("Reps: \(viewModel.reps ?? 0)")
            Text("Sets: \(viewModel.sets ?? 0)")
            Text("Exercises: \(viewModel.exercises.joined(separator: ", "))")
        }
        .onAppear {
                viewModel.fetchData()
            }
    }
}

#Preview {
    ContentView()
}
