//
//  CustomTabView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

struct CustomTabView: View {
    @Environment(FarmViewModel.self) private var vm
    
    var body: some View {
        GeometryReader { geometry in

            let size = geometry.size

            HStack {
                ForEach(Vegetables.allCases, id:\.self) { items in
                    Button {
                        withAnimation(.spring(duration: 0.5, bounce: 0.4)) {
                            self.vm.vege = items

                            Task {
                                do {
                                    try await vm.harvestTotalCount()
                                    try await vm.AllCount()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    } label: {
                        ZStack(alignment: .top) {
                            RoundBackParts(radius: 0)

                            VStack {
                                Image(items.TabImg)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .frame(width: 40)
                                    .background(vm.vege == items ? .buttonBrown : .buttonBrown.opacity(0.5), in: .circle)

                                Text(items.rawValue)
                                    .font(.system(size: 10))
                                    .foregroundStyle(.buttonBrown)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .top])
            .frame(maxWidth: .infinity, maxHeight: size.height / 8)
            .background(.white,
                        in: UnevenRoundedRectangle(topLeadingRadius: 20,
                                                   topTrailingRadius: 20))
            .compositingGroup()
            .shadow(color: .gray, radius: 1, y: -1.0)
            .offset(y: size.height - size.height / 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CustomTabView()
        .environment(FarmViewModel())
}
