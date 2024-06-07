import SwiftUI
import Foundation

class Day: Identifiable, ObservableObject, Codable, Equatable {
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    @Published var date: Date
    @Published var breakfast: [FoodItem] {
        didSet {
            updateTotals()
        }
    }
    @Published var lunch: [FoodItem] {
        didSet {
            updateTotals()
        }
    }
    @Published var dinner: [FoodItem] {
        didSet {
            updateTotals()
        }
    }
    
    @Published var proteinIntake: Double = 0.0
    @Published var totalProtein: Double = 0.0
    @Published var totalCalories: Double = 0.0
    @Published var calorieIntake: Double = 0.0
    
    private var proteinIntakeDefault: Int {
        UserDefaults.standard.integer(forKey: "proteinIntake")
    }
    private var calorieIntakeDefault: Int {
        UserDefaults.standard.integer(forKey: "calorieIntake")
    }
    
    init(date: Date, breakfast: [FoodItem], lunch: [FoodItem], dinner: [FoodItem]) {
        self.date = date
        self.breakfast = breakfast
        self.lunch = lunch
        self.dinner = dinner
        self.proteinIntake = Double(proteinIntakeDefault)
        self.totalProtein = calculateTotalProtein()
        self.calorieIntake = Double(calorieIntakeDefault)
        self.totalCalories = calculateTotalCalories()
    }
    
    enum CodingKeys: CodingKey {
        case id, date, breakfast, lunch, dinner, proteinIntake, totalProtein, totalCalories, calorieIntake
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(breakfast, forKey: .breakfast)
        try container.encode(lunch, forKey: .lunch)
        try container.encode(dinner, forKey: .dinner)
        try container.encode(proteinIntake, forKey: .proteinIntake)
        try container.encode(totalProtein, forKey: .totalProtein)
        try container.encode(totalCalories, forKey: .totalCalories)
        try container.encode(calorieIntake, forKey: .calorieIntake)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        breakfast = try container.decode([FoodItem].self, forKey: .breakfast)
        lunch = try container.decode([FoodItem].self, forKey: .lunch)
        dinner = try container.decode([FoodItem].self, forKey: .dinner)
        proteinIntake = try container.decode(Double.self, forKey: .proteinIntake)
        totalProtein = try container.decode(Double.self, forKey: .totalProtein)
        totalCalories = try container.decode(Double.self, forKey: .totalCalories)
        calorieIntake = try container.decode(Double.self, forKey: .calorieIntake)
        updateTotals()
    }
    
    static let example: Day = {
        let date = Date() // Current date and time
        
        let breakfastItems = [
            FoodItem(id: UUID(), name: "Eggs", caloriesPerServing: "40", servingSize: "2", servingType: "piece(s)", eatenServingType: "piece(s)", amountEaten: "0", proteinPerServing: "15",  stock: "high"),
            FoodItem(id: UUID(), name: "Toast", caloriesPerServing: "30", servingSize: "1", servingType: "piece(s)", eatenServingType: "piece(s)", amountEaten: "0", proteinPerServing: "30", stock: "medium")
        ]
        
        let lunchItems = [
            FoodItem(id: UUID(), name: "Chicken Salad", caloriesPerServing: "20", servingSize: "1", servingType: "g", eatenServingType: "g", amountEaten: "0", proteinPerServing: "20",  stock: "medium"),
            FoodItem(id: UUID(), name: "Fruit Salad", caloriesPerServing: "15", servingSize: "1", servingType: "cup", eatenServingType: "cup", amountEaten: "0", proteinPerServing: "2", stock: "low")
        ]
        
        let dinnerItems = [
            FoodItem(id: UUID(), name: "Grilled Salmon", caloriesPerServing: "50", servingSize: "1", servingType: "fillet", eatenServingType: "fillet", amountEaten: "0", proteinPerServing: "25",  stock: "high"),
            FoodItem(id: UUID(), name: "Steamed Vegetables", caloriesPerServing: "20", servingSize: "1", servingType: "cup", eatenServingType: "cup", amountEaten: "0", proteinPerServing: "3", stock: "medium")
        ]
        
        return Day(date: date, breakfast: breakfastItems, lunch: lunchItems, dinner: dinnerItems)
    }()
    
    private func calculateTotalCalories() -> Double {
        return breakfast.reduce(0) { $0 + $1.calories } +
               lunch.reduce(0) { $0 + $1.calories } +
               dinner.reduce(0) { $0 + $1.calories }
    }
    
    private func calculateTotalProtein() -> Double {
        return breakfast.reduce(0) { $0 + $1.protein } +
               lunch.reduce(0) { $0 + $1.protein } +
               dinner.reduce(0) { $0 + $1.protein }
    }
    
    private func calculateProteinIntake() -> Double {
        // In this example, assuming proteinIntake is directly derived from UserDefaults
        return Double(proteinIntake)
    }
    
    private func calculateCalorieIntake() -> Double {
        // In this example, assuming calorieIntake is directly derived from UserDefaults
        return Double(calorieIntake)
    }
    
    private func updateTotals() {
        proteinIntake = calculateProteinIntake()
        totalProtein = calculateTotalProtein()
        totalCalories = calculateTotalCalories()
        calorieIntake = calculateCalorieIntake()
    }
}

