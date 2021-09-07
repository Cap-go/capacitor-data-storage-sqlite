//
//  ReturnHandler.swift
//  Plugin
//
//  Created by  Quéau Jean Pierre on 08/04/2021.
//  Copyright © 2021 Max Lynch. All rights reserved.
//

import Foundation
import Capacitor

class ReturnHandler {

    // MARK: - rResult

    func rResult(call: CAPPluginCall, ret: Bool? = nil,
                 message: String? = nil) {
        if let intMessage = message {
            call.reject(intMessage)
            return
        } else {
            if let res = ret {
                call.resolve(["result": res])
                return

            } else {
                call.resolve()
                return
            }
        }
    }

    // MARK: - rValue

    func rValue(call: CAPPluginCall, ret: String,
                message: String? = nil) {
        if let intMessage = message {
            call.reject(intMessage)
            return
        } else {
            call.resolve(["value": ret])
            return
        }
    }

    // MARK: - rDict

    func rDict(call: CAPPluginCall, ret: [String: [Any]],
               message: String? = nil) {
        if let intMessage = message {
            call.reject(intMessage)
            return
        } else {
            call.resolve(ret)
            return
        }
    }

    // MARK: - rChanges

    func rChanges(call: CAPPluginCall, ret: [String: Any],
                  message: String? = nil) {
        if let intMessage = message {
            call.reject(intMessage)
            return
        } else {
            call.resolve(["changes": ret])
            return
        }
    }

    // MARK: - rJsonStore

    func rJsonStore(call: CAPPluginCall, ret: [String: Any],
                    message: String? = nil) {
        if let intMessage = message {
            call.reject(intMessage)
            return
        } else {
            call.resolve(["export": ret])
            return
        }
    }

}
