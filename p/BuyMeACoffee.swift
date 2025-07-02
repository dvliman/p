import SwiftUI

struct BuyMeACoffee: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "cup.and.saucer")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)
            
            Text("My coffee is empty.")
                .font(.system(size: 32, weight: .bold))
                .fontWeight(.bold)
                .padding(.bottom, 4)
            
            Text("Consider buying me a cup!")
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemBackground).ignoresSafeArea())
    }
}
