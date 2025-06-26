import SwiftUI

struct ContentView: View {
    static let modes: [(icon: String, label: String, title: String, subTitle: String, fn: ((Double, Double) -> Double)?)] = [
        (
            icon: "percent",
            label: "% Change",
            title: "Percent Change",
            subTitle: "Calculate percent change between two numbers",
            fn: { (x: Double, y: Double) -> Double in
                guard x != 0 else { return 0 }
                ((y - x) / y) * 100
            }
        ),
        (
            icon: "arrow.up",
            label: "% Increase",
            title: "Percent Increase",
            subTitle: "Increase value by percentage",
            fn: { (x: Double, y: Double) -> Double in
                x  * (1 + (y / 100))
            }
        ),
        (
            icon: "arrow.down",
            label: "% Decrease",
            title: "Percent Decrease",
            subTitle: "Decrease value by percentage",
            fn: { (x: Double, y: Double) -> Double in
                x  * (1 - (y / 100))
            }
        ),
        (
            icon: "arrow.left.and.right",
            label: "% Difference",
            title: "Percent Difference",
            subTitle: "Calculate percent difference between two numbers",
            fn: { (x: Double, y: Double) -> Double in
                let diff = abs(x - y)
                let average = (x + y) / 2
                return (diff / average) * 100
            }
        )
    ]
    
    @State private var mode = ContentView.modes[0]
    @State private var x = 0.0
    @State private var y = 0.0
    @State private var result = 0.0
    @State private var showingMenu = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // main content
                VStack {
                    VStack(alignment: .center) {
                        Text(mode.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(mode.subTitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
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
