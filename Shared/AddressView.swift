//  AddressView
//  CupcakeCorner
//
//  Created by Michele Volpato on 03/01/2021.
//  
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var store: Store

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $store.order.name)
                TextField("Street Address", text: $store.order.streetAddress)
                TextField("City", text: $store.order.city)
                TextField("Zip", text: $store.order.zip)
            }

            Section {
                NavigationLink(destination: CheckoutView(store: store)) {
                    Text("Check out")
                }
                .disabled(store.order.hasValidAddress == false)
            }
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(store: Store())
    }
}
