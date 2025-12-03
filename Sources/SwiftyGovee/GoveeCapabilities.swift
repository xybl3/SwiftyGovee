//
//  GoveeCapabilities.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 03/12/2025.
//

import Foundation


public struct GoveeDeviceCapability: Codable {
    public let type: GoveeDeviceCapabilityType
    public let instance: String
    public let parameters: GoveeDeviceParameters?
}

public enum GoveeDeviceParameters: Codable {
    case enumType(GoveeDeviceEnumParameters)
    case integerType(GoveeDeviceIntegerParameters)
    case structType(GoveeDeviceStructParameters)
    
    enum CodingKeys: String, CodingKey {
        case dataType
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataType = try container.decode(String.self, forKey: .dataType)
        
        let fullContainer = try decoder.singleValueContainer()
        
        switch dataType {
        case "ENUM":
            self = .enumType(try fullContainer.decode(GoveeDeviceEnumParameters.self))
        case "INTEGER":
            self = .integerType(try fullContainer.decode(GoveeDeviceIntegerParameters.self))
        case "STRUCT":
            self = .structType(try fullContainer.decode(GoveeDeviceStructParameters.self))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.dataType,
                in: container,
                debugDescription: "Unknown parameters type: \(dataType)"
            )
        }
        
    }
    
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .enumType(let value):
            try value.encode(to: encoder)
        case .integerType(let value):
            try value.encode(to: encoder)
        case .structType(let value):
            try value.encode(to: encoder)
        }
    }
}


public struct GoveeDeviceEnumParameters: Codable {
    public let dataType: String
    public let options: [Option]

    public struct Option: Codable {
        let name: String
        let value: Int
    }
}

public struct GoveeDeviceIntegerParameters: Codable {
    public let dataType: String
    public let range: RangeValue
    public let unit: String?

    public struct RangeValue: Codable {
        public let max: Int
        public let min: Int
        public let precision: Int
    }
}

public struct GoveeDeviceStructParameters: Codable {
    public let dataType: String
    public let fields: [Field]

    public struct Field: Codable {
        public let fieldName: String
        public let dataType: String
        public let required: Bool
    }
}



