//
//  User.swift
//  TwitterLite
//
//  Created by Yili Aiwazian on 9/26/14.
//  Copyright (c) 2014 Yili Aiwazian. All rights reserved.
//

import Foundation

class User {
    
    var dictionaryReference: NSDictionary?
    var following: Bool?
    var userId: Int?
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    
    init(dictionary: NSDictionary) {
        
    }
    
}