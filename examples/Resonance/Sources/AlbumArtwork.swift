import SwiftUI

struct AlbumArtwork: View {
    let album: Album

    var body: some View {
        CoverArtwork(index: album.artwork, title: album.englishTitle, subtitle: album.artist)
    }
}

struct CoverArtwork: View {
    let index: Int
    let title: String
    let subtitle: String

    private let palettes: [[Color]] = [
        [Color(red: 0.14, green: 0.32, blue: 0.55), Color(red: 0.59, green: 0.74, blue: 0.78)],
        [Color(red: 0.76, green: 0.26, blue: 0.16), Color(red: 0.98, green: 0.66, blue: 0.38)],
        [Color(red: 0.15, green: 0.31, blue: 0.29), Color(red: 0.62, green: 0.69, blue: 0.52)],
        [Color(red: 0.16, green: 0.12, blue: 0.30), Color(red: 0.52, green: 0.39, blue: 0.56)],
        [Color(red: 0.88, green: 0.63, blue: 0.25), Color(red: 0.97, green: 0.85, blue: 0.58)],
        [Color(red: 0.32, green: 0.39, blue: 0.46), Color(red: 0.71, green: 0.72, blue: 0.69)],
        [Color(red: 0.60, green: 0.32, blue: 0.39), Color(red: 0.87, green: 0.64, blue: 0.59)],
        [Color(red: 0.39, green: 0.49, blue: 0.45), Color(red: 0.77, green: 0.78, blue: 0.63)]
    ]

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            ZStack(alignment: .topLeading) {
                Canvas { context, size in
                    let colors = palettes[index % palettes.count]
                    let rect = CGRect(origin: .zero, size: size)
                    context.fill(Path(rect), with: .linearGradient(Gradient(colors: colors),
                                 startPoint: .zero, endPoint: CGPoint(x: size.width, y: size.height)))
                    drawScene(context: &context, size: size)
                    for dot in 0..<500 {
                        let x = CGFloat((dot * 43 + 19) % 997) / 997 * size.width
                        let y = CGFloat((dot * 73 + 31) % 991) / 991 * size.height
                        context.fill(Path(ellipseIn: CGRect(x: x, y: y, width: 0.9, height: 0.9)),
                                     with: .color(.white.opacity(0.16)))
                    }
                }
                VStack(alignment: .leading, spacing: width * 0.03) {
                    Text(title)
                        .font(.system(size: max(7, width * 0.115), weight: .regular, design: .serif))
                        .tracking(width * 0.005)
                        .lineLimit(2)
                    if width > 95 {
                        Text(subtitle.uppercased())
                            .font(.system(size: max(7, width * 0.038), weight: .medium))
                            .tracking(width * 0.01)
                    }
                }
                .foregroundStyle(.white.opacity(0.94))
                .padding(width * 0.1)
                if width > 130 {
                    VStack {
                        Spacer()
                        HStack {
                            Text("RESONANCE RECORDS")
                            Spacer()
                            Text(String(format: "%02d", index + 1))
                        }
                        .font(.system(size: width * 0.027, weight: .medium)).tracking(1)
                        .foregroundStyle(.white.opacity(0.65))
                    }
                    .padding(width * 0.1)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .overlay(RoundedRectangle(cornerRadius: 7).strokeBorder(.white.opacity(0.08)))
        .accessibilityLabel("\(title) 专辑封面")
    }

    private func drawScene(context: inout GraphicsContext, size: CGSize) {
        let width = size.width
        let height = size.height
        let sun = CGRect(x: width * 0.57, y: height * 0.32, width: width * 0.27, height: width * 0.27)
        context.fill(Path(ellipseIn: sun), with: .color(.white.opacity(index == 3 ? 0.7 : 0.32)))
        if index == 3 || index == 5 {
            for column in 0..<8 {
                let x = CGFloat(column) * width / 7
                let towerHeight = height * (0.22 + CGFloat((column * 13 + 7) % 11) / 30)
                let rect = CGRect(x: x, y: height - towerHeight, width: width * 0.11, height: towerHeight)
                context.fill(Path(rect), with: .color(.black.opacity(0.16 + Double(column % 3) * 0.07)))
                for row in 0..<4 {
                    context.fill(Path(CGRect(x: x + width * 0.03, y: height - towerHeight + CGFloat(row + 1) * width * 0.04,
                                             width: width * 0.016, height: width * 0.012)),
                                 with: .color(.white.opacity(0.36)))
                }
            }
        } else if index == 6 {
            for petal in 0..<7 {
                let angle = Double(petal) * .pi * 2 / 7
                let rect = CGRect(x: width * (0.42 + cos(angle) * 0.19),
                                  y: height * (0.52 + sin(angle) * 0.16), width: width * 0.3, height: height * 0.28)
                context.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.1 + Double(petal) * 0.015)))
            }
        } else {
            for band in 0..<6 {
                let baseline = height * (0.53 + CGFloat(band) * 0.075)
                var wave = Path()
                wave.move(to: CGPoint(x: 0, y: baseline))
                wave.addCurve(to: CGPoint(x: width, y: baseline - height * 0.03),
                              control1: CGPoint(x: width * 0.33, y: baseline - height * (index == 2 ? 0.4 : 0.17)),
                              control2: CGPoint(x: width * 0.68, y: baseline + height * 0.18))
                wave.addLine(to: CGPoint(x: width, y: height))
                wave.addLine(to: CGPoint(x: 0, y: height))
                wave.closeSubpath()
                context.fill(wave, with: .color(.black.opacity(0.06 + Double(band) * 0.023)))
            }
        }
    }
}
