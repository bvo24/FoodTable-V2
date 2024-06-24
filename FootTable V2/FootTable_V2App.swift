//
//  FootTable_V2App.swift
//  FootTable V2
//
//  Created by Brian Vo on 5/28/24.
//

import SwiftUI

@main




struct FootTable_V2App: App {
    
//    init() {
//        let appear = UINavigationBarAppearance()
//
//        let atters: [NSAttributedString.Key: Any] = [
//            .font: UIFont(name: "PixelifySans-Regular", size: 16)!
//        ]
//        appear.largeTitleTextAttributes = atters
//        appear.titleTextAttributes = atters
//        UINavigationBar.appearance().standardAppearance = appear
//        UINavigationBar.appearance().compactAppearance = appear
//        UINavigationBar.appearance().scrollEdgeAppearance = appear
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "PixelifySans-Regular", size: 15)! ], for: .normal)
////        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "PixelifySans-Regular", size: 20)!]
//        
//        
//            UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "PixelifySans-Regular", size: 20)!]
//     }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                //Default font
                .environment(\.font, Font.custom("PixelifySans-Regular", size: 16))
        }
    }
}
