//
//  File.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 03/12/2025.
//

import Foundation

public struct GoveeRequestBody: Codable {
    public let requestId: String
    public let payload: GoveeRequestPayload
}

public struct GoveeRequestPayload: Codable {
    public let sku: String
    public let device: String
    public let capability: GoveeRequestCapability?
}

public struct GoveeRequestCapability: Codable {
    public let type: GoveeDeviceCapabilityType
    public let instance: GoveeDeviceCapabilityInstance
    public let value: Int
}

public struct GoveeRGBColor: Codable {
    public let red: Int
    public let green: Int
    public let blue: Int
    
    var colorToInt: Int {
        ((red&0x0ff)<<16)|((green&0x0ff)<<8)|(blue&0x0ff)
    }
    
    public init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
}
