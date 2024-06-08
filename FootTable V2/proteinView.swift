//
//  proteinView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/4/24.
//

import SwiftUI

struct proteinView: View {
    @ObservedObject var dayManager: DayManager
    @State private var proteinIntake: Int = 0
    @State private var calorieIntake: Int = 0
    @Environment(\.dismiss) var dismiss
    let genders = ["Male", "Female"]
    
//    static let TDEES = [1.2, 1.375, 1.55, 1.725, 1.9]
    
    let TDEES = [1.2, 1.375, 1.55, 1.725, 1.9]
    
    
    
//    @State private var weightInPoundsUD : Int? = UserDefaults.standard.integer(forKey: "weight")
//    @State private var genderUD = UserDefaults.standard.string(forKey: "gender")
//    @State private var heightInInchesUD = UserDefaults.standard.integer(forKey: "height")
//    @State private var ageInYearsUD = UserDefaults.standard.integer(forKey: "age")
//    
//    @State private var gender = UserDefaults.standard.string(forKey: "gender") ?? "Male"
//    @State private var weightInPounds =
//    @State private var heightInInches = "0"
//    @State private var ageInYears = "0"
    
    @State private var weight: String = UserDefaults.standard.string(forKey: "weight") ?? "0"
    @State private var gender: String = UserDefaults.standard.string(forKey: "gender") ?? "Male"
    @State private var height: String = UserDefaults.standard.string(forKey: "height") ?? "0"
    @State private var ageInYears: String = UserDefaults.standard.string(forKey: "age") ?? "0"
    
    @State private var selectedActivityIndex: Int = UserDefaults.standard.integer(forKey: "selectedActivityIndex")
    
    @State private var selectedProteinGoalIndex: Int = UserDefaults.standard.integer(forKey: "selectedProteinGoalIndex")
    
    
    
    let weightUnits = ["lbs", "kgs"]
    @State private var weightUnit: String = UserDefaults.standard.string(forKey: "weightUnit") ?? "lbs"
    
    
    let heightUnits = ["ft", "cm"]
    @State private var heightUnit: String = UserDefaults.standard.string(forKey: "heightUnit") ?? "ft"
    
    
    let dietGoals = ["Heavy Cut", "Light Cut", "Maintenance", "Light Bulk", "Heavy Bulk"]
    let dietingCalories = [-500, -250, 0, 250, 500]
    @State private var selectedDietGoalsIndex = UserDefaults.standard.integer(forKey: "selectedDietGoalsIndex")
    
    
    var weightInPounds: Double? {
        if weightUnit == "lbs" {
            return Double(weight) ?? 0
        } else {
            // Convert kg to lbs
//            if let kg = Double(weight) {
            return (Double(weight) ?? 0) * 2.20462
//            } else {
//                return nil // Handle conversion failure gracefully
//            }
        }
    }
    
    var heightInInches: Double? {
        if heightUnit == "ft" {
            // Convert feet to inches
            
            let components = height.split(separator: "ft")
            guard components.count == 2,
                          let feet = Int(components[0].trimmingCharacters(in: .whitespacesAndNewlines)),
                          let inches = Int(components[1].trimmingCharacters(in: .whitespacesAndNewlines)) else {
                        return nil
                    }
            return Double( (feet) * 12 + (inches) )
        } else {
            // Convert cm to inches
                return (Double(height) ?? 0) / 2.54
            
        }
    }
    
    //    Sedentary (little or no exercise): BMR x 1.2
    //    Lightly active (light exercise/sports 1-3 days/week): BMR x 1.375
    //    Moderately active (moderate exercise/sports 3-5 days/week): BMR x 1.55
    //    Very active (hard exercise/sports 6-7 days a week): BMR x 1.725
    //    Extra active (very hard exercise/sports & physical job or 2x training): BMR x 1.9
        
//    @State private var TDEE =
    var TDEE : Double{
        
        if selectedActivityIndex == 0{
            return TDEES[0]
        }
        else if selectedActivityIndex > 0 && selectedActivityIndex < 3 {
            return TDEES[1]
        }
        else if selectedActivityIndex >= 3 && selectedActivityIndex <= 5{
            return TDEES[2]
        }
        else if selectedActivityIndex >= 6 && selectedActivityIndex <= 7{
            return TDEES[3]
        }
        else{
            return TDEES[4]
        }
        
    }
    
    
    
    let proteinGoals = ["Average", "Active", "Body Builder"]
    let recProteinPerLb = [0.4, 0.6, 0.9]
//    @State private var selectedActivityIndex = 0
    var proteinPerLb : Double {
        
        recProteinPerLb[selectedProteinGoalIndex]
    }
    


    
    
//    4.536×weight in lbs+15.88×height in inches−5×age in years+5
    var BMRMale: Double {
        guard let weight = weightInPounds, let height = heightInInches, let age = Double(ageInYears) else {
            return 0
        }
        return (4.536 * weight) + (15.88 * height) - (5 * age) + 5
    }

    var BMRFemale: Double {
        guard let weight = weightInPounds, let height = heightInInches, let age = Double(ageInYears) else {
            return 0
        }
        return (4.536 * weight) + (15.88 * height) - (5 * age) - 161
    }

