import SwiftUI

struct SplashView: View {

    @State private var showMain   = false
    @State private var iconScale  : CGFloat = 0.5
    @State private var iconOpacity: Double  = 0
    @State private var textOpacity: Double  = 0

    var body: some View {
        if showMain {
            MainTabView()
                .transition(.opacity)
        } else {
            splash
                .onAppear(perform: animate)
        }
    }

    private var splash: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "E8F2FD"), Color(hex: "F0EDFF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.dhAccent)
                        .frame(width: 96, height: 96)

                    Image(systemName: "tag.fill")
                        .font(.system(size: 42, weight: .medium))
                        .foregroundColor(.white)
                }
                .scaleEffect(iconScale)
                .opacity(iconOpacity)

                VStack(spacing: 6) {
                    Text("Discount Helper")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "1A2A4A"))

                    Text("Smart shopping calculator")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "6B8AB0"))
                }
                .opacity(textOpacity)
            }
        }
    }

    private func animate() {
        withAnimation(.spring(response: 0.55, dampingFraction: 0.65)) {
            iconScale   = 1
            iconOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
            textOpacity = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
            withAnimation(.easeInOut(duration: 0.35)) {
                showMain = true
            }
        }
    }
}
