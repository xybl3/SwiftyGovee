//
//  GoveeDeviceState.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 03/12/2025.
//

import Foundation

public struct GoveeDeviceStateResponse: Codable {
    public let requestId: String
    public let msg: String
    public let code: Int
    public let payload: GoveeDeviceStateResponsePayload
}

public struct GoveeDeviceStateResponsePayload: Codable {
    public let sku: String
    public let device: String
    public let capabilities: [GoveeDeviceStateCapability]
}

public struct GoveeDeviceStateCapability: Codable {
    public let type: String
    public let instance: String
    public let state: GoveeDeviceState
}

public struct GoveeDeviceState: Codable {
    public let value: GoveeDeviceStateValue
}

public enum GoveeDeviceStateValue: Codable {
    case bool(Bool)
    case int(Int)
    case string(String)
    case workMode(GoveeDeviceWorkModeValue)

    // Struct for the workMode JSON object
    public struct GoveeDeviceWorkModeValue: Codable {
        let workMode: Int
        let modeValue: Int
    }

    public init(from decoder: Decoder) throws {
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

    public func encode(to encoder: Encoder) throws {
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
