import SwiftUI

struct LimitReachedView: View {
    let swipesRemaining: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.accentRed.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.accentRed)
            }
            
            VStack(spacing: 12) {
                Text("Daily Limit Reached")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textDark)
                
                Text("You've completed 3 tasks today.\nCome back tomorrow for more!")
                    .font(.system(size: 16))
                    .foregroundColor(.textDark.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 8) {
                Text("Resets at midnight")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.accentBlue)
                
                Text(nextMidnight())
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textDark)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
    
    private func nextMidnight() -> String {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let midnight = calendar.startOfDay(for: tomorrow)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: midnight)
    }
}
