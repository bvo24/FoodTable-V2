import SwiftUI

struct BuffLogView: View {
    @ObservedObject var dayManager: DayManager
    @State private var showAddView = false
    @State private var mealTime = Meal.breakfast
    @State private var selectedDate = Date()
    
    @State private var refreshID = UUID()

    // In your view
    

    // When data changes and you want to trigger a refresh
   

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Breakfast")) {
                    ForEach(dayManager.selectedDay.breakfast, id: \.self) { food in
                        HStack {
                            Text(food.name)
                            Spacer()
                            Text("\(food.calories) cal")
                        }
                    }
                    .onDelete(perform: { indexSet in
                        dayManager.selectedDay.breakfast.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                    })
                    Button(action: {
                        mealTime = .breakfast
                        showAddView.toggle()
                    }) {
                        Label("Add Breakfast Item", systemImage: "plus")
                    }
                }

                Section(header: Text("Lunch")) {
                    ForEach(dayManager.selectedDay.lunch, id: \.self) { food in
                        HStack {
                            Text(food.name)
                            Spacer()
                            Text("\(food.calories) cal")
                        }
                    }
                    .onDelete(perform: { indexSet in
                        dayManager.selectedDay.lunch.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                    })
                    Button(action: {
                        mealTime = .lunch
                        showAddView.toggle()
                    }) {
                        Label("Add Lunch Item", systemImage: "plus")
                    }
                }

                Section(header: Text("Dinner")) {
                    ForEach(dayManager.selectedDay.dinner, id: \.self) { food in
                        HStack {
                            Text(food.name)
                            Spacer()
                            Text("\(food.calories) cal")
                        }
                    }
                    .onDelete(perform: { indexSet in
                        dayManager.selectedDay.dinner.remove(atOffsets: indexSet)
                        dayManager.updateSelectedDay()
                    })
                    Button(action: {
                        mealTime = .dinner
                        showAddView.toggle()
                    }) {
                        Label("Add Dinner Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Buff Log")
            .sheet(isPresented: $showAddView) {
                AddView(dayManager: dayManager, meal: mealTime)
            }
            


            
            .toolbar {
                ToolbarItem{
                    Button("List") {
                                    printDaysList()
                                }
                }
                
                            ToolbarItem(placement: .navigationBarLeading) {
                                // Add a Date Picker in the toolbar
                                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .onChange(of: selectedDate) { oldValue, newValue in
                                                                print("Selected Date changed to: \(newValue)")
                                                                changeDate(to: newValue)
                                                                
                                                            }
                            }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Add Random Breakfast Item", systemImage: "plus") {
                                    // Generate a random index within the range of FoodItem.examples array
                                    let randomIndex = Int.random(in: 0..<FoodItem.examples.count)
                                    
                                    // Get the random food item from FoodItem.examples
                                    let randomFoodItem = FoodItem.examples[randomIndex]
                                    
                                    // Add the random food item to the breakfast list of the selected day
                                    dayManager.selectedDay.breakfast.append(randomFoodItem)
                                    
                                    // Call the updateSelectedDay function to update the selected day
                                    dayManager.updateSelectedDay()
                                    
                                    // Call the saveDays function to save the changes
                                    refreshID = UUID()
                                }
                            }
                
                

                            
            }
            .id(refreshID) // Force view refresh based on refreshID
        }
    }
    private func printDaysList() {
            print("Days List:")
            for day in dayManager.days {
                print("Date: \(day.date), Breakfast: \(day.breakfast), Lunch: \(day.lunch), Dinner: \(day.dinner)")
            }
        }
    
    private func changeDate(to date: Date) {
            dayManager.changeDate(to: date)
            refreshID = UUID()
        
            print("Day Manager Selected Day ID: \(dayManager.selectedDay.id)")

        }
    
}

enum Meal {
    case breakfast, lunch, dinner
}

#Preview {
    BuffLogView(dayManager: DayManager())
}

