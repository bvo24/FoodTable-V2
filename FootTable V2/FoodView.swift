//
//  FoodView.swift
//  FoodTable
//
//  Created by Brian Vo on 5/28/24.
//

import SwiftUI

struct FoodView: View {
    
    @Environment(\.dismiss) var dismiss
    var day : Day
    
    var body: some View {
        NavigationStack{
            Form{
                
                Section("Breakfast"){
                    ForEach(day.breakfast){ food in
                        
                    }
                    
                    
                }
                Section("Lunch"){
                    ForEach(day.lunch){ food in
                        
                    }
                    
                    
                    
                }
                Section("Dinner"){
                    ForEach(day.dinner){ food in
                        
                    }
                    
                    
                    
                }
                
                
                
            }
            
            
        }
    }
}

#Preview {
    FoodView(day: .example)
}

