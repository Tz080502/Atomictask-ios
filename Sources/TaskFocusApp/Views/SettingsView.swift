import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var swipeLimitService = SwipeLimitService.shared
    @StateObject private var supabaseService = SupabaseService.shared
    @State private var selectedSortPreference: SortPreference
    @State private var showSignOutAlert = false
    
    init() {
        _selectedSortPreference = State(initialValue: SwipeLimitService.shared.getSortPreference())
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    List {
                        Section {
                            Picker("Sort Preference", selection: $selectedSortPreference) {
                                ForEach(SortPreference.allCases, id: \.self) { preference in
                                    Text(preference.description).tag(preference)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: selectedSortPreference) { oldValue, newValue in
                                swipeLimitService.setSortPreference(newValue)
                            }
                        } header: {
                            Text("Task Sorting")
                        }
                        .listRowBackground(Color.cardBackground)
                        
                        Section {
                            HStack {
                                Text("Daily Skips Remaining")
                                Spacer()
                                Text("\(swipeLimitService.skipsRemaining)/\(Constants.maxSkipsPerDay)")
                                    .foregroundColor(.accentBlue)
                                    .fontWeight(.semibold)
                            }
                        } header: {
                            Text("Skip Limit")
                        } footer: {
                            Text("Right swipe to complete is unlimited. Left swipe to skip is limited to 3 per day.")
                        }
                        .listRowBackground(Color.cardBackground)
                        
                        Section {
                            if let user = supabaseService.currentUser {
                                HStack {
                                    Text("Email")
                                    Spacer()
                                    Text(user.email ?? "N/A")
                                        .foregroundColor(.textDark.opacity(0.6))
                                }
                            }
                            
                            Button(action: {
                                showSignOutAlert = true
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Sign Out")
                                        .foregroundColor(.accentRed)
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                            }
                        } header: {
                            Text("Account")
                        }
                        .listRowBackground(Color.cardBackground)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.accentBlue)
                }
            }
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    _Concurrency.Task {
                        try? await supabaseService.signOut()
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}
