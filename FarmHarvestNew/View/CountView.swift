//
//  CountView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

struct CountView: View {
    @Environment(FarmViewModel.self) private var vm
     
    @Binding var dayCount: Int
    @Binding var weigh: Double
    @Binding var isSlider: Bool
    @State private var seedNo: Int = 0
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ForEach(Array(Work.allCases.enumerated()), id:\.offset) { i, section in
                Section {
                    HStack {
                        if i == 0 {
                            ForEach(Array(vm.harvest.enumerated()), id:\.offset) { i, item in
                                HarvestView(count: item, seedNo: i + 1, work: .havests)
                            }
                        }

                        if i == 1 {
                            ForEach(Array(vm.fertlizer.enumerated()), id: \.offset) { i, item in
                               WorkView(ex: vm.fertlElapsed[i], 
                                        count: item, seedNo: i + 1, work: .fertilizer)
                            }
                        }

                        if i == 2 {
                            ForEach(Array(vm.woodVinegar.enumerated()), id: \.offset) { i, item in
                                WorkView(ex: vm.woodElapsed[i],
                                         count: item, seedNo: i + 1, work: .woodVinegar)
                            }
                        }

                        if i == 3 {
                            ForEach(Array(vm.water.enumerated()), id: \.offset) { i, item in
                                WorkView(ex: vm.waterElapsed[i],
                                         count: item, seedNo: i + 1, work: .water)
                            }
                        }
                    }
                } header: {
                    IconTextParts(section.iconImg, section.rawValue, .textGray)
                        .padding(.bottom, -5).padding(.top, 5)
                }
            }
            .task {
                do {
                    try await vm.Fecth()
                    try await vm.AllCount()
                } catch {
                    print(error.localizedDescription)
                }
            }
            .sheet(isPresented: $isSlider) {
                SliderView()
                    .presentationDetents([.height(170)])
            }
        }
    }
    
    // MARK: HarvestView ----------
    @ViewBuilder
    func HarvestView(count: Int, seedNo: Int, work: Work) -> some View {
        
        ZStack {
            RoundBackParts(radius: 5)

            HStack {
                CountTextParts(count: count, unit: vm.vege.unitText)

                Spacer()

                Menu {
                    ForEach(1..<9, id:\.self) { i in
                        Button {
                            if i != 0 {
                                let saveItems = Farm(timeStamp: .now, category: vm.vege,
                                                     works: .havests, pages: .home, seedNum: seedNo,
                                                     harvestCount: i, weighing: "0.0",
                                                     payment: [])
                                self.vm.saveItem(model: saveItems)
                                
                                Task {
                                    try await vm.Fecth()
                                    try await vm.harvestTotalCount()
                                    try await vm.harvestCount()
                                }
                            }
                            
                        } label: {
                            Text("\(i)")
                        }
                    }
                } label: {
                    ButtonParts(width: 30)
                }
            }
            .padding(.vertical, 15).padding(.horizontal, 10)
        }
    }
    
    // MARK: WorkView ----------
    @ViewBuilder
    func WorkView(ex: Int, count: Int, seedNo: Int, work: Work) -> some View {
    
        ZStack(alignment: .leading) {
            RoundBackParts(radius: 5)
    
            VStack {
                HStack(alignment: .center) {
                    MemoProgressParts(text: "\(ex)",
                                      color: vm.vege.backColor, textColor: vm.vege.darkColor)
                }
                
                HStack {
                    GrayTextParts("\(count)回目")
    
                    Spacer()
    
                    Button {
                        self.isSlider = true
                        vm.work = work
                        self.seedNo = seedNo
                        
                    } label: {
                        ButtonParts(width: 30)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
        }
    }
    
    // MARK: SliderView ---------------------------------------------
    @ViewBuilder
    func SliderView() -> some View {
        
        VStack(spacing: 10) {
            
            HStack {
                IconTextParts(vm.work.iconImg, vm.work.rawValue, .textGray)
                IconParts(vm.vege.seedlingIcon[seedNo]).foregroundStyle(vm.vege.darkColor)
                    .padding(.leading, 5)
                Text("[\(String(format: "%.1f", weigh))]").fontWeight(.semibold)
                Spacer()
                
                ForEach(0..<2, id:\.self) { i in
                    Button {
                        if i == 0 {
                            let saveItem = Farm(timeStamp: .now, category: vm.vege,
                                                works: vm.work, pages: .home, seedNum: seedNo, harvestCount: 0,
                                                weighing: String(format: "%.1f", weigh),
                                                payment: [])
                            
                            self.vm.saveItem(model: saveItem)
                            
                            Task {
                                try await vm.Fecth()
                                try await vm.AllCount()
                                weigh = 0.0
                            }
                        }
                        
                        self.isSlider = false
                        
                    } label: {
                        ButtonParts(icon: ["square.and.arrow.down.fill", "arrowtriangle.down"][i],
                                    width: 50, height: 35)
                    }
                }
            }
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(.ultraThinMaterial)
        
            VStack {
                HStack(spacing: 30) {
                    Slider(value: $weigh, in: 0...2) {
                        Text("")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("2")
                    }
                    .font(.caption2)
                }
            }
            .padding(.vertical).padding(.horizontal, 30)
            
            Spacer()
        }
        .foregroundStyle(.textGray)
    }
}

#Preview("CountView") {
    CountView(dayCount: .constant(0), weigh: .constant(0), isSlider: .constant(false))
        .environment(FarmViewModel())
        .modelContainer(for: [Farm.self], inMemory: true)
}
#Preview("HomeView") {
    HomeView()
        .environment(FarmViewModel())
        .modelContainer(for: [Farm.self], inMemory: true)
}
