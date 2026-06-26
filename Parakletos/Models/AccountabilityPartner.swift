import Foundation
import SwiftData

/// Single-row model — one partner per user in v1.
@Model
final class AccountabilityPartner {
    var name: String
    var phoneNumber: String

    init(name: String = "", phoneNumber: String = "") {
        self.name = name
        self.phoneNumber = phoneNumber
    }

    /// Sanitised number safe to embed in a tel: URL.
    var dialableNumber: String {
        phoneNumber.filter { $0.isNumber || $0 == "+" }
    }
}
