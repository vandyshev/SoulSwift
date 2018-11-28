//
//  SoulAppService.swift
//  SoulSwift
//
//  Created by Евгений Вандышев on 28/11/2018.
//

protocol SoulAppService: class {
    /// Application feature toggles from Soul
    ///
    /// - Parameter completion: collection of features
    func features(anonymous: Bool, anonymousId: String, completion: () -> Void)
}
