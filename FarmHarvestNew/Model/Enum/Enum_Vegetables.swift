//
//  Enum_Vegetables.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

enum Vegetables: String, CaseIterable, Codable {
    case tomato = "Tomato"
    case cucumber = "Kyuri"
    case pi_man = "Pi-man"
    case nasu = "Nasu"
    
    // MARK: TEXT ---------------
    var vegeName: String {
        switch self {
        case .tomato:
            return "桃太郎"
        case .cucumber:
            return "夏秋節成/ピノキオ"
        case .pi_man:
            return "ニューエース"
        case .nasu:
            return "水茄子"
        }
    }
    
    var unitText: String {
        switch self {
        case .tomato, .pi_man:
            return "個"
        case .cucumber, .nasu:
            return "本"
        }
    }
    
    var seedlingIcon: [String] {
        switch self {
        case .tomato, .cucumber:
            return ["a.circle.fill", "1.circle.fill", "2.circle.fill", "3.circle.fill"]
        case .pi_man, .nasu:
            return ["a.circle.fill", "1.circle.fill", "2.circle.fill"]
        }
    }
    
    // MARK: COUNT -------------
    var seedlingCount: Int {
        switch self {
        case .tomato, .cucumber:
            return 3
        case .pi_man, .nasu:
            return 2
        }
    }
    
    var goalCount: Int {
        switch self {
        case .tomato:
            return 36
        case .cucumber:
            return 60
        case .pi_man:
            return 100
        case .nasu:
            return 50
        }
    }
    
    var tanka: Int {
        switch self {
        case .tomato:
            return 97
        case .cucumber:
            return 57
        case .pi_man:
            return 32
        case .nasu:
            return 59
        }
    }
    
    
    // MARK: IMAGE --------------
    var TabImg: String {
        switch self {
        case .tomato:
            return "Tab01"
        case .cucumber:
            return "Tab02"
        case .pi_man:
            return "Tab03"
        case .nasu:
            return "Tab04"
        }
    }
    
    var backImg: String {
        switch self {
        case .tomato:
            return "Vegetable01"
        case .cucumber:
            return "Vegetable02"
        case .pi_man:
            return "Vegetable03"
        case .nasu:
            return "Vegetable04"
        }
    }
    
    var listImg: String {
        switch self {
        case .tomato:
            return "Icon1"
        case .cucumber:
            return "Icon2"
        case .pi_man:
            return "Icon3"
        case .nasu:
            return "Icon4"
        }
    }
    
    // MARK: COLOR -------------------
    var backColor: Color {
        switch self {
        case .tomato:
            return .thinRed
        case .cucumber:
            return .thinGreen
        case .nasu:
            return .thinPurple
        case .pi_man:
            return .thinPGreen
        }
    }
    
    var darkColor: Color {
        switch self {
        case .tomato:
            return .darkRed
        case .cucumber:
            return .darkGreen
        case .nasu:
            return .darkPurple
        case .pi_man:
            return .darkPGreen
        }
    }
    
    var gradColor: LinearGradient {
        switch self {
        case .tomato:
            return LinearGradient(colors: [.white.opacity(0.8), .darkRed], startPoint: .leading, endPoint: .trailing)
        case .cucumber, .pi_man:
            return LinearGradient(colors: [.white.opacity(0.8), .darkGreen], startPoint: .leading, endPoint: .trailing)
        case .nasu:
            return LinearGradient(colors: [.white.opacity(0.8), .darkPurple], startPoint: .leading, endPoint: .trailing)
        }
    }
}
