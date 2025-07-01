//
//  SettingsViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//

import Foundation
import InjectPropertyWrapper

protocol SettingsViewModelProtocol: ObservableObject {
    
}

class SettingsViewModel: SettingsViewModelProtocol {
    @Published var selectedLanguage: String = Bundle.getLangCode()
    
    private let themeKey = "color-scheme"
    
    @Inject
    private var appVersionProvider: AppVersionProviderProtocol
    
    @Published var appInfo: String = ""
    
    @Published var selectedTheme: Theme{
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
        }
    }
    
    init(){
        let storedTheme = UserDefaults.standard.string(forKey: themeKey)
        self.selectedTheme = Theme(rawValue: storedTheme ?? "") ?? .light
        
        appInfo = appVersionProvider.version + " (" + appVersionProvider.build + ")"
    }
    
    func changeSelectedLanguge(_ language: String) {
            self.selectedLanguage = language
            Bundle.setLanguage(lang: language)
        }
        
    
    func changeTheme(_ theme: Theme) {
        self.selectedTheme = theme
    }

}
