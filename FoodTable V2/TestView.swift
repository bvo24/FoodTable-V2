//
//  TestView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/19/24.
//
//REMOVE

import SwiftUI

struct SimpleView: View {
    @State private var toggleState = false
    @State private var petCount = 0
    var body: some View {
        Button {
                    petCount += 1
                } label: {
                    Label("Pet the Dog", systemImage: "dog")
                }
                .symbolEffect(.bounce, value: petCount)
                .font(.largeTitle)
        
//        NavigationView {
//            NavigationStack {
//                VStack(spacing: 0) {
//                    Button(toggleState ? "Add" : "Search") {
//                        toggleState.toggle()
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: 50) // Adjust size as needed
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .onTapGesture {
//                        toggleState.toggle() // Toggle even if tapped outside the button area
//                    }
//                    .background(Color.clear) // Add transparent background around the button
//                    
//                    if toggleState {
//                        NavigationStack {
//                            List {
//                                Section(header: Text("Section 1")) {
//                                    Text("Item 1")
//                                    Text("Item 2")
//                                }
//                                .listRowBackground(Color.lightWood)
//                                
//                                Section(header: Text("Section 2")) {
//                                    Text("Item 3")
//                                    Text("Item 4")
//                                }
//                                .listRowBackground(Color.lightWood)
//                            }
//                            .scrollContentBackground(.hidden)
//                            .background(Color.darkWood)
//                        }
//                    } else {
//                        NavigationStack {
//                            Form {
//                                Section(header: Text("Name")) {
//                                    TextField("Food Name", text: .constant(""))
//                                }
//                                .listRowBackground(Color.lightWood)
//                                
//                                Section(header: Text("Details")) {
//                                    HStack {
//                                        TextField("Detail 1", text: .constant(""))
//                                        TextField("Detail 2", text: .constant(""))
//                                    }
//                                }
//                                .listRowBackground(Color.lightWood)
//                            }
//                            .scrollContentBackground(.hidden)
//                            .background(Color.darkWood)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Simple View")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        // Dismiss action
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Confirm") {
//                        // Confirm action
//                    }
//                }
//            }
//        }
    }
}

#Preview {
    SimpleView()
}

#Preview {
    SimpleView()
}


