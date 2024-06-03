//
//  Section.swift
//  DemoNew
//
//  Created by 吴伟 on 6/3/24.
//

import Foundation

// Section and Item definitions for Diffable Data Source
enum Section {
    case main
}

enum Item: Hashable {
    case avatar
    case firstName
    case lastName
    case phone
    case email
    case selectColor
}
