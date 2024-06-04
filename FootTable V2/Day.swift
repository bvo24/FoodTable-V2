//
//  Day.swift
//  FoodTable
//
//  Created by Brian Vo on 5/28/24.
//

import SwiftUI
import Foundation

class Day: Identifiable, ObservableObject, Codable, Equatable {
    
    static func == (lhs: Day, rhs: Day) -> Bool {
            lhs.id == rhs.id
        }
    
    
    var id = UUID()
    @Published var date: Date
    @Published var breakfast: [FoodItem]
    @Published var lunch: [FoodItem]
    @Published var dinner: [FoodItem]
    
    init(date: Date, breakfast: [FoodItem], lunch: [FoodItem], dinner: [FoodItem]) {
        self.date = date
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
    }

    // CodingKeys enum for encoding and decoding
    enum CodingKeys: CodingKey {
        case id, date, breakfast, lunch, dinner
    }

    // Encode method to encode the properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(breakfast, forKey: .breakfast)
        try container.encode(lunch, forKey: .lunch)
        try container.encode(dinner, forKey: .dinner)
    }

    // Required initializer for decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        breakfast = try container.decode([FoodItem].self, forKey: .breakfast)
        lunch = try container.decode([FoodItem].self, forKey: .lunch)
        dinner = try container.decode([FoodItem].self, forKey: .dinner)
    }
    
    // Example of a static day instance
    static let example: Day = {
            let date = Date() // Current date and time
            
            // Breakfast items
            let breakfastItems = [
                FoodItem(id: UUID(), name: "Eggs", calories: 150.0, caloriesPerServing: "40", servingSize: "2", servingType: "piece(s)", eatenServingType: "piece(s)", amountEaten: "0", proteinPerServing: "15", protein: 12.0, stock: "high"),
                FoodItem(id: UUID(), name: "Toast", calories: 100.0, caloriesPerServing: "30", servingSize: "1", servingType: "piece(s)", eatenServingType: "piece(s)", amountEaten: "0", proteinPerServing: "30", protein: 3.0, stock: "medium")
            ]
            
            // Lunch items
            let lunchItems = [
                FoodItem(id: UUID(), name: "Chicken Salad", calories: 300.0, caloriesPerServing: "20", servingSize: "1", servingType: "g", eatenServingType: "g", amountEaten: "0", proteinPerServing: "20", protein: 20.0, stock: "medium"),
                FoodItem(id: UUID(), name: "Fruit Salad", calories: 120.0, caloriesPerServing: "15", servingSize: "1", servingType: "cup", eatenServingType: "cup", amountEaten: "0", proteinPerServing: "2", protein: 2.0, stock: "low")
            ]
            
            // Dinner items
            let dinnerItems = [
                FoodItem(id: UUID(), name: "Grilled Salmon", calories: 250.0, caloriesPerServing: "50", servingSize: "1", servingType: "fillet", eatenServingType: "fillet", amountEaten: "0", proteinPerServing: "25", protein: 25.0, stock: "high"),
                FoodItem(id: UUID(), name: "Steamed Vegetables", calories: 80.0, caloriesPerServing: "20", servingSize: "1", servingType: "cup", eatenServingType: "cup", amountEaten: "0", proteinPerServing: "3", protein: 3.0, stock: "medium")
            ]
            
            return Day(date: date, breakfast: breakfastItems, lunch: lunchItems, dinner: dinnerItems)
    }()
    
}
