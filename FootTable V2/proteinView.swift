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
    
    static let TDEES = [1.2, 1.375, 1.55, 1.725, 1.9]
    @State private var TDEE = TDEES[0]
//    @State private var weightInPoundsUD : Int? = UserDefaults.standard.integer(forKey: "weight")
//    @State private var genderUD = UserDefaults.standard.string(forKey: "gender")
//    @State private var heightInInchesUD = UserDefaults.standard.integer(forKey: "height")
//    @State private var ageInYearsUD = UserDefaults.standard.integer(forKey: "age")
//    
//    @State private var gender = UserDefaults.standard.string(forKey: "gender") ?? "Male"
//    @State private var weightInPounds =
//    @State private var heightInInches = "0"
//    @State private var ageInYears = "0"
    
    @State private var weightInPounds: String = UserDefaults.standard.string(forKey: "weight") ?? "0"
    @State private var gender: String = UserDefaults.standard.string(forKey: "gender") ?? "Male"
    @State private var heightInInches: String = UserDefaults.standard.string(forKey: "height") ?? "0"
    @State private var ageInYears: String = UserDefaults.standard.string(forKey: "age") ?? "0"
    
    @State private var selectedActivityIndex: Int = UserDefaults.standard.integer(forKey: "selectedActivityIndex")
    
    
    let activeStatus = ["Average", "Active", "Body Builder"]
    let recProteinPerLb = [0.4, 0.6, 0.9]
//    @State private var selectedActivityIndex = 0
    var proteinPerLb : Double {
        
        recProteinPerLb[ selectedActivityIndex]
    }
    

//    Sedentary (little or no exercise): BMR x 1.2
//    Lightly active (light exercise/sports 1-3 days/week): BMR x 1.375
//    Moderately active (moderate exercise/sports 3-5 days/week): BMR x 1.55
//    Very active (hard exercise/sports 6-7 days a week): BMR x 1.725
//    Extra active (very hard exercise/sports & physical job or 2x training): BMR x 1.9
    
    
    
//    4.536×weight in lbs+15.88×height in inches−5×age in years+5
    var BMRMale: Double {
        guard let weight = Double(weightInPounds), let height = Double(heightInInches), let age = Double(ageInYears) else {
            return 0
        }
        return (4.536 * weight) + (15.88 * height) - (5 * age) + 5
    }

    var BMRFemale: Double {
        guard let weight = Double(weightInPounds), let height = Double(heightInInches), let age = Double(ageInYears) else {
            return 0
        }
        return (4.536 * weight) + (15.88 * height) - (5 * age) - 161
    }

    var recCals: Double {
        if gender == "Male" {
            return BMRMale * TDEE
        } else {
            return BMRFemale * TDEE
        }
    }

    var recProtein: Double {
        guard let weight = Double(weightInPounds) else {
            return 0
        }
        return weight * recProteinPerLb[ selectedActivityIndex]
    }

    
    
    
//    Sedentary (little or no exercise): BMR x 1.2
//    Lightly active (light exercise/sports 1-3 days/week): BMR x 1.375
//    Moderately active (moderate exercise/sports 3-5 days/week): BMR x 1.55
//    Very active (hard exercise/sports 6-7 days a week): BMR x 1.725
//    Extra active (very hard exercise/sports & physical job or 2x training): BMR x 1.9
    
    let TDEES = [1.2, 1.375, 1.55, 1.725, 1.9]
    
    
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
                Picker("Select your gender", selection: $gender){
                    ForEach(genders, id: \.self){ gender in
                        Text(gender)
                    }
                }
                HStack{
                    Text("Age")
                    TextField("Enter your age", text: $ageInYears)
                }
                HStack{
                    Text("Height")
                    TextField("Enter your height", text: $heightInInches)
                }
                HStack{
                    Text("Weight")
                    TextField("Enter your weight", text: $weightInPounds)
                }
                
                Picker("Select your actvity status", selection: $selectedActivityIndex){
                    ForEach(0..<activeStatus.count, id: \.self){ index in
                        Text(activeStatus[index])
                    }
                }
                
                Text("Reccommended Calories \(recCals)")
                Text("Reccommended Protein \(recProtein)")
                
                Button("Save") {
                    dayManager.selectedDay.proteinIntake = Double(recProtein)
                    dayManager.selectedDay.calorieIntake = Double(recCals)
                    UserDefaults.standard.set(recProtein, forKey: "proteinIntake")
                    UserDefaults.standard.set(recCals, forKey: "calorieIntake")
                    UserDefaults.standard.set(weightInPounds, forKey: "weight")
                    UserDefaults.standard.set(gender, forKey: "gender")
                    UserDefaults.standard.set(heightInInches, forKey: "height")
                    UserDefaults.standard.set(ageInYears, forKey: "age")
                    UserDefaults.standard.set(selectedActivityIndex, forKey: "selectedActivityIndex")
                    
                    
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
