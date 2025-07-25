import SwiftUI
import UIKit
import FirebaseAnalytics

func percent(z: Double) -> String {
    return String(format: "%.2f%%", z)
}

func identity(z: Double) -> String {
    return String(format: "%.2f", z)
}

func eventName(_ input: String) -> String {
    return input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()
        .replacingOccurrences(of: "[^a-z0-9]+", with: "_", options: .regularExpression)
        .trimmingCharacters(in: CharacterSet(charactersIn: "_"))
}

struct ContentView: View {
    static let modes: [(icon: String, title: String, subTitle: String, x: String, y: String, z: String, fn: ((Double, Double) -> Double)?, resultFn: ((Double) -> String)?)] = [
        (
            icon: "percent",
            title: "Percent Change",
            subTitle: "Amount of change in a percent",
            x: "Value",
            y: "After",
            z: "Change",
            fn: { (x: Double, y: Double) -> Double in
                guard x != 0 else { return 0 }
                return ((y - x) / x) * 100
            },
            resultFn: percent
        ),
        (
            icon: "arrow.up",
            title: "Percent Increase",
            subTitle: "Increase by a percent",
            x: "Increase",
            y: "by",
            z: "is",
            fn: { (x: Double, y: Double) -> Double in
                x  * (1 + (y / 100))
            },
            resultFn: identity
        ),
        (
            icon: "arrow.down",
            title: "Percent Decrease",
            subTitle: "Reduce by a percent",
            x: "Decrease",
            y: "by",
            z: "is",
            fn: { (x: Double, y: Double) -> Double in
                x  * (1 - (y / 100))
            },
            resultFn: identity
        ),
        (
            icon: "basket",
            title: "Shares",
            subTitle: "Shares by amount",
            x: "Capital",
            y: "Price per share",
            z: "# of shares",
            fn: { (x: Double, y: Double) -> Double in
                return x / y
            },
            resultFn: identity
        )
    ]
    
    @State private var mode = ContentView.modes[0]
    @State private var x = ""
    @State private var y = ""
    @State private var showCopied = false
    @State private var showMenu = false
    @State private var showBuyMeACoffee = false
    
    enum Field: Hashable {
        case x
        case y
        case z
    }
    
    func percentValue() -> Bool {
        return mode.y == "by"
    }
    
    @FocusState private var focused: Field?
    
