//
//  ContentView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper


struct GenreSectionView: View {
    
    @StateObject
    private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .topTrailing){
                HStack{
                    Spacer()
                    VStack{
                        Image(.circle)
                            .ignoresSafeArea(edges: .top)
                        Spacer()
                    }
                }
                List(viewModel.genres){ genre in
                    ZStack{
                        NavigationLink(destination: MovieListView(genre: genre)){
                            EmptyView()
                        }
                        .opacity(0)
                        
                        GenreSectionCell(genre: genre)
                    }
                    .background(Color.clear)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 20) {
                                ForEach(0..<10) {
                                    Text("Item \($0)")
                                        .foregroundStyle(.white)
                                        .font(.largeTitle)
                                        .frame(width: 150, height: 150)
                                        .background(.gray)
                                }
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                }
                .accessibilityLabel("testCollectionView")
                .listStyle(.plain)
                .navigationTitle(Environment.name == .tv ? "TV app":"genreSection.title")
                .background(Color.clear)
                .padding(.bottom,LayoutConst.largePadding)
            }
            .listStyle(.plain)
        }
        .alert(item: $viewModel.alertModel){ model in
            return Alert(
                title: Text(LocalizedStringKey(model.title)),
                message: Text(LocalizedStringKey(model.message)),
                dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))){
                    viewModel.alertModel = nil
                }
            )
        }
        
        
    }
}


#Preview {
    GenreSectionView()
}
