//
//  PaymentsView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

struct PaymentsView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable private var vm = FarmViewModel()
    @State private var payharvest: [Int] = []
    @State private var inComeSubTotal: Int = 0
    @State private var ExSubTotal: Int = 0
    
    @Query var payment: [NewPayments]
    @State private var isNewItem: Bool = false
    @State private var itemStr: String = ""
    @State private var priceStr: String = ""
    @State private var selectWork: Work = .havests
    @State private var isTotal: Bool = true
    @State private var isTrash: Bool = false
    @State private var trashInt: Int = 0
  
    var body: some View {
    
        ZStack(alignment: .bottom) {
            BackGroundView()

            VStack(alignment: .leading, spacing: 30) {
                Button {
                    self.dismiss()
                } label: {
                    CircleButtonParts(icon: "arrowtriangle.down")
                }
                
                NameTextHParts("Payment", kinds: "Payments", "", .textGray)
                    .padding(.top, 20)
                
                ScrollView {
                    // Income ....................................
                    Section {
                        ForEach(Array(payharvest.enumerated()), id: \.offset) { i, count in
                            IncomeCellView(vege: Vegetables.allCases[i], count: count)
                        }
                    } header: {
                        TitleView("chineseyuanrenminbisign.arrow.circlepath", "収入")
                    }
                    
                    // Income Total ......................
                    TotalView(payment: vm.farmModel.isEmpty ? 0 : inComeSubTotal)
                    
                    // Expense ....................................
                    ExpenseTitleView()
                        .padding(.top, 30).padding(.bottom, 3)
                    
                    if vm.farmModel.filter({ $0.pages == .cash }).isEmpty {
                        ContentUnavailableView("No Data", systemImage: "tray.full.fill")
                            .foregroundStyle(.textGray.opacity(0.5))
                    } else {
                        ForEach(Array(vm.farmModel.reversed().enumerated()), id:\.offset) { i, value in
                            ForEach(value.payment, id:\.self) { item in
                                
                                Button {
                                    withAnimation(.easeInOut) {
                                        self.isTrash.toggle()
                                        self.trashInt = vm.indexOf(farm: value)
                                    }
                                } label: {
                                    HStack {
                                        ExpenseCellView(img: value.works.iconImg,
                                                        str: item.item, time: value.timeStamp.formatted(date: .numeric, time: .omitted),
                                                        price: item.price, index: vm.indexOf(farm: value))
                                    }
                                }
                            }
                        }
                        
                        // Expense Total .....................................
                        TotalView(payment: vm.farmModel.isEmpty ? 0 : ExSubTotal)
                    }
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 25)
            
            // AllTotalView ........................
            AllTotalView()
        }
        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment: .leading)
        .task {
            do {
                self.payharvest = try await vm.paymentCount()
            } catch {
                print(error.localizedDescription)
            }
        }
        .sheet(isPresented: $isNewItem) {
            Task {
               try await vm.Fecth()
            }
        } content: {
            NewItemView()
                .presentationDetents([.height(230)])
        }
    }
    
    // MARK: NewItemView ----------------------------------------------
    @ViewBuilder
    func NewItemView() -> some View {
        
        VStack(spacing: 15) {
            
            HStack(alignment: .center) {
                Image(systemName: "rectangle.and.pencil.and.ellipsis.rtl")
                GrayTextParts("NewItem", .headline)
                
                Spacer()
            
                ForEach(0..<2, id:\.self) { i in
                    Button {
                        if i == 0 {
                            let task = Farm(timeStamp: .now, category: vm.vege, works: vm.work,pages: .cash, seedNum: 0,
                                            harvestCount: 0,
                                            weighing: "0.0",
                                            payment: [NewPayments(item: itemStr, price: Int(priceStr) ?? 0, farm: [])])
                            
                            vm.saveItem(model: task)
                            
                            self.ExSubTotal = 0
                        }
                        self.isNewItem = false
                        self.itemStr = ""
                        self.priceStr = ""
                        
                    } label: {
                        ButtonParts(icon: ["square.and.arrow.down.fill", "arrowtriangle.down"][i],
                                    width: 50, height: 35)
                    }
                }
            }
            .padding(.horizontal, 25)
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(.ultraThinMaterial)
            
            VStack(spacing: 20) {
                HStack(alignment: .center, spacing: 6) {
                    GrayTextParts("Item:", .subheadline)
                    TextField("Input Here!", text: $itemStr)
                }
                
                HStack(alignment: .center, spacing: 6) {
                    GrayTextParts("Price:", .subheadline)
                    TextField("Input Here!", text: $priceStr)
                }
                
                HStack {
                    Picker("WorkCategory:", selection: $vm.work) {
                        ForEach(Array(Work.allCases.enumerated()), id: \.offset) { i, value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: vm.work) { oldValue, newValue in
                        vm.work = newValue
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
       
    }
    
    // MARK: IncomeCellView -------------------------------------------
    @ViewBuilder
    private func IncomeCellView(vege: Vegetables, count: Int) -> some View {
        HStack {
            VStack(spacing: 0) {
                ImgParts(name: vege.listImg)
                GrayTextParts(vege.rawValue, .caption2)
            }
            Spacer()
            GrayTextParts("@\(vege.tanka)円 × \(count)個 =", .caption)
            RoundIntParts(vege.tanka * count, unit: "円",
                          vege.backColor, weight: .regular, fontsize: 17)
        }
        .padding(.vertical, 10).padding(.horizontal)
        .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 15))
        .onAppear {
            inComeSubTotal += vege.tanka * count
        }
    }

    // MARK: ExpenseTitleView -----------------------------------------
    @ViewBuilder
    private func ExpenseTitleView() -> some View {

        HStack(alignment: .center) {
            TitleView("chineseyuanrenminbisign.circle.fill", "出費")
                .padding(.bottom, -3)

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    self.isNewItem = true
                }
            } label: {
                ButtonParts(width: 50)
            }
        }
        .padding(.horizontal, 5)
    }

    // MARK: ExpenseCellView ------------------------------------------
    @ViewBuilder
    private func ExpenseCellView(img: String, str: String, time: String, price: Int, index: Int) -> some View {
        
        HStack(spacing: 10) {
            ImgParts(name: img, width: 25)

            VStack(alignment: .leading) {
                GrayTextParts(str, .callout)
                GrayTextParts(time, .caption)
            }

            Spacer()
            CountTextParts(count: price, unit: "円", weight: .regular)
            
            if isTrash  && index == trashInt {
                Spacer()
                
                Button {
                    withAnimation(.easeInOut) {
                        vm.removeItem(index)
                        self.ExSubTotal = 0
                        
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
        .padding(.vertical, 10).padding(.horizontal)
        .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 15))
        .onAppear {
            self.ExSubTotal += price
        }
        
    }

    // MARK: TotalView -----------------------------------------------
    @ViewBuilder
    private func TotalView(payment: Int) -> some View {
        HStack {
            RoundTextParts("小計", .gray.opacity(0.8))
            Spacer()
            CountTextParts(count: payment, unit: "円", weight: .heavy, fontsize: 25)
        }
        .padding(.vertical, 15).padding(.horizontal)
        .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: TitleView ----------------------------------------------
    @ViewBuilder
    private func TitleView(_ icon:String, _ text: String) -> some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                IconParts(icon)
                GrayTextParts(text, .headline)
            }
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: AllTotalView --------------------------------------------
    @ViewBuilder
    private func AllTotalView() -> some View {

        VStack {
            HStack(alignment: .center) {
                RoundTextParts("利益", .textGray.opacity(0.7))
                
                VStack(alignment: .center, spacing: 0) {
                   IconParts("chineseyuanrenminbisign.circle.fill")
                   CountTextParts(count: ExSubTotal, unit: "円", weight: .regular, fontsize: 20)
               }
               .padding(.horizontal, 5)
               
               Text("-")
               
               VStack(alignment: .center, spacing: 0) {
                   IconParts("chineseyuanrenminbisign.arrow.circlepath")
                   CountTextParts(count: inComeSubTotal, unit: "円", weight: .regular, fontsize: 20)
               }
               .padding(.horizontal, 5)
               
               Text("＝")
                
                RoundIntParts(inComeSubTotal - ExSubTotal, unit: "円",
                              vm.vege.backColor, weight: .heavy, fontsize: 23)
            }
            .font(.caption)
            .foregroundStyle(.textGray)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .padding(.vertical, 15).padding(.horizontal, 5)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                .fill(.white)
                .ignoresSafeArea()
        }
        .compositingGroup()
        .shadow(color: .black, radius: 1, y: -0.5)
    }

}

#Preview {
    PaymentsView()
        .environment(FarmViewModel())
        .modelContainer(for: [Farm.self], inMemory: true)
}
