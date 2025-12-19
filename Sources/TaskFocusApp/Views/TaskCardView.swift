import SwiftUI

struct TaskCardView: View {
    let task: Task
    let projectName: String
    let onSwipeComplete: () -> Void
    let onSwipeSkip: () -> Void
    let canSkip: Bool
    
    @State private var offset: CGFloat = 0
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.cardBackground
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(projectName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.accentBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentBlue.opacity(0.1))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    if let duration = task.estimatedDuration {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text("\(duration) min")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.textDark.opacity(0.6))
                    }
                }
                
                Text(task.content)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.textDark)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let explanation = task.howExplanation {
                    Text(explanation)
                        .font(.system(size: 16))
                        .foregroundColor(.textDark.opacity(0.7))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                HStack {
                    if canSkip {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 16))
                                .foregroundColor(.accentRed.opacity(0.3))
                            Text("Skip")
                                .font(.system(size: 12))
                                .foregroundColor(.textDark.opacity(0.4))
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("Complete")
                            .font(.system(size: 12))
                            .foregroundColor(.textDark.opacity(0.4))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16))
                            .foregroundColor(.accentBlue.opacity(0.3))
                    }
                }
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.borderStroke, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .offset(x: offset)
        .rotationEffect(.degrees(Double(offset / 20)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation.width
                }
                .onEnded { gesture in
                    if gesture.translation.width > 150 {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            offset = 500
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onSwipeComplete()
                            offset = 0
                        }
                    } else if gesture.translation.width < -150 && canSkip {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                            offset = -500
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onSwipeSkip()
                            offset = 0
                        }
                    } else {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                }
        )
    }
}
