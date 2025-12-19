import SwiftUI

struct CongratsView: View {
    let onRefresh: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.accentBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.accentBlue)
            }
            
            VStack(spacing: 12) {
                Text("All Done!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.textDark)
                
                Text("You've completed all your tasks.\nTake a well-deserved break!")
                    .font(.system(size: 16))
                    .foregroundColor(.textDark.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Button(action: onRefresh) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Check for New Tasks")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.accentBlue)
                .cornerRadius(12)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}
