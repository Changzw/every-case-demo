import UIKit

var greeting = "Hello, playground"

extension UserDefaults {
  var onboardingCompleted: Bool {
    get {
      print(#function)
      return bool(forKey: #function)
    }
    set {
      print(#function)
      set(newValue, forKey: #function)
    }
  }
}
print(UserDefaults.standard.onboardingCompleted)
UserDefaults.standard.onboardingCompleted = false
