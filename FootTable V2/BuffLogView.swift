//
//  BuffLogView.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/28/24.
//
import SwiftUI

struct BuffLogView: View {
    
    @ObservedObject var dayManager: DayManager
    @State private var showAddView = false
    @State private var mealTime = "Breakfast"
    @State private var selectedDate = Date()

        var body: some View {
            NavigationStack {
                VStack{
                    
                    
                }
                
                
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
                        })
                        Button("Add Breakfast Item", systemImage: "plus"){
                            mealTime = "Breakfast"
                            showAddView.toggle()
                            
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
                        })
                        Button("Add Lunch Item", systemImage: "plus"){
                            mealTime = "Lunch"
                            showAddView.toggle()
                           
                            
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
                        })
                        
                        Button("Add Dinner Item", systemImage: "plus"){
                            mealTime = "Dinner"
                            showAddView.toggle()
                            
                        }
                    }
                   
                }
                .navigationTitle("Buff Log")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: addFoodToMeal) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddView , content: {
                    AddView(dayManager: dayManager, meal: mealTime)
                })
            }
        }

        private func addFoodToMeal() {
            // Adding a new food item for demonstration purposes
            let newFood = FoodItem(id: UUID(), name: "New Food", calories: "100", servingSize: "1", servingType: FoodItem.measurementUnits[0], protein: "5", stock: FoodItem.stockLevel[0])

            // Example: Adding the new food to breakfast. You can modify this to add to lunch or dinner.
            dayManager.selectedDay.breakfast.append(newFood)
        }
    }


#Preview {
    BuffLogView(dayManager: DayManager(selectedDay: Day.example))
}
