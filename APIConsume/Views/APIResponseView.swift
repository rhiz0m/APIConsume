//
//  APIResponseView.swift
//  APIConsume
//
//  Created by Andreas Antonsson on 2023-12-19.
//

import SwiftUI

struct APIResponseView: View {
    @ObservedObject var viewModel: OTStrongViewModel
    @State private var apiResponse: String = "Loading..."
    
    var body: some View {
        Text("HTTP Status Code: \(viewModel.status ?? "429")")
            .font(.caption)
            .foregroundStyle(.brown)
            .padding(.vertical, 2)
        Text(viewModel.rateLimitStatus ?? "HTTP Status ok!").font(.caption).foregroundStyle(.green)
        
        TextField(apiResponse, text: Binding(
            get: { viewModel.title ?? "" },
            set: { viewModel.title = $0 }
        ))
        .foregroundColor(Color.gray)
        .font(.headline)
        .padding(4)
        .background(Color.gray.opacity(0.2))
        
        TextField(apiResponse, text: Binding(
            get: { viewModel.muscleGroups?.joined(separator: ", ") ?? "" },
            set: { newValue in
                viewModel.muscleGroups = newValue.split(separator: ", ").map(String.init)
            }
        ))
        .foregroundColor(Color.gray)
        .font(.headline)
        .padding(4)
        .background(Color.gray.opacity(0.2))
        
        TextField(apiResponse, text: Binding(
            get: { viewModel.equipment?.joined(separator: ", ") ?? "" },
            set: { newValue in
                viewModel.equipment = newValue.split(separator: ", ").map(String.init)
            }
        ))
        .foregroundColor(Color.gray)
        .font(.headline)
        .padding(4)
        .background(Color.gray.opacity(0.2))
        
        ForEach(viewModel.exercises) { exercise in
            Text("Exercise: \(exercise.name)").bold()
            Text("Weights: \(exercise.weight.map(String.init).joined(separator: ", "))")
            Text("Reps: \(exercise.reps.map(String.init).joined(separator: ", "))")
            Text("Sets: \(exercise.sets.map(String.init).joined(separator: ", "))")
           
        }
        .font(.caption)
        .padding(.vertical, 1)
            .onAppear {
                viewModel.fetchData(endpoint: EndPoints().otStrongMan)
            }
    }
}




#Preview {
    APIResponseView(viewModel: OTStrongViewModel())
}
