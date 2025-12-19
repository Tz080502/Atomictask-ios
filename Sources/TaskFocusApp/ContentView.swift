import SwiftUI

public struct ContentView: View {
    @StateObject private var supabaseService = SupabaseService.shared
    
    public init() {}
    
    public var body: some View {
        Group {
            if supabaseService.isAuthenticated {
                MainTaskView()
            } else {
                AuthView()
            }
        }
    }
}