    var recCals: Double {
        if gender == "Male" {
            return ( BMRMale * TDEE ) + Double(dietingCalories[selectedDietGoalsIndex])
        } else {
            return ( BMRFemale * TDEE ) +  Double(dietingCalories[selectedDietGoalsIndex])
        }
    }

    var recProtein: Double {
        guard let weight = weightInPounds else {
            return 0
        }
        return weight * recProteinPerLb[selectedProteinGoalIndex]
    }

    
    
    
//    Sedentary (little or no exercise): BMR x 1.2
//    Lightly active (light exercise/sports 1-3 days/week): BMR x 1.375
//    Moderately active (moderate exercise/sports 3-5 days/week): BMR x 1.55
//    Very active (hard exercise/sports 6-7 days a week): BMR x 1.725
//    Extra active (very hard exercise/sports & physical job or 2x training): BMR x 1.9
    
    
    
    
    var body: some View {
        VStack {
//            Text("Enter your total protein intake")
//                .font(.headline)
//            
//            TextField("Protein intake", value: $proteinIntake, formatter: NumberFormatter())
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.numberPad)
//                .padding()
//            
//            Text("Enter your total calorie intake")
//                .font(.headline)
//                .padding(.top)
//            
//            TextField("Calorie intake", value: $calorieIntake, formatter: NumberFormatter())
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.numberPad)
//                .padding()
            
            Form{
                Picker("Gender:", selection: $gender){
                    ForEach(genders, id: \.self){ gender in
                        Text(gender)
                    }
                }
                .pickerStyle(.segmented)
                HStack{
                    Text("Age:")
                    TextField("Enter your age", text: $ageInYears)
                }
                HStack{
                    Text("Height:")
                    if(heightUnit == "ft"){
                        TextField("5'6", text: $height)
                    }
                    else{
                        TextField("", text: $height)
                    }
                    Picker("Select your height units", selection: $heightUnit){
                        ForEach(heightUnits, id: \.self){ unit in
                            Text(unit)
                        }
                        
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }
                HStack{
                    Text("Weight:")
                    TextField("Enter your weight", text: $weight)
                    Picker("Select your height units", selection: $weightUnit){
                        ForEach(weightUnits, id: \.self){ unit in
                            Text(unit)
                        }
                       
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }
                
                Picker("How often do you work out a week:", selection: $selectedActivityIndex) {
                    ForEach(0..<9, id: \.self) { times in
                        if(times < 8){
                            Text("\(times) times")
                        }
                        else{
                            Text("Physical labor / Working out")
                        }
                        
                    }
                }
                .pickerStyle(.automatic)
                
                Picker("Protein Goal:", selection: $selectedProteinGoalIndex){
                    ForEach(0..<proteinGoals.count, id: \.self){ index in
                        Text(proteinGoals[index])
                    }
                }
                
                Picker("Weight Goal:", selection: $selectedDietGoalsIndex){
                    ForEach(0..<dietGoals.count, id: \.self){ index in
                        Text(dietGoals[index])
                    }
                }
                
                //Text("Reccommended Calories: \(recCals, specifier: "%.1f")")
//                ( BMRMale * TDEE ) + Double(dietingCalories[selectedDietGoalsIndex])
                Text("Reccommended Calories:\n\(recCals + -Double(dietingCalories[selectedDietGoalsIndex]), specifier: "%.1f") + \(Double(dietingCalories[selectedDietGoalsIndex]), specifier: "%.1f") = \(recCals, specifier: "%.1f")")
                
                Text("Reccommended Protein: \(recProtein, specifier: "%.1f") grams")
                
                Button("Save") {
                    dayManager.selectedDay.proteinIntake = Double(recProtein)
                    dayManager.selectedDay.calorieIntake = Double(recCals)
                    UserDefaults.standard.set(recProtein, forKey: "proteinIntake")
                    UserDefaults.standard.set(recCals, forKey: "calorieIntake")
                    UserDefaults.standard.set(weight, forKey: "weight")
                    UserDefaults.standard.set(gender, forKey: "gender")
                    UserDefaults.standard.set(height, forKey: "height")
                    UserDefaults.standard.set(ageInYears, forKey: "age")
                    UserDefaults.standard.set(selectedActivityIndex, forKey: "selectedActivityIndex")
                    UserDefaults.standard.set(heightUnit, forKey: "heightUnit")
                    UserDefaults.standard.set(weightUnit, forKey: "weightUnit")
                    UserDefaults.standard.set(selectedDietGoalsIndex, forKey: "selectedDietGoalsIndex")
                    UserDefaults.standard.set(selectedProteinGoalIndex, forKey: "selectedProteinGoalIndex")
                    
                    dayManager.updateSelectedDay()
//                    print("Protein Intake: \(dayManager.selectedDay.proteinIntake)")
//                    print("Calorie Intake: \(dayManager.selectedDay.calorieIntake)")
                    dismiss()
                }
                .padding()
            }
        }
        .padding()
        .onChange(of: proteinIntake) { old, new in
            UserDefaults.standard.set(new, forKey: "proteinIntake")
        }
        .onChange(of: calorieIntake) { old, new in
            UserDefaults.standard.set(new, forKey: "calorieIntake")
        }
    }
}

#Preview {
    proteinView(dayManager: DayManager())
}
