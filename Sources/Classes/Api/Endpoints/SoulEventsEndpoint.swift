enum SoulEventsEndpoint {
    case events
}

extension SoulEventsEndpoint: SoulEndpoint {
    var path: String {
        return "/events"
    }
}
