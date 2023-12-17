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
            Text("Name: \(viewModel.name ?? "")").bold()
            Text("Date: \(viewModel.date ?? "")")
            Text("Description: \(viewModel.description ?? "")")
            
            ForEach(viewModel.exercises) { exercise in
                Text("Exercise: \(exercise.name)").bold()
                Text("Weights: \(exercise.weight.map(String.init).joined(separator: ", "))")
                Text("Reps: \(exercise.reps.map(String.init).joined(separator: ", "))")
                Text("Sets: \(exercise.sets.map(String.init).joined(separator: ", "))")
            }.font(.caption)

        }
        .onAppear {
                viewModel.fetchData()
            }
    }
}

#Preview {
    ContentView()
}
