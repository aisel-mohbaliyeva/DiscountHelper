import SwiftUI

// MARK: - Named colors (sourced from Assets.xcassets)

extension Color {
    static let dhAccent     = Color("AccentBlue")
    static let dhBackground = Color("PageBackground")
    static let dhCard       = Color("CardBackground")
    static let dhGreen      = Color("SavedGreen")
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
    func body(content: Content) -> some View {
        content
            .background(Color.dhCard)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View { modifier(CardStyle()) }
}

// MARK: - Hex color init (used in SplashView gradient)

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
