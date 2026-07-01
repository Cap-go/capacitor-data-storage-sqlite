//
//  Global.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 08/04/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation
struct Global {
    static var secretDefault: String = "test secret"
    static var newsecretDefault: String = "test new secret"

    var secret: String
    var newsecret: String

    init() {
        secret = Global.secretDefault
        newsecret = Global.newsecretDefault
    }

    static func configure(secret: String?, newSecret: String?) {
        if let secret = secret, !secret.isEmpty {
            secretDefault = secret
        }
        if let newSecret = newSecret, !newSecret.isEmpty {
            newsecretDefault = newSecret
        }
    }
}
