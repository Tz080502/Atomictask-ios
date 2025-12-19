import SwiftUI

struct MainTaskView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var swipeLimitService = SwipeLimitService.shared
    @StateObject private var supabaseService = SupabaseService.shared
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                if taskViewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.accentBlue)
                } else if taskViewModel.showCongratsScreen {
                    CongratsView(onRefresh: {
                        _Concurrency.Task {
                            await taskViewModel.refreshTasks()
                        }
                    })
                } else if let currentTask = taskViewModel.currentTask {
                    VStack(spacing: 0) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Today's Focus")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.textDark)
                                
                                Text("\(swipeLimitService.skipsRemaining) skips remaining")
                                    .font(.system(size: 14))
                                    .foregroundColor(.textDark.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showSettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.accentBlue)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                        
                        TaskCardView(
                            task: currentTask,
                            projectName: taskViewModel.getProjectName(for: currentTask.projectId),
                            onSwipeComplete: {
                                _Concurrency.Task {
                                    await taskViewModel.completeCurrentTask()
                                }
                            },
                            onSwipeSkip: {
                                taskViewModel.skipCurrentTask()
                            },
                            canSkip: swipeLimitService.canSkip
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(.textDark.opacity(0.3))
                        
                        Text("No tasks available")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.textDark)
                        
                        Button(action: {
                            _Concurrency.Task {
                                await taskViewModel.refreshTasks()
                            }
                        }) {
                            Text("Refresh")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Color.accentBlue)
                                .cornerRadius(12)
                        }
                    }
                }
                
                if let errorMessage = taskViewModel.errorMessage {
                    VStack {
                        Spacer()
                        Text(errorMessage)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.accentRed)
                            .cornerRadius(12)
                            .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .task {
                await taskViewModel.loadTasks()
            }
        }
    }
}
