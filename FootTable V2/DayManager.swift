//
//  DayManager.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/29/24.
//


import Foundation
import SwiftUI

class DayManager: ObservableObject {
    @Published var selectedDay: Day
    
    init(selectedDay: Day) {
        self.selectedDay = selectedDay
    }
}
