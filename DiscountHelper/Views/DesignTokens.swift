import SwiftUI

// MARK: - Named colors (sourced from Assets.xcassets)

extension Color {
    static let dhAccent     = Color("AccentBlue")
    static let dhBackground = Color("PageBackground")
    static let dhCard       = Color("CardBackground")
    static let dhGreen      = Color("SavedGreen")
}

// MARK: - Branded gradient (indigo → deep violet, works on both modes)

extension LinearGradient {
    static let dhBrand = LinearGradient(
        colors: [Color(hex: "3B5BDB"), Color(hex: "5C3DD8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Typography

extension Font {
    static func dhHero()    -> Font { .system(size: 40, weight: .bold,     design: .rounded) }
    static func dhTitle()   -> Font { .system(size: 17, weight: .semibold, design: .default) }
    static func dhPrice()   -> Font { .system(size: 24, weight: .semibold, design: .rounded) }
    static func dhLabel()   -> Font { .system(size: 12, weight: .medium)                     }
    static func dhCaption() -> Font { .system(size: 11, weight: .regular)                    }
    static func dhBody()    -> Font { .system(size: 15, weight: .regular)                    }
}

// MARK: - Card style

struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color.dhCard)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: colorScheme == .dark
                    ? .black.opacity(0.45)
                    : .black.opacity(0.06),
                radius: colorScheme == .dark ? 16 : 8,
                x: 0,
                y: colorScheme == .dark ? 6 : 2
            )
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
}

// MARK: - Hex color init

extension Color {
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        if hex.count == 3 {
            hex = hex.map { "\($0)\($0)" }.joined()
        }
        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)
        self.init(
            red:   Double((value >> 16) & 0xFF) / 255,
            green: Double((value >>  8) & 0xFF) / 255,
            blue:  Double( value        & 0xFF) / 255
        )
    }
}
