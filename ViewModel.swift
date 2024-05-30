//
//  ViewModel.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/29/24.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var days: [Day] = []
    @Published var selectedDay: Day?

    init() {
        // Initialize your properties here
        self.days = [] // Initialize days with an empty array initially
        self.selectedDay = nil // Initialize selectedDay as nil initially
    }

    func loadData() {
        // Implement your data loading logic here
        // For example, load data from a network request or local storage
    }
}

