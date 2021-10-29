//
//  SwiftUI_StateRestoration_transcribeApp.swift
//  SwiftUI-StateRestoration-transcribe
//
//  Created by kazunori.aoki on 2021/10/29.
//

import SwiftUI

// res: https://developer.apple.com/documentation/uikit/view_controllers/restoring_your_app_s_state_with_swiftui

@main
struct StateRestorationApp: App {
    private var productsModel = ProductsModel()
    var body: some Scene {
        WindowGroup("Products", id: "Products.viewer") {
            ContentView()
                .environmentObject(productsModel)
        }
    }
}
