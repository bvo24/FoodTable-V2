//
//  proteinView.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/4/24.
//

import SwiftUI

struct proteinView: View {
    @ObservedObject var dayManager: DayManager
    @State private var proteinIntake: Int = UserDefaults.standard.integer(forKey: "proteinIntake")
    @State private var calorieIntake: Int = UserDefaults.standard.integer(forKey: "calorieIntake")
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("Enter your total protein intake")
                .font(.headline)
            
            TextField("Protein intake", value: $proteinIntake, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            Text("Enter your total calorie intake")
                .font(.headline)
                .padding(.top)
            
            TextField("Calorie intake", value: $calorieIntake, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            Button("Save") {
                dayManager.selectedDay.proteinIntake = Double(proteinIntake)
                dayManager.selectedDay.calorieIntake = Double(calorieIntake)
                UserDefaults.standard.set(proteinIntake, forKey: "proteinIntake")
                UserDefaults.standard.set(calorieIntake, forKey: "calorieIntake")
                dayManager.updateSelectedDay()
                print("Protein Intake: \(dayManager.selectedDay.proteinIntake)")
                print("Calorie Intake: \(dayManager.selectedDay.calorieIntake)")
                dismiss()
            }
            .padding()
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
