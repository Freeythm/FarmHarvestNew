//
//  MenuView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

struct MenuView: View {
    @Bindable var vmBind: FarmViewModel
    @Binding var isPayment: Bool
    @Binding var isHome: Bool
    
    var body: some View {
        Menu {
            ForEach(Pages.allCases, id: \.self) { items in
                Button {
                    withAnimation(.bouncy) {
                        vmBind.page = items
                        self.isPayment = vmBind.page.isPaymant
                        
                        if items == .home {
                            isHome = true
                        } else {
                            isHome = false
                        }
                    }
                    
                } label: {
                    HStack {
                        Text(items.rawValue).tag(items)
                        Spacer()
                        Image(systemName: items.icon)
                    }
                    .foregroundStyle(.buttonBrown)
                }
            }
        } label: {
            CircleButtonParts(icon: "filemenu.and.selection")
        }
    }
}

#Preview {
    MenuView(vmBind: FarmViewModel(), isPayment: .constant(false), isHome: .constant(false))
}
