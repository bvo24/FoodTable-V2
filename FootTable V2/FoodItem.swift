//
//  FoodItem.swift
//  FoodTable
//
//  Created by Brian Vo on 5/27/24.
//

import Foundation

struct FoodItem : Identifiable, Codable, Hashable{
    
    static let measurementUnits = [
            "g", "kg", "oz", "lbs", "ml", "l", "cups", "tsp", "tbsp", "fl oz"
        ]
    
    static let stockLevel = [ "Low", "Medium", "High"]
    
    //Not sure if UUID() is ideal?... What if I update this item would it get affected?..
    var id : UUID
    var name : String
    var calories : String
    
    var servingSize : String
    //In our crafting menu we should see this type when creating/adding to recipe
    var servingType : String
    
    var protein : String
    var stock : String
    
    static let examples: [FoodItem] = [
            FoodItem(id: UUID(), name: "Apple", calories: "95", servingSize: "1", servingType: "grams", protein: "1", stock: "low"),
            FoodItem(id: UUID(), name: "Banana", calories: "105", servingSize: "1", servingType: "grams", protein: "1", stock: "medium"),
            FoodItem(id: UUID(), name: "Chicken Breast", calories: "165", servingSize: "100", servingType: "grams", protein: "31", stock: "high")
        ]
    
    
    var hasValidItem : Bool{
        
        // Check if empty field
            if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false // Name is required and cannot be empty
            }
            
            // Chekc if number is inputted
            guard let caloriesValue = Double(calories.trimmingCharacters(in: .whitespacesAndNewlines)),
                  let servingSizeValue = Int(servingSize.trimmingCharacters(in: .whitespacesAndNewlines)),
                  let proteinValue = Int(protein.trimmingCharacters(in: .whitespacesAndNewlines)) else {
                return false // Invalid numeric input
            }
            
            // Make sure it's not negative
            if caloriesValue <= 0 || servingSizeValue <= 0 || proteinValue <= 0 {
                return false
            }
            
            return true
        
        
        
        
    }
    
    
    
    
}

