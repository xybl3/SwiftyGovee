//
//  GoveeDeviceState.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 03/12/2025.
//

import Foundation

/*
 {
     "requestId": "uuid",
     "msg": "success",
     "code": 200,
     "payload": {
         "sku": "H7143",
         "device": "52:8B:D4:AD:FC:45:5D:FE",
         "capabilities": [
             {
                 "type": "devices.capabilities.online",
                 "instance": "online",
                 "state": {
                     "value": false
                 }
             },
             {
                 "type": "devices.capabilities.on_off",
                 "instance": "powerSwitch",
                 "state": {
                     "value": 0
                 }
             },
             {
                 "type": "devices.capabilities.toggle",
                 "instance": "warmMistToggle",
                 "state": {
                     "value": 0
                 }
             },
             {
                 "type": "devices.capabilities.work_mode",
                 "instance": "workMode",
                 "state": {
                     "value": {
                         "workMode": 3,
                         "modeValue": 9
                     }
                 }
             },
             {
                 "type": "devices.capabilities.range",
                 "instance": "humidity",
                 "state": {
                     "value": ""
                 }
             },
             {
                 "type": "devices.capabilities.toggle",
                 "instance": "nightlightToggle",
                 "state": {
                     "value": 1
                 }
             },
             {
                 "type": "devices.capabilities.range",
                 "instance": "brightness",
                 "state": {
                     "value": 5
                 }
             },
             {
                 "type": "devices.capabilities.color_setting",
                 "instance": "colorRgb",
                 "state": {
                     "value": 16777215
                 }
             },
             {
                 "type": "devices.capabilities.mode",
                 "instance": "nightlightScene",
                 "state": {
                     "value": 5
                 }
             }
         ]
     }
 }
 */

struct GoveeDeviceStateResponse: Codable {
    let requestId: String
    let msg: String
    let code: Int
    let payload: GoveeDeviceStateResponsePayload
}

struct GoveeDeviceStateResponsePayload: Codable {
    let sku: String
    let device: String
    let capabilities: [GoveeDeviceStateCapability]
}

struct GoveeDeviceStateCapability: Codable {
    let type: String
    let instance: String
    let state: GoveeDeviceState
}

struct GoveeDeviceState: Codable {
    let value: GoveeDeviceStateValue
}

enum GoveeDeviceStateValue: Codable {
    case bool(Bool)
    case int(Int)
    case string(String)
    case workMode(GoveeDeviceWorkModeValue)

    // Struct for the workMode JSON object
    struct GoveeDeviceWorkModeValue: Codable {
        let workMode: Int
        let modeValue: Int
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
            return
        }

        if let int = try? container.decode(Int.self) {
            self = .int(int)
            return
        }

        if let workModeStruct = try? container.decode(GoveeDeviceWorkModeValue.self) {
            self = .workMode(workModeStruct)
            return
        }

        if let string = try? container.decode(String.self) {
            self = .string(string)
            return
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unsupported GoveeDeviceStateValue type"
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .bool(let b):
            try container.encode(b)
        case .int(let i):
            try container.encode(i)
        case .string(let s):
            try container.encode(s)
        case .workMode(let w):
            try container.encode(w)
        }
    }
}
