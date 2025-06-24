import SwiftUI

struct ContentView: View {
    @State private var selectedCalculation = "Change"
    @State private var beforeValue = ""
    @State private var afterValue = ""
    @State private var result = ""
    @State private var showingMenu = false
    
    let calculationTypes = [
        (icon: "percent", label: "% Change"),
        (icon: "arrow.up", label: "% Increase"),
        (icon: "arrow.down", label: "% Decrease"),
        (icon: "arrow.left.and.right", label: "% Difference")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 30) {
                    // Form Section
                    VStack(spacing: 20) {
                        // Title
                        Text(selectedCalculation)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        // Form Fields
                        VStack(spacing: 15) {
                            // Before Value
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Before")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                TextField("Enter value", text: $beforeValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                            }
                            
                            // After Value
                            VStack(alignment: .leading, spacing: 5) {
                                Text("After")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                TextField("Enter value", text: $afterValue)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.decimalPad)
                            }
                            
                            // Result Field (Read-only)
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Result")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                TextField("", text: .constant(result))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(true)
                                    .foregroundColor(.primary)
                            }
                            
                            // Calculate Button
                            Button(action: calculateResult) {
                                Text("Calculate")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .disabled(beforeValue.isEmpty || afterValue.isEmpty)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Percentage Calculator")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { withAnimation { showingMenu.toggle() } }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                // Custom Floating Menu Overlay
                if showingMenu {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showingMenu = false } }
                    
                    VStack {
                        HStack {
                            Spacer()
                            VStack(spacing: 0) {
                                Group {
                                    MenuItem(icon: "pencil", label: "Edit Watchlist")
                                    MenuItem(icon: "plus", label: "New Watchlist")
                                }
                                Divider().background(Color.white.opacity(0.2))
                                Group {
                                    MenuItem(icon: "arrow.up.arrow.down", label: "Sort Watchlist By", subtitle: "Percentage Change", chevron: true)
                                    MenuItem(icon: "chart.line.uptrend.xyaxis", label: "Watchlist Shows", subtitle: "Percentage Change", chevron: true)
                                }
                                Divider().background(Color.white.opacity(0.2))
                                MenuItem(icon: "bubble.left", label: "Provide Feedback")
                                Divider().background(Color.white.opacity(0.2))
                                // Calculation type section
                                ForEach(calculationTypes, id: \.(label)) { type in
                                    Button(action: {
                                        selectedCalculation = type.label
                                        showingMenu = false
                                    }) {
                                        HStack {
                                            Image(systemName: type.icon)
                                                .foregroundColor(.blue)
                                            Text(type.label)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            if selectedCalculation == type.label {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                    }
                                    .background(Color.clear)
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 24, style: .continuous)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 8)
                            )
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                            .frame(maxWidth: 320)
                        }
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }
    
    private func calculateResult() {
        guard let before = Double(beforeValue),
              let after = Double(afterValue) else {
            result = "Invalid input"
            return
        }
        
        let percentage: Double
        
        switch selectedCalculation {
        case "% Change":
            percentage = ((after - before) / before) * 100
        case "% Increase":
            percentage = after > before ? ((after - before) / before) * 100 : 0
        case "% Decrease":
            percentage = after < before ? ((before - after) / before) * 100 : 0
        case "% Difference":
            percentage = abs((after - before) / before) * 100
        default:
            percentage = ((after - before) / before) * 100
        }
        
        result = String(format: "%.2f%%", percentage)
    }
}

struct MenuItem: View {
    var icon: String
    var label: String
    var subtitle: String? = nil
    var chevron: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .foregroundColor(.primary)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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
