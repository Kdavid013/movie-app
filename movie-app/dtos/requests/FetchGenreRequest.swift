//
//  Untitled.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 12..
//

import Foundation

struct FetchGenreRequest: LocalizedRequestable{
    let accessToken: String = Config.bearerToken
    
    func asRequestParams() -> [String: String] {
        return languageParam
    }
}

protocol LocalizedRequestable{
    var languageParam: [String: String]{ get
       
    }
}

extension LocalizedRequestable{
    var languageParam: [String: String]{
        return ["language": Bundle.getLangCode()]
    }
}

func + (lhs: [String: Any], rhs: [String: Any]) -> [String: Any] {
    var result = lhs
    rhs.forEach { result[$0.key] = $0.value }
    return result
}
