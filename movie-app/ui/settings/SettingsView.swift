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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing){
                RightCornerCircle()
                VStack(alignment: .leading) {
                    Text("settings.chooseLanguage".localized())
                        .font(Fonts.subheading)
                        .padding(.bottom, LayoutConst.maxPadding)
                    HStack(spacing: 12) {
                        ButtonLabel(style: viewModel.selectedLanguage == "en" ? .filled : .outlined, title: "settings.lang.english".localized(), action: .simple)
                            .font(Fonts.detailsButton)
                            .onTapGesture {
                                viewModel.changeSelectedLanguge("en")
                                
                            }
                        ButtonLabel(style: viewModel.selectedLanguage == "de" ? .filled : .outlined, title: "settings.lang.german".localized(), action: .simple)
                            .font(Fonts.detailsButton)
                            .onTapGesture {
                                viewModel.changeSelectedLanguge("de")
                            }
                        ButtonLabel(style: viewModel.selectedLanguage == "hu" ? .filled : .outlined, title: "settings.lang.hungarian".localized(), action: .simple)
                            .font(Fonts.detailsButton)
                            .onTapGesture {
                                viewModel.changeSelectedLanguge("hu")
                            }
                    }
                    .padding(.bottom, 43)
                    
                    Text("settings.chooseTheme".localized())
                        .font(Fonts.subheading)
                        .padding(.bottom, LayoutConst.maxPadding)
                    HStack(spacing: 12) {
                        ButtonLabel(style: viewModel.selectedTheme == .light ? .filled : .outlined, title: "settings.theme.light".localized(), action: .simple)
                            .font(Fonts.detailsButton)
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                viewModel.changeTheme(.light)
                            }
                        ButtonLabel(style: viewModel.selectedTheme == .dark ? .filled : .outlined, title: "settings.theme.dark".localized(), action: .simple)
                            .font(Fonts.detailsButton)
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
                        Text("version".localized() + ": \(viewModel.appInfo)")
                        Text("created".localized())
                    }
                    .font(Fonts.subheading)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 66)
                }
                .padding(LayoutConst.maxPadding)
                .navigationTitle("settings.title".localized())
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
