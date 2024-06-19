//
//  ContentView.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/28/24.
//
// looking good converter looks like it's working fine slightly off but it's pretty good
//Maybe add an api?.. or like a search feature?... not sure...
//Definetly add a calorie / protein calculator X
//Now to add like an ingredient list kinda thing.. so maybe we add a bool that's true or false. Or just add the stock option to be defaulted to na and then if it's not then we can X
//Maybe have an add to inventory bool then if we have that we can select the stock and if it's not selected then it's going to be n/a X
//This also makes me think about having to create a search item?..... it's just i'm not too sure what to do about the stock, because I want a tab of things that are low but also you should be able to search from your own inventory... Idk yet this is a WIP... Not soo sure if I want to search our inventory, i have a lot of filters


//Rename views
//Crafting view this is questionable.
//Maybe a ration view?.. you can copy / paste something but



import SwiftUI

struct ContentView: View {
    @StateObject private var dayManager = DayManager()
    @StateObject private var inventoryManager = InventoryManager()
    @State private var selectedTab: Tab = .buffLog

    enum Tab {
        case buffLog
        case inventory
    }

    var body: some View {
        
        
        TabView(selection: $selectedTab) {
            
            BuffLogView(dayManager: dayManager)
            .tabItem {
                Label {
                    Text("Journal")
                        
                } icon: {
                    Image("pixeljournal")
                }
                    
                    
            }
            .tag(Tab.buffLog)
            .font(Font.custom("PixelifySans-Regular", size: 16))

            
            InventoryView(inventoryManager: inventoryManager)
            .tabItem {
                Label("Inventory", image: "pixelbag")
            }
            .tag(Tab.inventory)
            .font(Font.custom("PixelifySans-Regular", size: 16))
        }
        
    }
}
