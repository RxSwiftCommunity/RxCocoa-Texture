//
//  User.swift
//
//  Created by Geektree0101.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RxCocoa_Texture

class User: Decodable {
    var username: String = ""
    var profileURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case profileURL = "avatar_url"
    }
    
    func merge(_ user: User?) {
        guard let user = user else { return }
        self.username = user.username
        self.profileURL = user.profileURL
    }
}
