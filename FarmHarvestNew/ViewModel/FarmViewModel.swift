//
//  FarmViewModel.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

@Observable
class FarmViewModel {
    // MARK: Enum ----------------------------------
    var vege: Vegetables = .tomato
    var work: Work = .havests
    var page: Pages = .home
    
    // MARK: Model ----------------------------------
    var farmModel: [Farm] = []
    var payment: [NewPayments] = []
    
    // MARK: SwiftData --------------------------------
    @ObservationIgnored
    private var source: ItemDataSource  = ItemDataSource.shard

    init(source: ItemDataSource = ItemDataSource.shard) {
        self.source = source
        self.farmModel = source.fetchItems()
        
        Task {
            if !farmModel.isEmpty {
                await AddMonth()
            }
        }
    }

    @MainActor
    func Fecth() async throws {
        self.farmModel = source.fetchItems()
    }

    // SaveItem -----------------------
    func saveItem(model: Farm) {
        source.appendItem(model: model)
    }

    // RemoveItem ---------------------
    func removeItem(_ index: Int) {
        source.removeItem(farmModel[index])
    }
    
    // CellIndex --------------------------------------------
    func indexOf(farm: Farm) -> Int {
        let index = farmModel.firstIndex { value in
            value == farm
        } ?? 0
        return index
    }
    
    // MARK: Date ----------------------------------
    let calendar = Calendar.current
    var addMonth: [String] = ["全月", "5月", "6月"] {
        didSet {
            UserDefaults.standard.setValue(addMonth, forKey: "MONTH_New")
        }
    }
    
    func AddMonth() async {
        let date1 = Date()
        let date2 = farmModel.map{ $0.timeStamp }.last!
        let month = calendar.component(.month, from: date2)
        
        if addMonth.count == 1 {
            addMonth.append("\(month)月")
        }
        
        
        if !calendar.sameMonth(date1, inSameMonthAs: date2) {
            addMonth.append("\(month)月")
        }
    }
    
    // MARK: Counter --------------------------------
    // TotalCount ...................................
    var totalCount:  Int = 0
    @MainActor
    func harvestTotalCount() async throws {
       self.totalCount = farmModel.filter{ $0.category == vege }.map{ $0.harvestCount }.reduce(0, +)
    }

    @MainActor
    func paymentCount() async throws  -> [Int] {
        return [
            farmModel.filter{ $0.category == .tomato }.map{ $0.harvestCount }.reduce(0, +),
            farmModel.filter{ $0.category == .cucumber }.map{ $0.harvestCount }.reduce(0, +),
            farmModel.filter{ $0.category == .pi_man }.map{ $0.harvestCount }.reduce(0, +),
            farmModel.filter{ $0.category == .nasu }.map{ $0.harvestCount }.reduce(0, +)
       ]
    }

    @MainActor
    func AllCount() async throws {
        do {
            try await harvestCount()
            try await fertilizerCount()
            try await woodVinegarCount()
            try await waterCount()
        } catch {
            print(error)
        }
    }
    
    //  HarvestCount ..............................
    var harvest: [Int] = []
    @MainActor
    func harvestCount() async throws {
        let seed1 = farmModel.filter{ $0.category == vege && $0.seedNum == 1 }.map{ $0.harvestCount }.reduce(0, +)
        let seed2 = farmModel.filter{ $0.category == vege && $0.seedNum == 2 }.map{ $0.harvestCount }.reduce(0, +)

        if vege.seedlingCount == 3 {
            let seed3 = farmModel.filter{ $0.category == vege && $0.seedNum == 3 }.map{ $0.harvestCount }.reduce(0, +)
            harvest = [seed1, seed2, seed3]
        } else {
            harvest = [seed1, seed2]
        }
    }
    
