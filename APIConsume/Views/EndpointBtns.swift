//
//  EndpointBtns.swift
//  APIConsume
//
//  Created by Andreas Antonsson on 2023-12-19.
//

import SwiftUI

struct EndpointBtns: View {
    @ObservedObject var viewModel: OTStrongViewModel
    @State private var apiResponse: String = "Loading..."
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.fetchData(endpoint: EndPoints().otStrongMan)
            }, label: {
                Text("O.T.S.M")
            })
            Button(action: {
                viewModel.fetchData(endpoint: EndPoints().gripStrength)
            }, label: {
                Text("Grip")
            })
            Button(action: {
                viewModel.fetchData(endpoint: EndPoints().stoneStrength)
            }, label: {
                Text("Stones")
            })
            Button(action: {
                viewModel.fetchData(endpoint: EndPoints().armWrestling)
            }, label: {
                Text("ArmWrestling")
            })

        }.padding(.vertical, 4)
    }
}

#Preview {
    EndpointBtns(viewModel: OTStrongViewModel())
}
