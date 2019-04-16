//
//  ViewController.swift
//  SoulSwift
//
//  Created by Evgeny Vandyshev on 11/28/2018.
//  Copyright (c) 2018 Evgeny Vandyshev. All rights reserved.
//

import UIKit
import SoulSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeSoulSwift()
        downloadFeatures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - API Stuff

    func initializeSoulSwift() {
        let configuration = SoulConfiguration(
            baseURL: "https://testing-api.soulplatform.com",
            apiKey: "b9ef962ad2323fea17085bbe3fd7a35b",
            appName: "PureFTP"
        )
        SoulSwift.shared.setup(withSoulConfiguration: configuration)
    }

    func downloadFeatures() {
        SoulSwift.shared.soulApplicationService?.features(anonymousId: "CF6421EB-B450-41A0-A572-89FCE3FB0C2F", completion: {
            print("completion")
        })
    }

}
