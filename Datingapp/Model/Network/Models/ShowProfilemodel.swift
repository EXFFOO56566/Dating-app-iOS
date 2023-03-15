//
//  ShowProfilemodel.swift
//  QuickDate
//
//  Created by Muhammad Haris Butt on 9/21/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import Foundation

struct ShowUserProfileModel {
    let id, online, lastseen: Int?
    let username: String?
    let avater: String?
    let country, firstName, lastName: String?
    let location: String?
    let birthday: String?
    let language: String?
    let relationship: Int?
    let height: String?
    let body, smoke, ethnicity, pets: Int?
    let gender: String?
    let countryText: String?
    let relationshipText, bodyText, smokeText, ethnicityText: String?
    let petsText: String?
    let genderText: String?
    let about: String?
    var isFriend: Bool?
    var isFavourite: Bool?
    var is_friend_request: Bool?

}
