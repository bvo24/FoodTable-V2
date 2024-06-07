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
        removeOldDays()
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

    private func removeOldDays() {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        days.removeAll { day in
            if day.date < sevenDaysAgo {
                print("Removing day: \(day.date)")
                return true
            }
            return false
        }
        saveDays()
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
        // Check if a day with the same date already exists
        if let existingDayIndex = days.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: day.date) }) {
            // Day with the same date already exists, update it
            print("Updating day")
            days[existingDayIndex] = day
        } else {
            // Add the new day if it doesn't exist
            days.append(day)
        }
        // Remove old days if necessary
        removeOldDays()
        saveDays()
        selectedDay = day
    }
    
    func changeDate(to date: Date) {
        if let existingDay = days.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            selectedDay = existingDay
//            print("Date existed")
        } else if Calendar.current.isDate(date, inSameDayAs: Date()) || date > Calendar.current.date(byAdding: .day, value: -7, to: Date())! {
//            print("New date within range")
            let newDay = Day(date: date, breakfast: [], lunch: [], dinner: [])
            addDay(newDay)
            selectedDay = newDay
        } else {
            print("Date beyond range, not allowed")
        }
    }

    func updateSelectedDay() {
        if let index = days.firstIndex(where: { $0.id == selectedDay.id }) {
            days[index].breakfast = selectedDay.breakfast
            days[index].lunch = selectedDay.lunch
            days[index].dinner = selectedDay.dinner
            days[index].proteinIntake = selectedDay.proteinIntake
            days[index].totalProtein = selectedDay.totalProtein
            days[index].calorieIntake = selectedDay.calorieIntake
            days[index].totalCalories = selectedDay.totalCalories
            saveDays()
        }
    }

    func updateFoodItem(updatedFoodItem: FoodItem) {
        if let index = selectedDay.breakfast.firstIndex(where: { $0.id == updatedFoodItem.id }) {
            selectedDay.breakfast[index] = updatedFoodItem
        } else if let index = selectedDay.lunch.firstIndex(where: { $0.id == updatedFoodItem.id }) {
            selectedDay.lunch[index] = updatedFoodItem
        } else if let index = selectedDay.dinner.firstIndex(where: { $0.id == updatedFoodItem.id }) {
            selectedDay.dinner[index] = updatedFoodItem
        }
        updateSelectedDay()
    }

    // Test function to simulate adding days and removing old ones
    func testDayRemoval() {
        let today = Date()

        // Add 8 days to dayManager, with one day being beyond 7 days in the past
        for i in 0..<8 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: today) {
                let day = Day(date: date, breakfast: [], lunch: [], dinner: [])
                addDay(day)
            }
        }

        print("Days in manager after adding 8 days:")
        for day in days {
            print(day.date)
        }
    }

    func listAllDays() {
        print("Current days in manager:")
        for day in days {
            print(day.date)
        }
    }
}
