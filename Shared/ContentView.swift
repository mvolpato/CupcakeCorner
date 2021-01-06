//
//  ContentView.swift
//  Shared
//
//  Created by Michele Volpato on 03/01/2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store = Store()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $store.order.type) {
                        ForEach(0..<Order.types.count) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper(value: $store.order.quantity, in: 3...20) {
                        Text("Number of cakes: \(store.order.quantity)")
                    }
                }
                Section {
                    Toggle(isOn: $store.order.specialRequestEnabled.animation()) {
                        Text("Any special requests?")
                    }

                    if store.order.specialRequestEnabled {
                        Toggle(isOn: $store.order.extraFrosting) {
                            Text("Add extra frosting")
                        }

                        Toggle(isOn: $store.order.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: AddressView(store: store)) {
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
