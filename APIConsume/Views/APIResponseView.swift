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
        TextField(apiResponse, text: Binding(
            get: { viewModel.name ?? "" },
            set: { viewModel.name = $0 }
        ))
        .foregroundColor(Color.gray)
        .font(.headline)
        .padding(4)
        .background(Color.gray.opacity(0.2))
        Text("Date: \(viewModel.date ?? "")").padding(.vertical, 2)
        Text("Description: \(viewModel.description ?? "")")
            .padding(.vertical, 2)
        
        ForEach(viewModel.exercises) { exercise in
            Text("Exercise: \(exercise.name)").bold()
            Text("Weights: \(exercise.weight.map(String.init).joined(separator: ", "))")
            Text("Reps: \(exercise.reps.map(String.init).joined(separator: ", "))")
            Text("Sets: \(exercise.sets.map(String.init).joined(separator: ", "))")
        }.font(.caption).padding(.vertical, 1)
            .onAppear {
                viewModel.fetchData(endpoint: EndPoints().otStrongMan)
            }
    }
}




#Preview {
    APIResponseView(viewModel: OTStrongViewModel())
}
