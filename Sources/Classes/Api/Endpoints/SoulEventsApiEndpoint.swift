enum SoulEventsApiEndpoint {
    case events
}

extension SoulEventsApiEndpoint: SoulApiEndpoint {
    var path: String {
        return "/events"
    }
}
