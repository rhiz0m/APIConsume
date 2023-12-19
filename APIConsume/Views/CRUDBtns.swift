//
//  CrudField.swift
//  APIConsume
//
//  Created by Andreas Antonsson on 2023-12-19.
//

import SwiftUI

struct CRUDBtns: View {
    @ObservedObject var viewModel: OTStrongViewModel
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.fetchData(endpoint: EndPoints().otStrongMan)
            }, label: {
                Text("Get")
            })
            Button(action: {
                viewModel.createApi {}
            }, label: {
                Text("Post")
            })
            Button(action: {
                viewModel.updateApi()
            }, label: {
                Text("Update")
            })
            Button(action: {
                viewModel.deleteApi{}
            }, label: {
                Text("Delete")
            })

        }
    }
}

#Preview {
    CRUDBtns(viewModel: OTStrongViewModel())
}
