//
//  CustomNavigationBar.swift
//  FootTable V2
//
//  Created by Brian Vo on 6/19/24.
//
//Changes the color of tha nav bar
import Foundation
import SwiftUI

struct CustomNavigationBar: UIViewControllerRepresentable {
    var backgroundColor: UIColor
    var titleColor: UIColor

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
