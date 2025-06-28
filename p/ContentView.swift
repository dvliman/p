import SwiftUI
import UIKit

func percent(z: Double) -> String {
    return String(format: "%.2f%%", z)
}

func identity(z: Double) -> String {
    return String(format: "%.2f", z)
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
                return ((y - x) / y) * 100
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
            icon: "arrow.left.and.right",
            title: "Percent Difference",
            subTitle: "Difference as a percent",
            x: "Value 1",
            y: "Value 2",
            z: "% difference",
            fn: { (x: Double, y: Double) -> Double in
                let diff = abs(x - y)
                let average = (x + y) / 2
                return (diff / average) * 100
            },
            resultFn: percent
        )
    ]
    
    @State private var mode = ContentView.modes[0]
    @State private var x = ""
    @State private var y = ""
    
    enum Field: Hashable {
        case x
        case y
        case z
    }
    
    @State private var showingMenu = false
    @FocusState private var focusedField: Field?
    
    func percentValue() -> Bool {
        return mode.y == "by"
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    ScrollView {
                        VStack() {
                            VStack(alignment: .center, spacing: 8) {
                                Text(mode.title)
                                    .font(.system(size: geometry.size.width * 0.065, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Text(mode.subTitle)
                                    .font(.system(size: geometry.size.width * 0.035, weight: .medium))
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
                                            .focused($focusedField, equals: .x)
                                            .keyboardType(.decimalPad)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 16)
                                            .foregroundColor(.primary)
                                        
                                        if !x.isEmpty && focusedField == .x {
                                            Button(action: {
                                                x = ""
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                                    .font(.title3)
                                            }
                                            .padding(.trailing, 8)
                                        }
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .fill(Color(.systemGray6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                    .stroke(focusedField == .x ? Color.blue : Color.clear, lineWidth: 2)
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
                                            .focused($focusedField, equals: .y)
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
                                        
                                        if !y.isEmpty && !percentValue() && focusedField == .y {
                                            Button(action: {
                                                y = ""
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                                
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                                            .fill(Color(.systemGray6))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                    .stroke(focusedField == .y ? Color.blue : Color.clear, lineWidth: 2)
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
                                        
                                        return result > 0.0 ? Color(.systemGreen).opacity(0.18) : Color(.systemRed).opacity(0.18)
                                    }()
                                    
                                    TextField("", text: .constant(mode.resultFn?(result) ?? ""))
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
                                                        .stroke(focusedField == .z ? Color.blue : Color.clear, lineWidth: 2)
                                                )
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                        .onAppear {
                            focusedField = .x
                        }
                    }
                    
                    if showingMenu {
                        VStack {
                            HStack {
                                Spacer()
                                
                                VStack(spacing: 0) {
                                    ForEach(ContentView.modes.indices, id: \.self) { index in
                                        menuItem(for: index)
                                    }
                                    Divider()
                                    provideFeedback
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 8)
                                )
                                .frame(maxWidth: 320)
                            }
                            .padding(.top, 60)
                            .padding(.trailing, 20)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingMenu.toggle()
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
            }
        }
    }
    
    private func menuItem(for index: Int) -> some View {
        let modeOption = ContentView.modes[index]
        
        return Button(action: {
            mode = modeOption
            showingMenu = false
        }) {
            HStack {
                Image(systemName: modeOption.icon)
                    .foregroundColor(.blue)
                Text(modeOption.title)
                    .foregroundColor(.primary)
                Spacer()
                if mode.title == modeOption.title {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
        .background(Color.clear)
    }
    
    private func draftEmail() {
        let email = "limanoit@gmail.com"
        let subject = "Feedback for Percent Apps"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:\(email)?subject=\(encodedSubject)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private var provideFeedback: some View {
        Button(action: {
            showingMenu = false
            draftEmail()
        }) {
            HStack {
                Image(systemName: "bubble.left.and.bubble.right")
                    .foregroundColor(.blue)
                Text("Provide Feedback")
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
        }
        .background(Color.clear)
    }
}

#Preview {
    ContentView()
}
