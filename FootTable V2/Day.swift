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

            return Day(date: date, breakfast: breakfastItems, lunch: lunchItems, dinner: dinnerItems)
        }()
    
    
}
