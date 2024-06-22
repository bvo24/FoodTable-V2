import SwiftUI

struct BuffLogView: View {
    @ObservedObject var dayManager: DayManager
    @State private var showAddView = false
    @State private var mealTime = Meal.breakfast
    @State private var selectedDate = Date()
    @State private var showProteinView = false
//    @State private var proteinCount: Int = UserDefaults.standard.integer(forKey: "proteinCount")
    @State private var refreshID = UUID()

    
    

    
    
    
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
                    .listRowBackground(Color.mediumWood)
//                    .background(EmptyView().id(refreshID))
                    
                    Button(action: {
                        mealTime = .breakfast
                        showAddView.toggle()
                    }) {
                        Label("Add Breakfast Item", systemImage: "plus")
                            .foregroundStyle(Color.black)
                        
                    }
                    .listRowBackground(Color.lightWood)
                    
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
                    .listRowBackground(Color.mediumWood)
                    .background(EmptyView().id(refreshID))
                    
                    Button(action: {
                        mealTime = .lunch
                        showAddView.toggle()
                    }) {
                        Label("Add Lunch Item", systemImage: "plus")
                    }
                    .foregroundStyle(Color.black)
                    .listRowBackground(Color.lightWood)
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
                    .listRowBackground(Color.mediumWood)
                    .background(EmptyView().id(refreshID))
                    
                    Button(action: {
                        mealTime = .dinner
                        showAddView.toggle()
                    }) {
                        Label("Add Dinner Item", systemImage: "plus")
                    }
                    .foregroundStyle(.black)
                    .listRowBackground(Color.lightWood)
                }
                
                Text("\(dayManager.selectedDay.totalCalories, specifier: "%.1f") Calories out of \(dayManager.selectedDay.calorieIntake, specifier: "%.1f")")
                    .listRowBackground(Color.lightWood)
                
                Text("\(dayManager.selectedDay.totalProtein, specifier: "%.1f") out of \(dayManager.selectedDay.proteinIntake, specifier: "%.1f")")
                    .listRowBackground(Color.lightWood)
            }
           
//            .navigationTitle("Journal")
            //.navigationBarTitle (Text("Dashboard"), displayMode: .inline)
//            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddView) {
                AddView(dayManager: dayManager, meal: mealTime, inventoryManager: InventoryManager())
                    .onDisappear {
                        refreshID = UUID()
                    }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                                VStack {
                                    Text("Journal")
                                        .font(.custom("PixelifySans-Regular", size: 24))
                                      .foregroundColor(Color.black)
                                }
                            }
                
                //Test button
//                ToolbarItem {
//                    Button("List") {
//                        printDaysList()
//                    }
//                }
                ToolbarItem(placement: .topBarTrailing) {
                                    
                    
                        
                        
                        DatePicker("Select Date", selection: $selectedDate, in: Calendar.current.date(byAdding: .day, value: -6, to: Date())!...Date.distantFuture, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            
                            .onChange(of: selectedDate) { oldValue, newValue in
                                print("Selected Date changed from: \(oldValue) to: \(newValue)")
                                changeDate(to: newValue)
                            }
                            .font(.custom("PixelifySans-Regular", size: 20))
                            .labelsHidden()
                            .frame(maxWidth: 200)
                    
                                    
                }
                
                ToolbarItem(placement: .topBarTrailing) {
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
//                ToolbarItem {
////                    let today = Calendar.current.startOfDay(for: Date())
////                    let sixDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: today)!
//                    HStack{
//                        DatePicker("Select Date", selection: $selectedDate, in: Calendar.current.date(byAdding: .day, value: -6, to: Date())!...Date.distantFuture, displayedComponents: .date)
//                            .datePickerStyle(.compact)
//                            .onChange(of: selectedDate) { oldValue, newValue in
//                                print("Selected Date changed from: \(oldValue) to: \(newValue)")
//                                changeDate(to: newValue)
//                            }
//                            .labelsHidden()
//                    }
//                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.darkWood)
            .background(
                CustomNavigationBar(backgroundColor: UIColor.lightBrown, titleColor: UIColor.black)
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

extension Color {
    static let darkWood = Color(red: 0.43, green: 0.26, blue: 0.19) // Dark brown
    static let mediumWood = Color(red: 0.60, green: 0.40, blue: 0.28) // Medium brown
    static let lightWood = Color(red: 0.83, green: 0.70, blue: 0.44) // Light brown
    static let lightGray = Color(red: 0.85, green: 0.85, blue: 0.85)
    
    
}


#Preview {
    BuffLogView(dayManager: DayManager())
}

