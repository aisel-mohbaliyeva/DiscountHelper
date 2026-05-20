import SwiftUI

// MARK: - Colors

extension Color {
    static let dhAccent     = Color("AccentBlue")
    static let dhBackground = Color("PageBackground")
    static let dhCard       = Color("CardBackground")
    static let dhGreen      = Color("SavedGreen")
}

// MARK: - Fonts

extension Font {
    static func dhHero()    -> Font { .system(size: 38, weight: .bold,   design: .rounded) }
    static func dhTitle()   -> Font { .system(size: 20, weight: .bold,   design: .rounded) }
    static func dhPrice()   -> Font { .system(size: 22, weight: .semibold, design: .rounded) }
    static func dhLabel()   -> Font { .system(size: 12, weight: .medium) }
    static func dhCaption() -> Font { .system(size: 11, weight: .regular) }
}

// MARK: - Card modifier

struct DHCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.dhCard)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 3)
    }
}

extension View {
    func dhCard() -> some View { modifier(DHCardModifier()) }
}

// MARK: - Color from hex (for SplashView gradient)

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var n: UInt64 = 0
        Scanner(string: h).scanHexInt64(&n)
        self.init(
            red:   Double((n >> 16) & 0xFF) / 255,
            green: Double((n >> 8)  & 0xFF) / 255,
            blue:  Double( n        & 0xFF) / 255
        )
    }
}
