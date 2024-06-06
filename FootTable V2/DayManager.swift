//
//  DayManager.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/29/24.
//


import Foundation
import SwiftUI

class DayManager: ObservableObject {
    @Published var days: [Day]
    @Published var selectedDay: Day

    private let savePath = URL.documentsDirectory.appendingPathComponent("SavedDays")

    init() {
        self.days = []
        self.selectedDay = Day(date: Date(), breakfast: [], lunch: [], dinner: [])
        loadDays()
        updateSelectedDayIfNeeded()
    }

    private func loadDays() {
        do {
            let data = try Data(contentsOf: savePath)
            days = try JSONDecoder().decode([Day].self, from: data)
        } catch {
            days = []
        }
    }

    private func saveDays() {
        do {
            let data = try JSONEncoder().encode(days)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }

    private func updateSelectedDayIfNeeded() {
        let today = Date()
        if let existingDay = days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            selectedDay = existingDay
        } else {
            let newDay = Day(date: today, breakfast: [], lunch: [], dinner: [])
            addDay(newDay)
        }
    }

    func addDay(_ day: Day) {
        days.append(day)
        saveDays()
        selectedDay = day
    }
    
    func changeDate(to date: Date) {
        if let existingDay = days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            selectedDay = existingDay
            print("date existed")
        } else {
            print("new date")
            let newDay = Day(date: date, breakfast: [], lunch: [], dinner: [])
            days.append(newDay)
            selectedDay = newDay
        }
    }

    func updateSelectedDay() {
        if let index = days.firstIndex(where: { $0.id == selectedDay.id }) {
            days[index] = selectedDay
            saveDays()
        }
    }
    
    func updateFoodItem(updatedFoodItem: FoodItem) {
        // Check if the updated food item ID matches any existing food item in the selected day's meals
        if let index = selectedDay.breakfast.firstIndex(where: { $0.id == updatedFoodItem.id }) {
            selectedDay.breakfast[index] = updatedFoodItem
        } else if let index = selectedDay.lunch.firstIndex(where: { $0.id == updatedFoodItem.id }) {
            selectedDay.lunch[index] = updatedFoodItem
        } else if let index = selectedDay.dinner.firstIndex(where: { $0.id == updatedFoodItem.id }) {
            selectedDay.dinner[index] = updatedFoodItem
        }
        recalculateTotalProtein() // Recalculate total protein after updating food item
    }
    
    private func recalculateTotalProtein() {
        let totalProtein = selectedDay.breakfast.reduce(0) { $0 + $1.protein } +
                           selectedDay.lunch.reduce(0) { $0 + $1.protein } +
                           selectedDay.dinner.reduce(0) { $0 + $1.protein }
        selectedDay.totalProtein = totalProtein
    }
}
