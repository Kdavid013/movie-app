//
//  SearchView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

import SwiftUI
import InjectPropertyWrapper

//protocol SearchViewModelProtocol: @ObservableObject{
//    
//}

class SearchViewModel:  ObservableObject{
    
}

struct SearchView: View {
    
    @StateObject
    private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Image(.search)
                TextField("search.textfield.placeholder", text: .constant(""))
                    .padding([.top,.bottom],21)
                    .font(Fonts.paragraph)
            }
            .padding(.horizontal, 15)
            .background(Color.white.opacity(0.5),in: RoundedRectangle(cornerRadius: 50).stroke(style: StrokeStyle(lineWidth: 2)))
            .background(Color.white.opacity(0.15),in: RoundedRectangle(cornerRadius: 50))
            .padding(.horizontal, 10)
            Spacer()
            Text("search.empty.title")
                .font(Fonts.title)
            Spacer()
        }.padding(10)
        }
    }


#Preview {
    SearchView()
}
