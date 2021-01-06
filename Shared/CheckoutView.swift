//  CheckoutView
//  CupcakeCorner
//
//  Created by Michele Volpato on 03/01/2021.
//  
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)

                    Text("Your total is $\(self.order.cost, specifier: "%.2f")")
                        .font(.title)

                    Button("Place Order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var showingAlert = false
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            alertTitle = "Error"
            alertMessage = "Cannot prepare order."
            showingAlert = true
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription).")
                self.alertTitle = "Error"
                self.alertMessage = "Unknown error."
                self.showingAlert = true
                return
            }
            
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.alertTitle = "Error"
                self.alertMessage = "Cannot receive confirmation, contact the store."
                self.showingAlert = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.alertTitle = "Thank you!"
                self.alertMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingAlert = true
            } else {
                print("Invalid response from server")
                self.alertTitle = "Error"
                self.alertMessage = "Invalid response."
                self.showingAlert = true
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
