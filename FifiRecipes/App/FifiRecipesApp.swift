import SwiftUI

@main
struct FifiRecipesApp: App {
    @StateObject private var app = AppState()

    init() {
        // Screenshot/UI-test hooks:
        //   -fifi.reset 1        → wipe the persisted language (first-run picker)
        //   -fifi.language ar    → preselect a language (skips the picker)
        //   -fifi.apiOrigin URL  → point the API elsewhere (offline test)
        //   -FifiSizeCategory AX3 → force a Dynamic Type size for screenshots
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-fifi.reset") {
            UserDefaults.standard.removeObject(forKey: "fifi.language")
        }
        if let i = args.firstIndex(of: "-fifi.language"), args.indices.contains(i + 1) {
            UserDefaults.standard.set(args[i + 1], forKey: "fifi.language")
        }
    }

    /// -FifiSizeCategory AX3 forces a Dynamic Type size for screenshots/tests.
    private var forcedTypeSize: DynamicTypeSize? {
        let key = UserDefaults.standard.string(forKey: "FifiSizeCategory")
        switch key {
        case "XS": return .xSmall
        case "L": return .large
        case "XL": return .xLarge
        case "XXL": return .xxLarge
        case "XXXL": return .xxxLarge
        case "AX1": return .accessibility1
        case "AX2": return .accessibility2
        case "AX3": return .accessibility3
        default: return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(app)
                .modifier(ForcedTypeSize(size: forcedTypeSize))
                .environment(\.fifiLanguage, app.lang)
                .environment(\.layoutDirection, app.layoutDirection)
                .onOpenURL { url in app.handleDeepLink(url) }
                .onAppear { app.start() }
                .tint(Palette.tomato)
        }
    }
}

private struct ForcedTypeSize: ViewModifier {
    let size: DynamicTypeSize?
    func body(content: Content) -> some View {
        if let size { content.dynamicTypeSize(size) } else { content }
    }
}
