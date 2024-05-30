//
//  ContentView-ViewModel.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/30/24.
//

import Foundation

extension ContentView{
    @Observable
    class ViewModel : ObservableObject{
        private(set) var days : [Day]
        var selectedDay : Day?
        let savePath = URL.documentsDirectory.appending(path: "SavedDays")
        
        init(){
            do{
                let data = try Data(contentsOf: savePath)
                days =  try JSONDecoder().decode([Day].self, from: data)
                
                
            }catch{
                days = []
            }
            
        }
        
        func save(){
            do{
                let data = try JSONEncoder().encode(days)
                try data.write(to:savePath, options: [.atomic, .completeFileProtection])
                
            }catch{
                print("Unable to save data")
            }
            
            
        }
        
        
        func addDay( day : Day, b : [FoodItem], l : [FoodItem], d : [FoodItem]){
            let day = Day(date: Date(), breakfast: b, lunch: l, dinner: d)
            days.append(day)
            save()
            
        }
        
        func update( day : Day){
            
            guard let selectedDay else {return}
            if let index = days.firstIndex(of: selectedDay){
                days[index] = day
                save()
            }
            
            
        }
        
        
    }
    
    
}
