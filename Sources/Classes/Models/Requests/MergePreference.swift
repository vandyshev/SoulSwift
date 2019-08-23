public enum MergePreference: String {
    case session
    case credentials
    case older
    case newer
}

extension MergePreference: Encodable {}
