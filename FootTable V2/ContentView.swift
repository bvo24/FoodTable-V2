//
//  ContentView.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/28/24.
//
// looking good converter looks like it's working fine slightly off but it's pretty good
//Maybe add an api?.. or like a search feature?... not sure...
//Definetly add a calorie / protein calculator



import SwiftUI

struct ContentView: View {
    
    @StateObject private var dayManager = DayManager()
    @State private var totalProtein = UserDefaults.standard.double(forKey: "totalProtein")
        var body: some View {
            TabView {
                // Other tabs...
                BuffLogView(dayManager: dayManager)
                    .tabItem { Label("Buff Log", systemImage: "shield") }
                // Other tabs...
            }
        }
        
    
}

#Preview {
    ContentView()
}
