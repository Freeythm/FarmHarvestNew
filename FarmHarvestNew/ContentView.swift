//
//  ContentView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(FarmViewModel.self) private var vm
    @State var isPayment: Bool = false
    @State var isHome: Bool = true
   
    var body: some View {
        
        ZStack(alignment: .bottom) {
            BackGroundView()

            VStack(alignment: .leading) {
                MenuView(vmBind: vm, isPayment: $isPayment, isHome: $isHome)

                GeometryReader { geo in
                    VStack {
                        if isHome {
                            HomeView()
                                .offset(y: isHome ? 0 : geo.size.height)
                                .opacity(isHome ? 1 : 0)
                               
                        } else {
                            ListView()
                                .offset(y: vm.page == .list ? 0 : geo.size.height)
                                .opacity(vm.page == .list ? 1 : 0)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeOut, value: vm.page)
            }
            .padding(.horizontal, 25)
    
            // MARK: TABVIEW ----------------------
            if vm.page != .cash {
                CustomTabView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isPayment) {
            withAnimation {
                vm.page = .home
                isHome = true
                self.isPayment = isPayment
            }
        } content: {
            PaymentsView()
        }
    }
}

#Preview {
    ContentView()
        .environment(FarmViewModel())
        .modelContainer(for: [Farm.self, NewPayments.self], inMemory: true)
}
