//
//  CustomGaugeView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

struct CustomGaugeView: View {
    @Environment(FarmViewModel.self) private var vm
    
    var body: some View {
        VStack {
               Gauge(value: Double(vm.totalCount), in: 0...Double(vm.vege.goalCount)) {
                   MainTextParts(text: "\(vm.totalCount)",
                                 font: .system(size: 80),
                                 color: vm.vege.darkColor)
               } currentValueLabel: {
                   Text("\(vm.totalCount)")
               } minimumValueLabel: {
                   Text("\(0)")
               } maximumValueLabel: {
                   Text("\(vm.vege.goalCount)")
               }
               .gaugeStyle(CustomGaugeStyle())
           }
           .task {
               do {
                   try await vm.harvestTotalCount()
               } catch {
                   print(error.localizedDescription)
               }
           }
    }
}

#Preview {
    CustomGaugeView()
        .environment(FarmViewModel())
}

// MARK: CustomGaugeStyle ---------------
struct CustomGaugeStyle: GaugeStyle {
    @Environment(FarmViewModel.self) private var vm

    func makeBody(configuration: Configuration) -> some View {

        ZStack(alignment: .center) {
            Circle()
                .trim(from: 0, to: 0.85)
                .foregroundStyle(.white.opacity(0.5))
                .rotationEffect(.degrees(117))

            Circle()
                .trim(from: 0, to: 0.85 * configuration.value)
                .stroke(vm.vege.darkColor, lineWidth: 12.0)
                .rotationEffect(.degrees(117))

            Circle()
                .trim(from: 0, to: 0.85)
                .stroke(.gray, style: StrokeStyle(lineWidth: 8, lineCap: .butt, dash: [1, 34]))
                .rotationEffect(.degrees(117))

            Circle()
                .trim(from: 0, to: 0.85 * configuration.value)
                .stroke(vm.vege.gradColor, style: StrokeStyle(lineWidth: 12, lineCap: .round, dash: [1, 1]))
                .rotationEffect(.degrees(117))

            // Circle内部の文字 ....................
            VStack {
                GrayTextParts("2024年4月30日(火)〜")
                    .padding(.top, 80)
                    .padding(.bottom, -15)

                NameTextVParts(vm.vege.listImg, vm.vege.rawValue, vm.vege.vegeName, vm.vege.darkColor)

                configuration.label
                    .padding(.top, -10)


                RoundedRectangle(cornerRadius: 0)
                    .fill(.textGray)
                    .frame(width: 150, height: 1)
                    .padding(.top, -60)

                MainTextParts(text: "\(vm.vege.goalCount)", font: .largeTitle,
                              color: vm.vege.backColor)
                    .offset(y: -70)
            }

            HStack {
                configuration.minimumValueLabel
                    .offset(x: 100, y: 130)
                Spacer()
                configuration.maximumValueLabel
                    .offset(x: -100, y: 130)
            }
            .font(.caption)
            .foregroundStyle(vm.vege.darkColor)
        }
        .padding(.horizontal)

    } /// make end
}
