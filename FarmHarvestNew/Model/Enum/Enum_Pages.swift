//
//  Enum_Pages.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import Foundation
import SwiftUI

enum Pages: String, CaseIterable, Codable {
    case home = "Home"
    case list = "Deteil List"
    case cash = "Payments"
  
    var icon: String {
        switch self {
        case .home:
            return "house.and.flag.circle.fill"
        case .list:
            return "list.bullet.circle.fill"
        case .cash:
            return "chineseyuanrenminbisign.circle.fill"
        }
    }
    
    var isPaymant: Bool {
        switch self {
        case .home, .list:
            return false
        case .cash:
            return true
        }
    }
}
