//
//  SettingsViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//

import Foundation
import SwiftUI

protocol SettingsViewModelProtocol: ObservableObject {
    
}

class SettingsViewModel: SettingsViewModelProtocol {
//    @Published var selectedLanguage: String = Bundle.getLangCode()
    @Published var selectedTheme: ColorScheme = .light
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = "light"
    
    init(){
        self.selectedTheme = ColorScheme(colorSchemeRawValue)
    }
    
    func changeSelectedLanguage(_ language: String) {
//        self.selectedLanguage = language
        Bundle.setLanguage(lang: language)
    }
    
    func changeTheme(_ theme: ColorScheme) {
        self.selectedTheme = theme
        colorSchemeRawValue = theme == .dark ? "dark" : "light"
    }

}
extension ColorScheme {
    var RawValue: String {
        self == .dark ? "dark" : "light"
    }
    
    init (_ rawValue: String) {
        self = rawValue == "dark" ? .dark : .light
    }
}
