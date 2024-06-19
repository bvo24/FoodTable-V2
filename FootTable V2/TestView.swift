//
//  TestView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/19/24.
//

import SwiftUI

struct TestView: View {
    let candy = ["Chocolate", "Taffy", "Licorice"]
    
    var body: some View {
        
        List {
            Section("TEST"){
                ForEach(candy, id: \.self) { candy in
                    HStack {
                        Text(candy)
                        //.background(Color.red)
                        Spacer()
                    }
                    .background(Color.red) // Apply background to the entire row
                }
                .listRowBackground(Color.brown) // Apply background to list row
                Button("Hi"){
                    
                }
                .listRowBackground(Color.blue)
                
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(.brown)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


#Preview {
    TestView()
}