    @AppStorage("darkMode") private var darkMode: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            mainContent()
                .toolbar {
                    menuToolbarItem
                    
                }
                .navigationDestination(isPresented: $showBuyMeACoffee) {
                    BuyMeACoffee()
                }
        }
        
        .preferredColorScheme(darkMode ? .dark : .light)
    }
    
    @ViewBuilder
    private func mainContent() -> some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack() {
                        VStack(alignment: .center, spacing: 8) {
                            Text(mode.title)
                                .font(.system(size: geometry.size.width * 0.065, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text(mode.subTitle)
                                .font(.system(size: geometry.size.width * 0.04, weight: .medium))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom, 20)
                        
                        VStack(spacing: 16) {
                            VStack(alignment: .center, spacing: 8) {
                                Text(mode.x)
                                    .font(.system(size: geometry.size.width * 0.04, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    TextField("", text: $x)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: geometry.size.width * 0.06, weight: .medium))
                                        .focused($focused, equals: .x)
                                        .keyboardType(.decimalPad)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                        .foregroundColor(.primary)
                                    
                                    if !x.isEmpty && focused == .x {
                                        Button(action: {
                                            x = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.secondary)
                                                .font(.title3)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(Color(.secondarySystemBackground))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .stroke(focused == .x ? Color.accentColor : Color.clear, lineWidth: 2)
                                        )
                                )
                            }
                            
                            VStack(alignment: .center, spacing: 8) {
                                Text(mode.y)
                                    .font(.system(size: geometry.size.width * 0.04, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                HStack {
                                    TextField("", text: $y)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: geometry.size.width * 0.06, weight: .medium))
                                        .focused($focused, equals: .y)
                                        .keyboardType(.decimalPad)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                        .foregroundColor(.primary)
                                    
                                    if !y.isEmpty && percentValue() {
                                        Image(systemName: "percent")
                                            .font(.system(size: geometry.size.width * 0.06, weight: .bold))
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundColor(.secondary)
                                            .padding(.trailing, 4)
                                    }
                                    
                                    if !y.isEmpty && !percentValue() && focused == .y {
                                        Button(action: {
                                            y = ""
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(Color(.secondarySystemBackground))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .stroke(focused == .y ? Color.accentColor : Color.clear, lineWidth: 2)
                                        )
                                )
                            }
                            
                            VStack(alignment: .center, spacing: 8) {
                                Text(mode.z)
                                    .font(.system(size: geometry.size.width * 0.04, weight: .semibold))
                                    .foregroundColor(.secondary)
                                
                                let result: Double = {
                                    if let xVal = Double(x), let yVal = Double(y), let fn = mode.fn {
                                        return fn(xVal, yVal)
                                    }
                                    return 0.0
                                }()
                                
                                let background: Color = {
                                    if result == 0.0 {
                                        return Color(.systemGray6)
                                    }
                                    
                                    return result > 0.0 ? Color(.systemGreen).opacity(0.5) : Color(.systemRed).opacity(0.5)
                                }()
                                
                                let formatted: String = {
                                    if let resultFn = mode.resultFn {
                                        return resultFn(result)
                                    }
                                    return ""
                                }()
                                
                                ZStack {
                                    TextField("", text: .constant(formatted))
                                        .multilineTextAlignment(.center)
                                        .disabled(true)
                                        .font(.system(size: geometry.size.width * 0.06, weight: .medium))
                                        .keyboardType(.decimalPad)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                        .foregroundColor(.primary)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .fill(background)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                        .stroke(focused == .z ? Color.accentColor : Color.clear, lineWidth: 2)
                                                )
                                        )
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            UIPasteboard.general.string = formatted
                                            
                                            showCopied = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                showCopied = false
                                            }
                                        }
                                    
                                    if showCopied {
                                        Text("Copied!")
                                            .font(.system(size: geometry.size.width * 0.045, weight: .bold))
                                            .foregroundColor(.primary)
                                            .padding(8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(.systemBackground).opacity(0.9))
                                            )
                                            .transition(.opacity)
                                    }
                                }
                                .animation(.easeInOut(duration: 0.2), value: showCopied)
                                
                                
                                Text("Tap to copy")
                                    .font(.system(size: geometry.size.width * 0.04, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .onAppear {
                        focused = .x
                        Analytics.logEvent("main_content_appear", parameters: nil)
                    }
                }
                
                if showMenu {
                    menuOptions()
                }
            }
        }
    }
    
    private var menuToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showMenu.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.accentColor)
                    .font(.title3)
            }
        }
    }
    
    private func menuOptions() -> some View {
        VStack {
            HStack {
                Spacer()
                
                VStack(spacing: 0) {
                    ForEach(ContentView.modes.indices, id: \.self) { index in
                        menuItem(index)
                    }
                    Divider()
                    appearance
                    
                    Divider()
                    feedback
// comment out features that are not ready
//                    Divider()
//                    share
//                    
//                    Divider()
//                    coffee
                }
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 8)
                )
                .frame(maxWidth: 320)
            }
            .transition(.move(edge: .top).combined(with: .opacity))
            
            Spacer()
        }
    }
    
    private func menuItem(_ index: Int) -> some View {
        let selected = ContentView.modes[index]
        
        return menuItem(icon: selected.icon, title: selected.title, selected: mode.title == selected.title, action: {
            
            Analytics.logEvent("switch_mode", parameters: [
                "before": mode.title,
                "after": selected.title
            ])
            Analytics.logEvent(eventName(selected.title), parameters: nil)
            
            mode = selected
            showMenu = false
        })
    }
    
    private func menuItem(icon: String, title: String, selected: Bool? = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if selected == true {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
        .background(Color.clear)
    }
    
    private var appearance: some View {
        menuItem(
            icon: darkMode ? "sun.max.fill" : "moon.fill",
            title: darkMode ? "Light Mode" : "Dark Mode",
            action: {
                showMenu = false
                darkMode.toggle()
                
                Analytics.logEvent("toggle_appearance", parameters: nil)
            }
        )
    }
    
    private var feedback: some View {
        return menuItem(
            icon: "bubble",
            title: "Feedback",
            action: {
                Analytics.logEvent("drafting_feedback", parameters: nil)
                
                showMenu = false
                let url = URL(string: "mailto:limanoit@gmail.com?subject=Feedback%20for%20Percent%20")!
                UIApplication.shared.open(url)
            })
    }
    
    private var share: some View {
        return menuItem(
            icon: "gift",
            title: "Share",
            action: {
                Analytics.logEvent("sharing_appstore", parameters: nil)
                
                showMenu = false
                
                let appStoreURL = URL(string: "https://apps.apple.com/app/id6747897383")!
                UIApplication.shared.open(appStoreURL)
            })
    }
    
    private var coffee: some View {
        return menuItem(
            icon: "cup.and.heat.waves",
            title: "Buy me a coffee",
            action: {
                Analytics.logEvent("buying_coffee", parameters: nil)
                
                showMenu = false
                showBuyMeACoffee = true
            })
    }
}

#Preview {
    ContentView()
}
