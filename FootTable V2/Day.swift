//
//  Day.swift
//  FoodTable
//
//  Created by Brian Vo on 5/28/24.
//

import Foundation
import SwiftData

//@Model
class Day: Codable, Identifiable{
    var date : Date
    var breakfast : [FoodItem]
    var lunch : [FoodItem]
    var dinner : [FoodItem]
    
    init(date: Date, breakfast: [FoodItem], lunch: [FoodItem], dinner: [FoodItem]) {
        self.date = date
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }
    
    static let example: Day = {
        let breakfastItems = [
            FoodItem(id: UUID(), name: "Eggs", calories: "150", servingSize: "2", servingType: "pieces", protein: "12", stock: "high"),
            FoodItem(id: UUID(), name: "Toast", calories: "100", servingSize: "1", servingType: "slice", protein: "3", stock: "medium")
        ]

        let lunchItems = [
            FoodItem(id: UUID(), name: "Chicken Salad", calories: "300", servingSize: "1", servingType: "plate", protein: "20", stock: "medium"),
            FoodItem(id: UUID(), name: "Fruit Salad", calories: "120", servingSize: "1", servingType: "bowl", protein: "2", stock: "low")
        ]

        let dinnerItems = [
            FoodItem(id: UUID(), name: "Grilled Salmon", calories: "250", servingSize: "1", servingType: "fillet", protein: "25", stock: "high"),
            FoodItem(id: UUID(), name: "Steamed Vegetables", calories: "80", servingSize: "1", servingType: "cup", protein: "3", stock: "medium")
        ]

        return Day(date: Date(), breakfast: breakfastItems, lunch: lunchItems, dinner: dinnerItems)
    }()
    
}

