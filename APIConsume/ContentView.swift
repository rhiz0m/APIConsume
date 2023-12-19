//
//  ContentView.swift
//  APIConsume
//
//  Created by Andreas Antonsson on 2023-12-11.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = OTStrongViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            CRUDBtns(viewModel: viewModel)
            APIResponseView(viewModel: viewModel)            
            EndpointBtns(viewModel: viewModel)
        }.padding()
        .onAppear {
            viewModel.fetchData(endpoint: EndPoints().otStrongMan)
            }
    }
}

#Preview {
    ContentView()
}
