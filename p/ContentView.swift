import SwiftUI

struct ContentView: View {
    static let modes: [(icon: String, title: String, subTitle: String, x: String, y: String, z: String, fn: ((Double, Double) -> Double)?)] = [
        (
            icon: "percent",
            title: "Percent Change",
            subTitle: "Calculate percent change between two numbers",
            x: "Value",
            y: "After",
            z: "Change",
            fn: { (x: Double, y: Double) -> Double in
                guard x != 0 else { return 0 }
                return ((y - x) / y) * 100
            }
        ),
        (
            icon: "arrow.up",
            title: "Percent Increase",
            subTitle: "Increase value by percentage",
            x: "Increase",
            y: "by",
            z: "is",
            fn: { (x: Double, y: Double) -> Double in
                x  * (1 + (y / 100))
            }
        ),
        (
            icon: "arrow.down",
            title: "Percent Decrease",
            subTitle: "Decrease value by percentage",
            x: "Decrease",
            y: "by",
            z: "is",
            fn: { (x: Double, y: Double) -> Double in
                x  * (1 - (y / 100))
            }
        ),
        (
            icon: "arrow.left.and.right",
            title: "Percent Difference",
            subTitle: "Calculate percent difference between two numbers",
            x: "Value 1",
            y: "Value 2",
            z: "% difference",
            fn: { (x: Double, y: Double) -> Double in
                let diff = abs(x - y)
                let average = (x + y) / 2
                return (diff / average) * 100
            }
        )
    ]
    
    @State private var mode = ContentView.modes[0]
    @State private var x = ""
    @State private var y = ""
    @State private var result = ""
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case x
        case y
        case z
    }
    
    @State private var showingMenu = false
    
    var body: some View {
        GeometryReader { geometry in
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
                                .foregroundColor(.primary)
                            
                            TextField("", text: $x)
                                .multilineTextAlignment(.center)
                                .font(.system(size: geometry.size.width * 0.045, weight: .medium))
                                .focused($focusedField, equals: .x)
                                .keyboardType(.decimalPad)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    Rectangle()
                                        .fill(Color(.systemGray6))
                                        .overlay(
                                            Rectangle()
                                                .stroke(focusedField == .x ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                )
                        }
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text(mode.y)
                                .font(.system(size: geometry.size.width * 0.04, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextField("", text: $y)
                                .multilineTextAlignment(.center)
                                .font(.system(size: geometry.size.width * 0.045, weight: .medium))
                                .focused($focusedField, equals: .y)
                                .keyboardType(.decimalPad)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    Rectangle()
                                        .fill(Color(.systemGray6))
                                        .overlay(
                                            Rectangle()
                                                .stroke(focusedField == .y ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                )
                        }
                        
                        VStack(alignment: .center, spacing: 8) {
                            Text(mode.z)
                                .font(.system(size: geometry.size.width * 0.04, weight: .semibold))
                                .foregroundColor(.primary)
                            
                            TextField("", text: .constant("read-only value"))
                                .multilineTextAlignment(.center)
                                .disabled(true)
                                .font(.system(size: geometry.size.width * 0.045, weight: .medium))
                                .focused($focusedField, equals: .z)
                                .keyboardType(.decimalPad)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    Rectangle()
                                        .fill(Color(.systemGray6))
                                        .overlay(
                                            Rectangle()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { withAnimation { showingMenu.toggle() } }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
            
        }
    }
}

struct MenuItem: View {
    var icon: String
    var label: String
    var subTitle: String
    var chevron: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .foregroundColor(.primary)
                Text(subTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if chevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
}
