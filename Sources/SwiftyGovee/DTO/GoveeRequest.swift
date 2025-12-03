//
//  File.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 03/12/2025.
//

import Foundation

struct GoveeRequestBody: Codable {
    let requestId: String
    let payload: GoveeRequestPayload
}

struct GoveeRequestPayload: Codable {
    let sku: String
    let device: String
    let capability: GoveeRequestCapability?
}

struct GoveeRequestCapability: Codable {
    let type: GoveeDeviceCapabilityType
    let instance: GoveeDeviceCapabilityInstance
    let value: Int
}

struct GoveeRGBColor: Codable {
    let red: Int
    let green: Int
    let blue: Int
    
    var colorToInt: Int {
        ((red&0x0ff)<<16)|((green&0x0ff)<<8)|(blue&0x0ff)
    }
}