    // fertilizerCount .................................
    var fertlizer: [Int] = []
    var fertlElapsed: [Int] = []
    @MainActor
    func fertilizerCount() async throws {

        let seed1 = farmModel.filter{ $0.category == vege && $0.seedNum == 1 && $0.works == .fertilizer }
        let seed2 = farmModel.filter{ $0.category == vege && $0.seedNum == 2 && $0.works == .fertilizer }
        
        // Count ....................
        let count1 = seed1.count
        let count2 = seed2.count
        
        // Number of days elapsed ........
        // [1]
        var comp1: Int?
        
        if count1 == 0 {
           comp1 = 0
        } else {
            let days1 = seed1.map{ $0.timeStamp }.last!
            comp1 = calendar.dateComponents([.day], from: days1, to: .now).day!
        }
        // [2]
        var comp2: Int?
        
        if count2 == 0 {
            comp2 = 0
        } else {
            let days2 = seed2.map{ $0.timeStamp }.last!
            comp2 = calendar.dateComponents([.day], from: days2, to: .now).day!
        }
        
        if vege.seedlingCount == 3 {
            let seed3 = farmModel.filter{ $0.category == vege && $0.seedNum == 3 && $0.works == .fertilizer }
            let count3 = seed3.count
            fertlizer = [count1, count2, count3]
            
            var comp3: Int?
            
            if count3 == 0 {
                comp3 = 0
            } else {
                let days3 = seed3.map{ $0.timeStamp }.last!
                comp3 = calendar.dateComponents([.day], from: days3, to: .now).day!
            }
        
            fertlElapsed = [comp1!, comp2!, comp3!]
            
        } else {
            fertlizer = [count1, count2]
            fertlElapsed = [comp1!, comp2!]
        }
    }

    // woodVinegarCount .................................
    var woodVinegar: [Int] = []
    var woodElapsed: [Int] = []
    @MainActor
    func woodVinegarCount() async throws {

        // FilterBase ................
        let seed1 = farmModel.filter{ $0.category == vege && $0.seedNum == 1 && $0.works == .woodVinegar }
        let seed2 = farmModel.filter{ $0.category == vege && $0.seedNum == 2 && $0.works == .woodVinegar }
        
        // Count ....................
        let count1 = seed1.count
        let count2 = seed2.count
        
        // Number of days elapsed ........
        // [1]
        var comp1: Int?
        
        if count1 == 0 {
            comp1 = 0
        } else {
            let day1 = seed1.map{ $0.timeStamp }.last!
            comp1 = calendar.dateComponents([.day], from: day1, to: .now).day!
        }
        
        // [2]
        var comp2: Int?
        
        if count2 == 0 {
            comp2 = 0
        } else {
            let day2 = seed2.map{ $0.timeStamp }.last!
            comp2 = calendar.dateComponents([.day], from: day2, to: .now).day!
        }
 
        if vege.seedlingCount == 3 {
            let seed3 = farmModel.filter{ $0.category == vege && $0.seedNum == 3 && $0.works == .woodVinegar }
            let count3 = seed3.count
            
            // [3]
            var comp3: Int?
            
            if count3 == 0 {
                comp3 = 0
            } else {
                let day3 = seed3.map{ $0.timeStamp }.last!
                comp3 = calendar.dateComponents([.day], from: day3, to: .now).day!
            }
            
            woodVinegar = [count1, count2, count3]
            woodElapsed = [comp1!, comp2!, comp3!]
            
        } else {
            woodVinegar = [count1, count2]
            woodElapsed = [comp1!, comp2!]
        }
     }

    // WaterCount ......................................
    var water: [Int] = []
    var waterElapsed: [Int] = []
    @MainActor
    func waterCount() async throws {

        // FilterBase ................
        let seed1 = farmModel.filter{ $0.category == vege && $0.seedNum == 1 && $0.works == .water }
        let seed2 = farmModel.filter{ $0.category == vege && $0.seedNum == 2 && $0.works == .water }
        
        // Count ....................
        let count1 = seed1.count
        let count2 = seed2.count
        
        // Number of days elapsed ........
        // [1]
        var comp1: Int?
        
        if count1 == 0 {
            comp1 = 0
        } else {
            let day1 = seed1.map{ $0.timeStamp }.last!
            comp1 = calendar.dateComponents([.day], from: day1, to: .now).day!
        }
        
        // [2]
        var comp2: Int?
        
        if count2 == 0 {
            comp2 = 0
        } else {
            let day2 = seed2.map{ $0.timeStamp }.last!
            comp2 = calendar.dateComponents([.day], from: day2, to: .now).day!
        }
        
        if vege.seedlingCount == 3 {
            let seed3 = farmModel.filter{ $0.category == vege && $0.seedNum == 3 && $0.works == .water }
            let count3 = seed3.count
            
            // [3]
            var comp3: Int?
            
            if count3 == 0 {
                comp3 = 0
            } else {
                let day3 = seed3.map{ $0.timeStamp }.last!
                comp3 = calendar.dateComponents([.day], from: day3, to: .now).day!
            }
            
            water = [count1, count2, count3]
            waterElapsed = [comp1!, comp2!, comp3!]
            
        } else {
            water = [count1, count2]
            waterElapsed = [comp1!, comp2!]
        }
    }
    
}
