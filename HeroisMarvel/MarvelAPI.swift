//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Herrison Feres on 26/05/22.
//  Copyright © 2022 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {

    static private var basePath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "237f3f349646b39c850cb370126acc8c71c80a8e"
    static private let publicKey = "9607f3f7d4b04e83211335a27fbf2de1"
    static private let limit = 50
    
    class func loadHeros(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        let startsWith: String
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        }else {
            startsWith = ""
        }
        
        let url = basePath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        
        AF.request(url).responseJSON { response in
            guard let data = response.data else {
                onComplete(nil)
                return
            }
            
            do{
                let marvelInfo = try JSONDecoder().decode(MarvelInfo.self, from: data)
                onComplete(marvelInfo)
                
            }catch{
                print(error.localizedDescription)
                onComplete(nil)
            }
        
        }
    }

    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
    
}
