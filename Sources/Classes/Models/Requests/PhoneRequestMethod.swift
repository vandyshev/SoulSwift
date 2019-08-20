public enum PhoneRequestMethod: String {
    case sms
    case callout
}

extension PhoneRequestMethod: Encodable {}
