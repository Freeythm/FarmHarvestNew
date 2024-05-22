//
//  ListView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

struct ListView: View {
    @Environment(FarmViewModel.self) private var vm
  
    @State private var seedIndex: Int = 0
    @State private var selectWork: Work = .havests
    @State private var workIndex: Int = 0
    
    @State private var monthText: String = "全月"
    @State private var isMonth: Bool = false
    @State private var isDelete: Bool = false
    @State private var farmID: String = ""
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            VStack(alignment: .leading) {
                NameTextHParts(vm.vege.listImg,  kinds: vm.vege.rawValue, 
                               vm.vege.vegeName, vm.vege.darkColor)
                    .offset(y: 20)
                
                HeadButtonView()
                TitleView()
                
                ScrollView {
                    
                    if vm.farmModel.filter({ $0.pages == .home }).isEmpty || FilterFarm().count == 0 {
                        ContentUnavailableView("No Data", systemImage: "tray.full.fill")
                            .foregroundStyle(.textGray.opacity(0.5))
                            .padding(.top, 100)
                    } else {
                        ForEach(FilterFarm().reversed(), id: \.self) { value in
                            Button {
                                self.isDelete.toggle()
                                self.farmID = value.id
                            } label: {
                                ListCellView(farm: value, index: vm.indexOf(farm: value))
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 190)
            
            if !vm.farmModel.isEmpty && selectWork == .havests {
                echoTotalView()
                    .padding(.bottom, 115)
            }
        }
        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .topLeading)
    }
    
    // MARK: VIEWBULDER ------------------------------------------------
    // HeadButtonView ...............
    @ViewBuilder
    private func HeadButtonView() -> some View {
        VStack {
            HStack {
                ForEach(Array(vm.vege.seedlingIcon.enumerated()), id: \.offset) { i, seed in
                    Button {
                        withAnimation(.spring(blendDuration: 0.5)) {
                            self.seedIndex = i
                        }
                    } label: {
                        ButtonHeadParts(icon: seed, i == seedIndex ? .buttonBrown : .buttonBrown.opacity(0.5))
                    }
                }
            }

            HStack {
                ForEach(Array(Work.allCases.enumerated()), id: \.offset) { i, work in
                    Button {
                        withAnimation(.spring(blendDuration: 0.5)) {
                            self.selectWork = work
                            self.workIndex = i
                        }
                    } label: {
                        ButtonHeadTextParts(text: work.rawValue, i == workIndex ? .buttonBrown : .buttonBrown.opacity(0.5))
                    }
                }
            }
        }
    }
    
    // TitleView ...............
    @ViewBuilder
    private func TitleView() -> some View {

        HStack(spacing: 3) {
            Image(systemName: vm.vege.seedlingIcon[seedIndex])
                .imageScale(.medium)
                .foregroundStyle(vm.vege.darkColor)

            IconTextParts(vm.work.iconImg, "\(selectWork.rawValue) - \(FilterFarm().count)件", .textGray)

            Spacer()
            
            if !vm.farmModel.isEmpty {
                GrayTextParts(monthText != "全月" ? "\(self.monthText)" : "", .callout)
                    .padding(.trailing, 10)
                
                Menu {
                    // Picker Month .................................
                    ForEach(0..<vm.addMonth.count, id: \.self) { index in
                        Button {
                            monthText = vm.addMonth[index]
                        } label: {
                            Text(vm.addMonth[index])
                        }
                    }
                } label: {
                    ButtonParts(icon: "calendar.circle.fill", width: 100, height: 30)
                }
            }
        }
        .foregroundStyle(.textGray)
        .padding(.top, 10)
    }
    
    // ListCellView ...............
    @ViewBuilder
    private func ListCellView(farm: Farm, index: Int) -> some View {
        HStack {
            Image(systemName: vm.vege.seedlingIcon[seedIndex])
                .foregroundStyle(vm.vege.backColor)
            GrayTextParts(farm.timeStamp.formatted(date: .numeric, time: .shortened), .caption2)

            Spacer()

            if selectWork == .havests {
                HStack {
                    GrayTextParts("\(farm.harvestCount)", .system(size: 20, weight: .heavy, design: .rounded))
                    GrayTextParts(vm.vege.unitText, .caption)
                }
            } else {
                HStack {
                    GrayTextParts(farm.weighing, .system(size: 20, weight: .heavy, design: .rounded))
                    GrayTextParts("杯", .caption)
                }
            }
            
            if isDelete && farm.id == farmID {
                Button {
                    withAnimation(.bouncy) {
                        vm.removeItem(index)
                        Task {
                            try await vm.Fecth()
                        }
                    }
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(.buttonBrown)
                }
            }
        }
        .padding()
        .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 15))
    }
    
    // echoTotalView ...............
    @ViewBuilder
    private func echoTotalView() -> some View {

        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(vm.vege.backColor, lineWidth: 6.0)
                .fill(.white)
                .frame(height: 50)
            
            HStack(spacing: 10) {
                RoundTextParts("合計")
                //Spacer()
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    CountTextParts(count: echoTotalCount(), unit: vm.vege.unitText)
                    GrayTextParts("/")
                    CountTextParts(count: vm.vege.goalCount, unit: vm.vege.unitText)
                }
                .frame(width: 110)
             
                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("達成率:\(String(format: "%.1f", rateNumbers()))%")
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .frame(width: 130)
                .background(vm.vege.backColor, in: RoundedRectangle(cornerRadius: 5))
            }
            .padding(.horizontal, 10).padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    // MARK: FUNCTION ------------------------------------------------
    // FilterFame ...............
    func FilterFarm() -> [Farm] {
        
        let month = monthText.prefix(1)
        
        if seedIndex != 0 {
            if month != "全" {
                return vm.farmModel.filter{ $0.category == vm.vege &&  $0.seedNum == seedIndex && $0.pages != .cash && $0.works == selectWork && vm.calendar.component(.month, from: $0.timeStamp) == Int(month) }
            } else {
                return vm.farmModel.filter{ $0.category == vm.vege &&  $0.seedNum == seedIndex && $0.pages != .cash && $0.works == selectWork }
            }
            
        } else {
            if month != "全" {
                return vm.farmModel.filter{ $0.category == vm.vege && $0.works == selectWork && $0.pages != .cash && vm.calendar.component(.month, from: $0.timeStamp) == Int(month) }
            } else {
                return vm.farmModel.filter{ $0.category == vm.vege && $0.works == selectWork && $0.pages != .cash }
            }
        }
    }
    
    // echoTotalCount ...............
    func echoTotalCount() -> Int {
        if seedIndex != 0 {
            return vm.farmModel.filter{ $0.category == vm.vege &&  $0.seedNum == seedIndex && $0.works == selectWork  }.map{ $0.harvestCount }.reduce(0, +)
        } else {
            return vm.farmModel.filter{ $0.category == vm.vege && $0.works == selectWork }.map{ $0.harvestCount }.reduce(0, +)
        }
    }
    
    // rateNumber ...............
    func rateNumbers() -> Double {
        let echo: Double = Double(echoTotalCount())
        let goal: Double = Double(vm.vege.goalCount)
        return (echo / goal) * 100
    }
}

#Preview {
    ListView()
        .environment(FarmViewModel())
        .modelContainer(for: [Farm.self, NewPayments.self], inMemory: true)
}
