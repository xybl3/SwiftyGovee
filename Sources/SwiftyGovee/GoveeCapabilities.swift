//
//  GoveeCapabilities.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 03/12/2025.
//

import Foundation


struct GoveeDeviceCapability: Codable {
    let type: GoveeDeviceCapabilityType
    let instance: String
    let parameters: GoveeDeviceParameters?
}

enum GoveeDeviceParameters: Codable {
    case enumType(GoveeDeviceEnumParameters)
    case integerType(GoveeDeviceIntegerParameters)
    case structType(GoveeDeviceStructParameters)
    
    enum CodingKeys: String, CodingKey {
        case dataType
    }
    
    init(from decoder: any Decoder) throws {
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
    
    func encode(to encoder: any Encoder) throws {
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


struct GoveeDeviceEnumParameters: Codable {
    let dataType: String
    let options: [Option]

    struct Option: Codable {
        let name: String
        let value: Int
    }
}

struct GoveeDeviceIntegerParameters: Codable {
    let dataType: String
    let range: RangeValue
    let unit: String?

    struct RangeValue: Codable {
        let max: Int
        let min: Int
        let precision: Int
    }
}

struct GoveeDeviceStructParameters: Codable {
    let dataType: String
    let fields: [Field]

    struct Field: Codable {
        let fieldName: String
        let dataType: String
        let required: Bool
    }
}



