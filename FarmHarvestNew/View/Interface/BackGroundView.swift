//
//  BackGroundView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

struct BackGroundView: View {
    @Environment(FarmViewModel.self) private var vm
    
    var body: some View {
        VStack {
            Image(vm.page == .cash ? "Vege" : vm.vege.backImg)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.6)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(vm.page == .cash ? .gray.opacity(0.1) : vm.vege.darkColor.opacity(0.1))
        .ignoresSafeArea()
    }
}

#Preview {
    BackGroundView()
        .environment(FarmViewModel())
}
