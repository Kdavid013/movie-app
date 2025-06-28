//
//  SettingsView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import SwiftUI
import InjectPropertyWrapper
import FirebaseCrashlytics

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var selectedLanguage: String = "en"
    @State private var selectedTheme: String = "dark"
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("settings.chooseLanguage")
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    ButtonLabel(style: selectedLanguage == "en" ? .filled : .outlined, title: "settings.lang.english", action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            selectedLanguage = "en"
                            
                        }
                    ButtonLabel(style: selectedLanguage == "de" ? .filled : .outlined, title: "settings.lang.german", action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            selectedLanguage = "de"
                        }
                    ButtonLabel(style: selectedLanguage == "hu" ? .filled : .outlined, title: "settings.lang.hungarian", action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .fixedSize()
                        .onTapGesture {
                            selectedLanguage = "hu"
                        }
                }
                .padding(.bottom, 43)
                
                Text("settings.chooseTheme")
                    .font(Fonts.subheading)
                    .padding(.bottom, LayoutConst.maxPadding)
                HStack(spacing: 12) {
                    ButtonLabel(style: viewModel.selectedTheme == .light ? .filled : .outlined, title: "settings.theme.light", action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.changeTheme(.light)
                        }
                    ButtonLabel(style: viewModel.selectedTheme == .dark ? .filled : .outlined, title: "settings.theme.dark", action: .simple)
                        .font(Fonts.detailsButton)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            viewModel.changeTheme(.dark)
                        }
                }
                .padding(.bottom, 43)
                Button("Crash") {
                  fatalError("Crash was triggered")
                }
                Button("Send non fatal error") {
                    Crashlytics.crashlytics().record(error: MovieError.noInternetError)
                    let userInfo = [
                      "View": "SettingsView"
                    ]
                    let testError = NSError.init(domain: NSCocoaErrorDomain,
                                             code: -1001,
                                             userInfo: userInfo)
                    Crashlytics.crashlytics().record(error: testError)
                }
                Spacer()
                VStack(spacing: LayoutConst.smallPadding) {
                    Text("Version \(viewModel.appInfo)")
                    Text("Created by Hell yeah")
                }
                .font(Fonts.subheading)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 66)
            }
            .padding(LayoutConst.maxPadding)
            .navigationTitle("settings.title")
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    SettingsView()
}
