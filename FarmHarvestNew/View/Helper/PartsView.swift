//
//  PartsView.swift
//  FarmHarvestNew
//
//  Created by Freeythm on 2024/05/22.
//

import SwiftUI

// MARK: Button Parts -------------
// ButtonParts...................................................
func ButtonParts(icon: String = "plus", width: CGFloat, height: CGFloat = 25) -> some View {

    ZStack {
        RoundedRectangle(cornerRadius: 5)
            .fill(.white.opacity(0.8))
            .stroke(.buttonBrown, lineWidth: 2.0)
            .frame(width: width, height: height)

        Image(systemName: icon)
            .foregroundStyle(.buttonBrown)

    }
}

// ButtonHeadParts ----------------------
func ButtonHeadParts(icon: String = "plus", _ color: Color) -> some View {
    VStack {
        RoundedRectangle(cornerRadius: 5)
            .fill(.white.opacity(0.8))
            .stroke(color, lineWidth: 2.0)
            .frame(height: 40)
            .overlay {
                Image(systemName: icon)
                    .foregroundStyle(color)
            }
    }
}

// ButtonHeadTextParts ----------------------
func ButtonHeadTextParts(text: String = "plus", _ color: Color) -> some View {
    VStack {
        RoundedRectangle(cornerRadius: 5)
            .fill(.white.opacity(0.8))
            .stroke(color, lineWidth: 2.0)
            .frame(height: 40)
            .overlay {
                Text(text)
                    .foregroundStyle(color)
            }
    }
}

// CircleButtonParts...................................................
func CircleButtonParts(icon: String = "list.dash.header.rectangle", font: Font = .title2, _ padding: CGFloat = 16) -> some View {

    VStack {
       Image(systemName: icon)
            .font(font)
            .foregroundStyle(.buttonBrown)
    }
    .padding(padding)
    .background {
        Circle()
            .fill(.white.opacity(0.9))
            .stroke(.buttonBrown, lineWidth: 2.0)
    }
}


// MARK: Text Parts ------------------------------------------------------
// NameTextVParts...................................................
func NameTextVParts(_ img: String, _ kinds: String = "Test", _ name: String = "桃太郎", _ color: Color = .darkRed) -> some View {

    VStack(spacing: 0) {

        HStack(spacing: 0) {
            ImgParts(name: img)

            Text(kinds)
                .font(.system(size: 40, weight: .heavy, design: .rounded))
        }

        Text(name)
            .font(.headline.monospaced())
    }
    .foregroundStyle(color)
}

// NameTextHParts...................................................
func NameTextHParts(_ img: String, kinds: String = "Test", _ name: String, _ color: Color = .darkRed) -> some View {
    HStack(alignment: .lastTextBaseline, spacing: 5) {
        ImgParts(name: img)

        Text(kinds)
            .font(.system(size: 40, weight: .heavy, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.6)

        Text(name)
            .font(.headline.monospaced())
            .lineLimit(1)
            .minimumScaleFactor(0.5)
    }
    .foregroundStyle(color)
}

// IconTextParts...................................................
func IconTextParts(_ icon: String, _ text: String, _ color: Color = .darkRed, _ size: CGFloat = 20, _ font: Font = .headline) -> some View {

    HStack(alignment: .center, spacing: 2) {
        Image(icon)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: size, height: size)

        Text(text)
            .font(font)
    }
    .foregroundStyle(color)
}

// IconParts ..........................................................
func IconParts(_ icon: String, color: Color = .textGray) -> some View {
    Image(systemName: icon)
        .imageScale(.small)
        .padding(2)
        .foregroundStyle(.white)
        .background(color, in: RoundedRectangle(cornerRadius: 5))
}

func RoundTextParts(_ text: String, _ color: Color = .gray.opacity(0.8), paddingV: CGFloat = 5) -> some View {
    HStack(alignment: .lastTextBaseline, spacing: 2) {
        Text(text)
            .font(.subheadline)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }
    .foregroundStyle(.white)
    .padding(.vertical, paddingV).padding(.horizontal, 15)
    .background(color, in: RoundedRectangle(cornerRadius: 5))
}

// RoundIconTextParts...................................................
func RoundIntParts(_ count: Int, unit: String, _ color: Color = .darkRed, weight: Font.Weight = .regular, fontsize: CGFloat = 20) -> some View {
    HStack(alignment: .lastTextBaseline, spacing: 2) {
        Text("\(count)")
            .font(.system(size: fontsize, weight: weight, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.7)

        Text(unit)
            .font(.caption)
    }
    .foregroundStyle(.white)
    .padding(.vertical, 5).padding(.horizontal, 15)
    .background(color, in: RoundedRectangle(cornerRadius: 5))
}

// GrayTextParts....................................................
func GrayTextParts(_ text: String, _ font: Font = .caption) -> some View {
    Text(text)
        .font(font)
        .foregroundStyle(.textGray)
}

// MainTextParts....................................................
func MainTextParts(text: String, font: Font = .body, color: Color = .darkRed) -> some View {
    Text(text)
        .font(font.weight(.heavy))
        .foregroundStyle(color)
}


// MARK: HomeView Parts ---------------------------------------------
// CountTextParts...................................................
func CountTextParts(count: Int, unit: String, weight: Font.Weight = .heavy, fontsize: CGFloat = 20) -> some View {

    HStack(alignment: .lastTextBaseline, spacing: 2) {
        Text("\(count)")
            .font(.system(size: fontsize, weight: weight, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.7)

        Text(unit)
            .font(.caption)
    }
    .foregroundStyle(.textGray)
}

// MemoCountParts...................................................
func MemoCountParts(count: Int, color: Color = .darkRed) -> some View {

    VStack(alignment: .leading) {
        ZStack {
            Capsule()
                .fill(color)
                .frame(minWidth: .zero, maxWidth: 100, minHeight: .zero, maxHeight: 20)

            HStack(spacing: 2) {
                Text("\(count)")
                    .fontWeight(.heavy)
                Text("回目")
            }
            .font(.caption2)
            .foregroundStyle(.white)
        }
    }
}

// MemoProgressParts...................................................
func MemoProgressParts(text: String, color: Color = .thinRed, textColor: Color = .darkRed) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 5)
            .fill(color.opacity(0.3))
            .frame(height: 25)

        HStack(alignment: .lastTextBaseline, spacing: 2) {
            Text(text)
                .font(.callout)
                .fontWeight(.heavy)
            Text("日経過")
                .font(.caption)
        }
        .foregroundStyle(textColor)
    }
}

// MARK: Shapes Parts ------------------
// RoundBackParts........................................................
func RoundBackParts(radius: Double) -> some View {
    RoundedRectangle(cornerRadius: radius)
        .fill(.white)
}

// MARK: Image Parts ---------------------
func ImgParts(name: String, width: CGFloat = 30, height: CGFloat = 30) -> some View {
    Image(name)
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .frame(width: width, height: height)
}

#Preview {
    PartsSpecificationView()
}
