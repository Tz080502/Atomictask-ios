import Foundation

enum Constants {
    static let supabaseURL: String = {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String else {
            fatalError("SUPABASE_URL not found in Info.plist")
        }
        return url
    }()
    
    static let supabaseAnonKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String else {
            fatalError("SUPABASE_ANON_KEY not found in Info.plist")
        }
        return key
    }()
    
    static let maxSkipsPerDay = 3
    
    enum UserDefaultsKeys {
        static let lastSkipDate = "lastSkipDate"
        static let skipCount = "skipCount"
        static let sortPreference = "sortPreference"
    }
}

enum SortPreference: String, CaseIterable {
    case quickFirst = "Quick Tasks First"
    case hardFirst = "Hard Tasks First"
    
    var description: String {
        self.rawValue
    }
}
