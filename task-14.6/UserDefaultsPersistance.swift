import Foundation

class UserDefaultsPersistance {
    static let shared = UserDefaultsPersistance();
    
    private let kUserNameKey = "UserDefaultsPersistance.kUserNameKey";
    var userName: String {
        set { UserDefaults.standard.set(newValue, forKey: kUserNameKey) }
        get { return UserDefaults.standard.string(forKey: kUserNameKey) ?? "" }
    }
}
