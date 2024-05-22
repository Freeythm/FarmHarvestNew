//
//  HomeView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(FarmViewModel.self) private var vm

    @State private var dayCount: Int = 0
    @State var weigh: Double = 0.0
    @State var isSlider: Bool = false
    
    var body: some View {
        VStack {
            CustomGaugeView()
                .padding(.top, -40).padding(.bottom, -30)

            SeedlingNumberView()

            ScrollView {
                VStack(alignment: .leading) {
                    CountView(dayCount: $dayCount, weigh: $weigh, isSlider: $isSlider)
                }
                .padding(.bottom, 150).padding(.top, 10)
            }
        }
        .task {
            do {
                try await vm.harvestTotalCount()
                try await vm.AllCount()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: SeedlingNumberView -----------
    @ViewBuilder
    func SeedlingNumberView() -> some View {

        HStack(spacing: 5) {
            ForEach(0..<vm.vege.seedlingCount, id: \.self) { i in
                VStack {
                    Text("\(i + 1)")
                        .font(.caption.bold())
                        .foregroundStyle(.textGray)
                        .padding(10)
                        .background(.gray.opacity(0.2), in: .circle)
                }
                .frame(maxWidth: .infinity, maxHeight: 25)
            }
        }
    }
 
}

#Preview {
    HomeView()
        .environment(FarmViewModel())
        .modelContainer(for: [Farm.self], inMemory: true)
}
