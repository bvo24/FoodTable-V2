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
            print("FOUND DAY")
            
            if let index = days.firstIndex(where: { $0.id == selectedDay.id }) {
                    days[index].breakfast = selectedDay.breakfast
                    days[index].lunch = selectedDay.lunch
                    days[index].dinner = selectedDay.dinner
                    saveDays()
                }
        }
        print("DIDN'T FIND DAY")
    }
}

