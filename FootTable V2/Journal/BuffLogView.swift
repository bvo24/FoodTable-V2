import SwiftUI

struct BuffLogView: View {
    @ObservedObject var dayManager: DayManager
    @State private var showAddView = false
    @State private var mealTime = Meal.breakfast
    @State private var selectedDate = Date()
    @State private var showProteinView = false
//    @State private var proteinCount: Int = UserDefaults.standard.integer(forKey: "proteinCount")
    @State private var refreshID = UUID()

    let darkWoodColor = Color(red: 0.43, green: 0.26, blue: 0.19) // Dark brown
        let mediumWoodColor = Color(red: 0.60, green: 0.40, blue: 0.28) // Medium brown
        let lightWoodColor = Color(red: 0.83, green: 0.70, blue: 0.44) // Light brown

    
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Breakfast").foregroundStyle(.white)) {
                    ForEach(dayManager.selectedDay.breakfast, id: \.self) { food in
                        NavigationLink(destination: EditView(dayManager: dayManager, foodItem: food, refreshID: $refreshID)) {
                            HStack {
                                Text(food.name)
                                Spacer()
                                Text("\(food.calories, specifier: "%.1f") cal")
                            }
                            .foregroundColor(Color.white)
//                            .background(Color.brown)
                        }
                        
                        .onDisappear {
                            refreshID = UUID()
                        }
                    }
                    
                    .onDelete { indexSet in
                        dayManager.selectedDay.breakfast.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                        refreshID = UUID()
                    }
                    .listRowBackground(mediumWoodColor)
//                    .background(EmptyView().id(refreshID))
                    
                    Button(action: {
                        mealTime = .breakfast
                        showAddView.toggle()
                    }) {
                        Label("Add Breakfast Item", systemImage: "plus")
                            .foregroundStyle(.white)
                        
                    }
                    .listRowBackground(lightWoodColor)
                    
                }

                Section(header: Text("Lunch").foregroundStyle(.white)) {
                    ForEach(dayManager.selectedDay.lunch, id: \.self) { food in
                        NavigationLink(destination: EditView(dayManager: dayManager, foodItem: food, refreshID: $refreshID)) {
                            HStack {
                                Text(food.name)
                                Spacer()
                                Text("\(food.calories, specifier: "%.1f") cal")
                            }
                            .foregroundStyle(Color.white)
                        }
                        .onDisappear {
                            refreshID = UUID()
                        }
                    }
                    .onDelete { indexSet in
                        dayManager.selectedDay.lunch.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                        refreshID = UUID()
                    }
                    .listRowBackground(mediumWoodColor)
                    .background(EmptyView().id(refreshID))
                    
                    Button(action: {
                        mealTime = .lunch
                        showAddView.toggle()
                    }) {
                        Label("Add Lunch Item", systemImage: "plus")
                    }
                    .foregroundStyle(Color.white)
                    .listRowBackground(lightWoodColor)
                }

                Section(header: Text("Dinner").foregroundStyle(.white)) {
                    ForEach(dayManager.selectedDay.dinner, id: \.self) { food in
                        NavigationLink(destination: EditView(dayManager: dayManager, foodItem: food, refreshID: $refreshID)) {
                            HStack {
                                Text(food.name)
                                Spacer()
                                Text("\(food.calories, specifier: "%.1f") cal")
                            }
                        }
                        .onDisappear {
                            refreshID = UUID()
                        }
                    }
                    .onDelete { indexSet in
                        dayManager.selectedDay.dinner.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                        refreshID = UUID()
                    }
                    .background(EmptyView().id(refreshID))
                    
                    Button(action: {
                        mealTime = .dinner
                        showAddView.toggle()
                    }) {
                        Label("Add Dinner Item", systemImage: "plus")
                    }
                }
                
                Text("\(dayManager.selectedDay.totalCalories, specifier: "%.1f") Calories out of \(dayManager.selectedDay.calorieIntake, specifier: "%.1f")")
                
                Text("\(dayManager.selectedDay.totalProtein, specifier: "%.1f") out of \(dayManager.selectedDay.proteinIntake, specifier: "%.1f")")
            }
           
            .navigationTitle("Journal")
//            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddView) {
                AddView(dayManager: dayManager, meal: mealTime, inventoryManager: InventoryManager())
                    .onDisappear {
                        refreshID = UUID()
                    }
            }
            .toolbar {
                
                //Test button
                ToolbarItem {
                    Button("List") {
                        printDaysList()
                    }
                }
                ToolbarItem {
                    Button("Update") {
                        showProteinView.toggle()
                    }
                    .sheet(isPresented: $showProteinView) {
                        proteinView(dayManager: dayManager)
                            .onDisappear {
//                                proteinCount = UserDefaults.standard.integer(forKey: "proteinCount")
                                refreshID = UUID()
                            }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
//                    let today = Calendar.current.startOfDay(for: Date())
//                    let sixDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: today)!
                    
                    DatePicker("Select Date", selection: $selectedDate, in: Calendar.current.date(byAdding: .day, value: -6, to: Date())!...Date.distantFuture, displayedComponents: .date)
                                            .datePickerStyle(.compact)
                                            .onChange(of: selectedDate) { oldValue, newValue in
                                                print("Selected Date changed from: \(oldValue) to: \(newValue)")
                                                changeDate(to: newValue)
                                            }
                                            .labelsHidden()
                }
            }
            .scrollContentBackground(.hidden)
            .background(darkWoodColor)
            .background(
                CustomNavigationBar(backgroundColor: UIColor.lightBrown, titleColor: UIColor.white)
                                    .edgesIgnoringSafeArea(.top)
            )
            
            .id(refreshID)
        }
    }

    private var dateRange: ClosedRange<Date> {
        let today = Calendar.current.startOfDay(for: Date())
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: today)!
//        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        return sevenDaysAgo...today
    }

    private func printDaysList() {
        print("Protein count \(dayManager.selectedDay.proteinIntake)")
        print("Days List:")
        for day in dayManager.days {
//            print("Date: \(day.date), Breakfast: \(day.breakfast), Lunch: \(day.lunch), Dinner: \(day.dinner)")
            print("Date: \(day.date) - Calorie Intake \(day.calorieIntake)")
        }
    }

    private func changeDate(to date: Date) {
        dayManager.changeDate(to: date)
        refreshID = UUID() // Force view refresh
        print("Changed date to: \(date)")
        print("Day Manager Selected Day ID: \(dayManager.selectedDay.id)")
    }
}

enum Meal {
    case breakfast, lunch, dinner
}

import UIKit

extension UIColor {
    static var lightBrown: UIColor {
        return UIColor(red: 0.827, green: 0.686, blue: 0.518, alpha: 1.0)
    }
}


#Preview {
    BuffLogView(dayManager: DayManager())
}

