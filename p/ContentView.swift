import SwiftUI

struct ContentView: View {
    @State private var selectedCalculation = "Change"
    @State private var x = ""
    @State private var y = ""
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
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack(spacing: 32) {
                    Spacer().frame(height: 8)
                    // Title
                    Text(selectedCalculation.lowercased())
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                    
                    // Form Card
                    ZStack {
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color(.systemGreen).opacity(0.10))
                        VStack(alignment: .leading, spacing: 24) {
                            // Before
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Before:")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                TextField("", text: $x)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 34, weight: .bold, design: .default))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 18)
                                    .background(Color.white)
                                    .cornerRadius(16)
                            }
                            // After
                            VStack(alignment: .leading, spacing: 8) {
                                Text("After:")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                TextField("", text: $y)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 34, weight: .bold, design: .default))
                                    .foregroundColor(.black)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 18)
                                    .background(Color.white)
                                    .cornerRadius(16)
                            }
                            // Result
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Change:")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.black)
                                Button(action: {
                                    if !result.isEmpty { UIPasteboard.general.string = result }
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                                            .fill(LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.9), Color.green.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                        Text(result.isEmpty ? "-" : result)
                                            .font(.system(size: 36, weight: .bold, design: .default))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .padding(.vertical, 18)
                                    }
                                    .frame(height: 70)
                                }
                                .buttonStyle(PlainButtonStyle())
                                Text("Tap to copy and save to history")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(24)
                    }
                    .padding(.horizontal)
                    
                    // Calculate Button
                    Button(action: calculateResult) {
                        Text("Calculate")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(16)
                    }
                    .disabled(x.isEmpty || y.isEmpty)
                    .padding(.horizontal)
                    Spacer()
                }
                .padding()
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
                                // Calculation type section only
                                ForEach(calculationTypes, id: \.label) { type in
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
                                        .padding(.vertical, 12)
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
        guard let before = Double(x),
              let after = Double(y) else {
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
