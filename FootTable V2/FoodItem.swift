//
//  FoodItem.swift
//  FoodTable
//
//  Created by Brian Vo on 5/27/24.
//

import Foundation

struct FoodItem : Identifiable, Codable, Hashable {
    static let measurementUnits = [
        "g", "kg", "oz", "lbs", "ml", "l", "cups", "tsp", "tbsp", "fl oz", "piece(s)"
    ]
    
    static let stockLevel = [ "N/A", "Low", "Medium", "High"]
    
    var id : UUID
    var name : String
    var caloriesPerServing : String
    var servingSize : String
    var servingType : String
    var eatenServingType : String
    var amountEaten : String
    var proteinPerServing : String
    var stock : String
    
    var hasValidItem : Bool {
        // Check if empty field
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false // Name is required and cannot be empty
        }
        
        // Check if numeric inputs are valid
        guard let caloriesValue = Double(caloriesPerServing.trimmingCharacters(in: .whitespacesAndNewlines)),
              let servingSizeValue = Double(servingSize.trimmingCharacters(in: .whitespacesAndNewlines)),
              let proteinValue = Double(proteinPerServing.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false // Invalid numeric input
        }
        
        // Make sure numeric inputs are not negative
        if caloriesValue <= 0 || servingSizeValue <= 0 || proteinValue <= 0 {
            return false
        }
        
        return true
    }
    
    var calories: Double {
        guard let servingSizeDouble = Double(servingSize),
              let amountEatenDouble = Double(amountEaten),
              servingSizeDouble != 0 else {
            return 0
        }
        
        let servingInGrams = convertToGrams(from: servingSizeDouble, type: servingType)
        let amountEatenInGrams = convertToGrams(from: amountEatenDouble, type: eatenServingType)
        
        return (caloriesPerServing.doubleValue / servingInGrams) * amountEatenInGrams
    }

    var protein: Double {
        guard let servingSizeDouble = Double(servingSize),
              let amountEatenDouble = Double(amountEaten),
              servingSizeDouble != 0 else {
            return 0
        }
        
        let servingInGrams = convertToGrams(from: servingSizeDouble, type: servingType)
        let amountEatenInGrams = convertToGrams(from: amountEatenDouble, type: eatenServingType)
        
        return (proteinPerServing.doubleValue / servingInGrams) * amountEatenInGrams
    }

    func convertToGrams(from value: Double, type: String) -> Double {
        var grams: Double = 0.0

        switch type.lowercased() {
        case "g":
            grams = value
        case "kg":
            grams = value * 1000
        case "oz":
            grams = value * 28.35
        case "lbs":
            grams = value * 453.592
        case "ml":
            grams = value * 1
        case "l":
            grams = value * 1000
        case "cups":
            grams = value * 236.588
        case "tsp":
            grams = value * 4.929
        case "tbsp":
            grams = value * 14.787
        case "fl oz":
            grams = value * 29.5735
        case "piece(s)":
            grams = value // Modify this based on specific item
        default:
            break
        }

        return grams
    }
    
    

}


extension String {
    var doubleValue: Double {
        return Double(self) ?? 0.0
    }
}
