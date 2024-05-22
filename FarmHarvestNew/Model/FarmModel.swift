//
//  FarmModel.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

@Model
class Farm {
    var id = UUID().uuidString
    var timeStamp: Date
    var category: Vegetables
    var works: Work
    var pages: Pages
    var seedNum: Int
    var harvestCount: Int
    var weighing: String
    @Relationship(inverse: \NewPayments.farm) var payment: [NewPayments]

    init(id: String = UUID().uuidString, timeStamp: Date, category: Vegetables, works: Work, pages: Pages, seedNum: Int, harvestCount: Int, weighing: String, payment: [NewPayments]) {
        self.id = id
        self.timeStamp = timeStamp
        self.category = category
        self.works = works
        self.pages = pages
        self.seedNum = seedNum
        self.harvestCount = harvestCount
        self.weighing = weighing
        self.payment = payment
    }
}

@Model
final class NewPayments {
    var item: String
    var price: Int
    var farm: [Farm]
    
    init(item: String, price: Int, farm: [Farm]) {
        self.item = item
        self.price = price
        self.farm = farm
    }
}

