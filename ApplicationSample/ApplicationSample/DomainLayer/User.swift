//
//  User.swift
//  ApplicationSample
//
//  Created by Murali on 19/01/26.
//

import Foundation

struct User:Codable,Identifiable {
    var name:String
    var id:Int
    var email:String
}
