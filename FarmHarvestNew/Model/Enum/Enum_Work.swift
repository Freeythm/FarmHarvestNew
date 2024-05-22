//
//  Enum_Work.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import Foundation
import SwiftUI

enum Work: String, CaseIterable, Codable {
    case havests = "収穫数"
    case fertilizer = "肥料"
    case woodVinegar = "木酢"
    case water = "水やり"
    
    var icon: String {
        switch self {
        case .havests:
            return "gift.circle.fill"
        case .fertilizer:
            return "bag.circle.fill"
        case .woodVinegar:
            return "tree.circle.fill"
        case .water:
            return "drop.circle.fill"
        }
    }
    
    var iconImg: String {
        switch self {
        case .havests:
            return "Ex1"
        case .fertilizer:
            return "Ex2"
        case .woodVinegar:
            return "Ex3"
        case .water:
            return "Ex4"
        }
    }
    
    var unit: String {
        switch self {
        case .havests:
            return "個"
        case .fertilizer, .woodVinegar, .water:
            return "回"
        }
    }
}
