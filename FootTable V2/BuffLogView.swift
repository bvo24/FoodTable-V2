import SwiftUI

struct BuffLogView: View {
    @ObservedObject var dayManager: DayManager
    @State private var showAddView = false
    @State private var mealTime = Meal.breakfast
    @State private var selectedDate = Date()
    @State private var showProteinView = false
    @State private var proteinCount : Int = UserDefaults.standard.integer(forKey: "proteinCount")
    @State private var refreshID = UUID()

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Breakfast")) {
                    ForEach(dayManager.selectedDay.breakfast, id: \.self) { food in
                        NavigationLink(destination: EditView(dayManager: dayManager, foodItem: food, refreshID: $refreshID)  ) {
                                            HStack {
                                                Text(food.name)
                                                Spacer()
                                                Text("\(food.calories, specifier: "%.1f") cal")
                                            }
                                        }
                        .onDisappear{
                                refreshID = UUID()
                        }
                        //add this to other times lunch / dinner
                        
//                        HStack {
//                            Text(food.name)
//                            Spacer()
//                            Text("\(food.calories, specifier: "%.1f") cal")
//                        }
                    }
                    .onDelete(perform: { indexSet in
                        dayManager.selectedDay.breakfast.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                        refreshID = UUID()
                    })
                    .background(EmptyView().id(refreshID)) // Ensure view updates correctly
                    
                    Button(action: {
                        mealTime = .breakfast
                        showAddView.toggle()
                    }) {
                        Label("Add Breakfast Item", systemImage: "plus")
                    }
                }

                Section(header: Text("Lunch")) {
                    ForEach(dayManager.selectedDay.lunch, id: \.self) { food in
                        NavigationLink(destination: EditView(dayManager: dayManager, foodItem: food, refreshID: $refreshID)  ) {
                                            HStack {
                                                Text(food.name)
                                                Spacer()
                                                Text("\(food.calories, specifier: "%.1f") cal")
                                            }
                                        }
                        .onDisappear{
                                refreshID = UUID()
                        }
                        //add this to other times lunch / dinner
                        
//                        HStack {
//                            Text(food.name)
//                            Spacer()
//                            Text("\(food.calories, specifier: "%.1f") cal")
//                        }
                    }
                    .onDelete(perform: { indexSet in
                        dayManager.selectedDay.lunch.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                        refreshID = UUID()
                    })
                    .background(EmptyView().id(refreshID)) // Ensure view updates correctly
                    
                    Button(action: {
                        mealTime = .lunch
                        showAddView.toggle()
                    }) {
                        Label("Add Lunch Item", systemImage: "plus")
                    }
                }

                Section(header: Text("Dinner")) {
                    ForEach(dayManager.selectedDay.dinner, id: \.self) { food in
                        NavigationLink(destination: EditView(dayManager: dayManager, foodItem: food, refreshID: $refreshID)  ) {
                                            HStack {
                                                Text(food.name)
                                                Spacer()
                                                Text("\(food.calories, specifier: "%.1f") cal")
                                            }
                                        }
                        .onDisappear{
                                refreshID = UUID()
                        }
                        //add this to other times lunch / dinner
                        
//                        HStack {
//                            Text(food.name)
//                            Spacer()
//                            Text("\(food.calories, specifier: "%.1f") cal")
//                        }
                    }
                    .onDelete(perform: { indexSet in
                        dayManager.selectedDay.dinner.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                        refreshID = UUID()
                    })
                    .background(EmptyView().id(refreshID)) // Ensure view updates correctly
                    
                    Button(action: {
                        mealTime = .dinner
                        showAddView.toggle()
                    }) {
                        Label("Add Dinner Item", systemImage: "plus")
                    }
                }
                
                Text( "\(dayManager.selectedDay.totalCalories, specifier: "%.0f" ) Calories out of \(dayManager.selectedDay.calorieIntake, specifier: "%.0f" )")
                
                Text("\(dayManager.selectedDay.totalProtein, specifier: "%.1f") out of \(dayManager.selectedDay.proteinIntake, specifier: "%.1f")")
                
                
                
            }
            .navigationTitle("Buff Log")
            .sheet(isPresented: $showAddView) {
                AddView(dayManager: dayManager, meal: mealTime)
                    .onDisappear{
                        refreshID = UUID()
                        
                    }
            }
            
            .toolbar {
                ToolbarItem {
                    Button("List") {
                        printDaysList()
                    }
                }
                ToolbarItem {
                    Button("Update") {
                        showProteinView.toggle()
                    }
                    .sheet(isPresented: $showProteinView ){
                        proteinView(dayManager: dayManager)
                            .onDisappear {
                                proteinCount = UserDefaults.standard.integer(forKey: "proteinCount")
                                
                                refreshID = UUID()
                            }

                            
                    }
                    
                }
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .onChange(of: selectedDate) { oldValue, newValue in
                            print("Selected Date changed from: \(oldValue) to: \(newValue)")
                            changeDate(to: newValue)
                        }
                        .labelsHidden()
                }
                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Add Random Breakfast Item") {
//                        let randomIndex = Int.random(in: 0..<FoodItem.examples.count)
//                        let randomFoodItem = FoodItem.examples[randomIndex]
//                        dayManager.selectedDay.breakfast.append(randomFoodItem)
//                        dayManager.updateSelectedDay()
//                        refreshID = UUID() // Force view refresh
//                    }
//                }
                
            }
            .id(refreshID)
        }
    }

    private func printDaysList() {
        print( "Protein count \(dayManager.selectedDay.proteinIntake)" )
        print("Days List:")
        for day in dayManager.days {
            print("Date: \(day.date), Breakfast: \(day.breakfast), Lunch: \(day.lunch), Dinner: \(day.dinner)")
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

#Preview {
    BuffLogView(dayManager: DayManager())
}

