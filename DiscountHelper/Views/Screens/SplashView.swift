import SwiftUI

struct SplashView: View {

    @Environment(\.colorScheme) private var colorScheme
    @State private var isReady     = false
    @State private var logoScale   : CGFloat = 0.6
    @State private var logoOpacity : Double  = 0
    @State private var textOffset  : CGFloat = 12
    @State private var textOpacity : Double  = 0

    var body: some View {
        Group {
            if isReady {
                MainTabView()
                    .transition(.opacity)
            } else {
                splashContent
            }
        }
        .onAppear(perform: runAnimation)
    }

    private var splashContent: some View {
        ZStack {
            splashBackground.ignoresSafeArea()

            VStack(spacing: 16) {
                appLogo

                VStack(spacing: 5) {
                    Text("Discount Helper")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(colorScheme == .dark ? .white : Color(hex: "1A2A4A"))

                    Text("Smart shopping calculator")
                        .font(.system(size: 15))
                        .foregroundStyle(
                            colorScheme == .dark
                                ? Color.white.opacity(0.50)
                                : Color(hex: "6B8AB0")
                        )
                }
                .offset(y: textOffset)
                .opacity(textOpacity)
            }
        }
    }

    @ViewBuilder
    private var splashBackground: some View {
        if colorScheme == .dark {
            LinearGradient(
                colors: [Color(hex: "0C0C0F"), Color(hex: "14141F")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            LinearGradient(
                colors: [Color(hex: "EEF2FF"), Color(hex: "EDE9FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var appLogo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(LinearGradient.dhBrand)
                .frame(width: 88, height: 88)
                .shadow(color: Color(hex: "3B5BDB").opacity(0.38), radius: 18, x: 0, y: 8)

            Image(systemName: "tag.fill")
                .font(.system(size: 38, weight: .medium))
                .foregroundStyle(.white)
        }
        .scaleEffect(logoScale)
        .opacity(logoOpacity)
    }

    private func runAnimation() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.65)) {
            logoScale   = 1
            logoOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.45).delay(0.2)) {
            textOffset  = 0
            textOpacity = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isReady = true
            }
        }
    }
}
