public protocol SoulApplicationServiceType: class {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(anonymousId: String?, completion: @escaping () -> Void)
}
