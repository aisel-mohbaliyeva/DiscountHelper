import SwiftUI

extension Color {
    static let dhAccent      = Color("AccentBlue")
    static let dhBackground  = Color("PageBackground")
    static let dhCard        = Color("CardBackground")
    static let dhSavedGreen  = Color("SavedGreen")
}

extension Font {
    static func dhLargePrice() -> Font { .system(size: 36, weight: .semibold, design: .rounded) }
    static func dhMediumPrice() -> Font { .system(size: 22, weight: .semibold, design: .rounded) }
    static func dhSmallPrice() -> Font { .system(size: 15, weight: .medium, design: .rounded) }
    static func dhLabel() -> Font { .system(size: 12, weight: .medium) }
    static func dhBody() -> Font { .system(size: 15, weight: .regular) }
}

struct DHCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.dhCard)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func dhCardStyle() -> some View { modifier(DHCard()) }
}
