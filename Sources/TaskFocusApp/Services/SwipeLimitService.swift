import Foundation

@MainActor
class SwipeLimitService: ObservableObject {
    static let shared = SwipeLimitService()
    
    @Published var skipsRemaining: Int = Constants.maxSkipsPerDay
    @Published var canSkip: Bool = true
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        checkAndResetIfNeeded()
        updateSkipsRemaining()
    }
    
    private func checkAndResetIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastSkipDate = userDefaults.object(forKey: Constants.UserDefaultsKeys.lastSkipDate) as? Date {
            let lastSkipDay = calendar.startOfDay(for: lastSkipDate)
            
            if today > lastSkipDay {
                resetDailyLimit()
            }
        } else {
            resetDailyLimit()
        }
    }
    
    private func resetDailyLimit() {
        userDefaults.set(0, forKey: Constants.UserDefaultsKeys.skipCount)
        userDefaults.set(Date(), forKey: Constants.UserDefaultsKeys.lastSkipDate)
        updateSkipsRemaining()
    }
    
    private func updateSkipsRemaining() {
        let currentCount = userDefaults.integer(forKey: Constants.UserDefaultsKeys.skipCount)
        skipsRemaining = max(0, Constants.maxSkipsPerDay - currentCount)
        canSkip = skipsRemaining > 0
    }
    
    func recordSkip() {
        let currentCount = userDefaults.integer(forKey: Constants.UserDefaultsKeys.skipCount)
        let newCount = currentCount + 1
        
        userDefaults.set(newCount, forKey: Constants.UserDefaultsKeys.skipCount)
        userDefaults.set(Date(), forKey: Constants.UserDefaultsKeys.lastSkipDate)
        
        updateSkipsRemaining()
    }
    
    func getSortPreference() -> SortPreference {
        if let savedPreference = userDefaults.string(forKey: Constants.UserDefaultsKeys.sortPreference),
           let preference = SortPreference(rawValue: savedPreference) {
            return preference
        }
        return .quickFirst
    }
    
    func setSortPreference(_ preference: SortPreference) {
        userDefaults.set(preference.rawValue, forKey: Constants.UserDefaultsKeys.sortPreference)
    }
}
