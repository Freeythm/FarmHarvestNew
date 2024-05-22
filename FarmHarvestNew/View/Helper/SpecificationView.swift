//
//  SpecificationView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

struct PartsSpecificationView: View {
    
    var body: some View {
    
        NavigationStack {

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Section {
                        HStack {
                            Text("◎ButtonParts")
                            Spacer()
                            ButtonParts(width: 100)
                        }

                        Divider()

                        HStack {
                            Text("◎ButtonHeadParts")
                            Spacer()
                            ButtonHeadParts(.buttonBrown)
                        }

                        Divider()

                        HStack {
                            Text("◎CircleButtonParts")
                            Spacer()
                            CircleButtonParts()
                        }

                        Divider()


                    } header: {
                        TextView(text: "■ Button")
                    }



                    Section {
                        HStack(alignment: .firstTextBaseline) {
                            Text("◎NameTextVParts")
                            Spacer()
                            NameTextVParts("Icon1")
                        }

                        Divider()

                        HStack {
                            Text("◎NameTextHParts")
                            Spacer()
                            NameTextHParts("Icon1", kinds: "", "桃太郎")
                        }

                        Divider()

                        HStack {
                            Text("◎IconTextParts")
                            Spacer()
                            IconTextParts("Ex1", "収穫数")
                        }

                        Divider()

                        HStack {
                            Text("◎")
                            Spacer()
                            IconParts("star")
                        }

                        Divider()

                        HStack {
                            Text("◎CountTextParts")
                            Spacer()
                            CountTextParts(count: 10, unit: "個")
                        }

                        Divider()

                        HStack {
                            Text("◎GrayTextParts")
                            Spacer()
                            GrayTextParts("3/10(水)")
                        }

                        Divider()

                        HStack {
                            Text("◎MainTextParts")
                            Spacer()
                            MainTextParts(text: "Tes")
                        }

                        Divider()


                    } header: {
                        TextView(text: "■ Text")
                    }

                    Section {
                        HStack {
                            Text("◎MemoCountParts")
                            Spacer()
                            MemoCountParts(count: 1)
                        }

                        Divider()

                        HStack {
                            Text("◎MemoCountParts")
                            Spacer()
                            MemoProgressParts(text: "10", color: .thinGreen, textColor: .darkGreen)
                        }

                        Divider()

                        HStack {
                            Text("◎RoundTextParts")
                            Spacer()
                            RoundTextParts("合計")
                        }

                        Divider()

                        HStack {
                            Text("◎RoundBackParts")
                            Spacer()
                            RoundBackParts(radius: 4)
                        }

                        Divider()


                    } header: {
                        TextView(text: "■ Back")
                    }


                }
                .padding()
            }
            .padding()
            .navigationTitle("Parts Specification")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private func TextView(text: String) -> some View {
        Text(text)
            .fontWeight(.heavy)
            .foregroundStyle(.orange)
    }
}


#Preview {
    PartsSpecificationView()
}

