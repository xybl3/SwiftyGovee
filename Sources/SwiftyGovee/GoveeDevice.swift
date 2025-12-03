//
//  GoveeDevice.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 02/12/2025.
//

import Foundation

enum GoveeDeviceType: String, Codable {
    case light          = "devices.types.light"
    case airPurifier    = "devices.types.air_purifier"
    case thermometer    = "devices.types.thermometer"
    case socket         = "devices.types.socket"
    case sensor         = "devices.types.sensor"
    case heater         = "devices.types.heater"
    case humidifier     = "devices.types.humidifier"
    case deHumidifier   = "devices.types.dehumidifier"
    case iceMaker       = "devices.types.ice_maker"
    case aromaDiffuser  = "devices.types.aroma_diffuser"
    case box            = "devices.types.box"
    case unknown        // Fallback for new types
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = GoveeDeviceType(rawValue: rawValue ?? "") ?? .unknown
    }
}

enum GoveeDeviceCapabilityType: String, Codable {
    case online              = "devices.capabilities.online" // only for device state
    case onOff               = "devices.capabilities.on_off"
    case toggle              = "devices.capabilities.toggle"
    case range               = "devices.capabilities.range"
    case mode                = "devices.capabilities.mode"
    case colorSetting        = "devices.capabilities.color_setting"
    case segmentColorSetting = "devices.capabilities.segment_color_setting"
    case musicSetting        = "devices.capabilities.music_setting"
    case dynamicScene        = "devices.capabilities.dynamic_scene"
    case workMode            = "devices.capabilities.work_mode"
    case temperatureSetting  = "devices.capabilities.temperature_setting"
    case other
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = GoveeDeviceCapabilityType(rawValue: rawValue ?? "") ?? .other
    }
}

enum GoveeDeviceCapabilityInstance: String, Codable {
    // For GoveeDeviceCapabilityType.online
    case online = "online"
    
    // For GoveeDeviceCapabilityType.onOff
    case powerSwitch = "powerSwitch"
    
    // For GoveeDeviceCapabilityType.toggle
    case oscillationToggle = "oscillationToggle"
    case nightlightToggle = "nightlightToggle"
    case airDeflectorToggle = "airDeflectorToggle"
    case gradientToggle = "gradientToggle"
    case thermostatToggle = "thermostatToggle"
    case warmMistToggle = "warmMistToggle"
    
    // For GoveeDeviceCapabilityType.colorSetting
    case colorRgb = "colorRgb"
    case colorTemperature = "colorTemperatureK"
    
    // For GoveeDeviceCapabilityType.mode
    case nightlightScene = "nightlightScene"
    case presetScene = "presetScene" // for devices.types.aroma_diffuser
    
    // For GoveeDeviceCapabilityType.range
    case brightness = "brightness"
    case humidity = "humidity"
    
    // For GoveeDeviceCapabilityType.workMode
    case workMode = "workMode"
    
    // For GoveeDeviceCapabilityType.segmentColorSetting
    case segmentedColorRgb = "segmentedColorRgb"
    case segmentedBrightness = "segmentedBrightness"
    
    // For GoveeDeviceCapabilityType.temperatureSetting
    case targetTemperature = "targetTemperature"
    case sliderTemperature = "sliderTemperature"
}

struct GoveeDevice: Identifiable, Codable {
    
    var id: String {
        device
    }
    
    /// Product model
    let sku: String
    /// Device ID
    let device: String
    /// The device name in Govee Home App.
    let deviceName: String
    /// Device type
    let type: GoveeDeviceType?
    /// Device capabilities
    let capabilities: [GoveeDeviceCapability]

    
    enum CodingKeys: CodingKey {
        case sku
        case device
        case deviceName
        case type
        case capabilities
    }
}


