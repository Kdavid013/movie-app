//
//  LanguageManager.swift
//  movie-app
//
//  Created by David Karacs on 2025. 07. 01..
//

import Foundation

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var currentLanguage: String = Bundle.getLangCode()

    func setLanguage(_ lang: String) {
        guard lang != currentLanguage else { return }
        Bundle.setLanguage(lang: lang)
        UserDefaults.standard.set(lang, forKey: "app_lang")
        currentLanguage = lang
    }
}
