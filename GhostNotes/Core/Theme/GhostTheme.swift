import SwiftUI

enum GhostTheme {
    static let background = Color(red: 0.08, green: 0.04, blue: 0.16)
    static let surface = Color(red: 0.15, green: 0.09, blue: 0.25)
    static let surfaceRaised = Color(red: 0.21, green: 0.13, blue: 0.34)
    static let ghostWhite = Color(red: 0.96, green: 0.95, blue: 1.0)
    static let lavender = Color(red: 0.76, green: 0.67, blue: 1.0)
    static let pumpkin = Color(red: 1.0, green: 0.46, blue: 0.16)
    static let mist = Color.white.opacity(0.68)
}

struct GhostBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            GhostTheme.background
                .ignoresSafeArea()
            Circle()
                .fill(GhostTheme.lavender.opacity(0.08))
                .frame(width: 260, height: 260)
                .blur(radius: 12)
                .offset(x: 130, y: -300)
            content
        }
        .preferredColorScheme(.dark)
    }
}

extension View {
    func ghostBackground() -> some View {
        modifier(GhostBackground())
    }
}
