//
//  FoodItem.swift
//  FoodTable
//
//  Created by Brian Vo on 5/27/24.
//

import Foundation

struct FoodItem : Identifiable, Codable, Hashable{
    
    //Not sure if UUID() is ideal?... What if I update this item would it get affected?..
    var id : UUID
    var name : String
    var calories : Int
    
    var servingSize : Int
    //In our crafting menu we should see this type when creating/adding to recipe
    var servingType : String
    
    var protein : Int
    var stock : String
    
    static let examples: [FoodItem] = [
            FoodItem(id: UUID(), name: "Apple", calories: 95, servingSize: 1, servingType: "medium", protein: 1, stock: "low"),
            FoodItem(id: UUID(), name: "Banana", calories: 105, servingSize: 1, servingType: "medium", protein: 1, stock: "medium"),
            FoodItem(id: UUID(), name: "Chicken Breast", calories: 165, servingSize: 100, servingType: "grams", protein: 31, stock: "high")
        ]
    
    
    
    
}

