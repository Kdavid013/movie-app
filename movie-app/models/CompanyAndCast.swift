//
//  Company.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 11..
//
import Foundation



struct CompanyAndCast: Identifiable, Hashable, Equatable {
    let id: Int
    let imageUrl: URL?
    let name: String
    
    init()
    {
        self.id = 0
        self.name = ""
        self.imageUrl = nil
    }
    
    init(id: Int, name: String, imageUrl: URL? = nil) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    
    init(dto: CompanyResponse){
        
        var imageUrl: URL?{
            dto.logoPath.flatMap{
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.name = dto.name
        self.imageUrl = imageUrl
        print("<<<DEBUG ",self)
    }
    
    init(dto: CastResponse){
        
        var imageUrl: URL?{
            dto.logoPath.flatMap{
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.name = dto.name
        self.imageUrl = imageUrl
        print("<<<DEBUG ",self)
    }
    
}
