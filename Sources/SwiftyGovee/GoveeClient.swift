//
//  GoveeClient.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 02/12/2025.
//

import Foundation

struct GoveeDiscoverDeviceResponse: Codable {
    let code: Int
    let message: String
    let data: [GoveeDevice]
}

class GoveeClient {
    private let decoder = JSONDecoder()
    private let baseUrl = "https://openapi.api.govee.com"
    
    enum Endpoint: String {
        case devices        = "router/api/v1/user/devices"
        case deviceControl  = "router/api/v1/device/control"
        case deviceState    = "router/api/v1/device/state"
    }
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchDevices() async throws -> [GoveeDevice] {
        let url = URL(string: "\(baseUrl)/\(Endpoint.devices.rawValue)")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Govee-API-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let dec = try decoder.decode(GoveeDiscoverDeviceResponse.self, from: data)
        
        return dec.data
    }
    
    func getDeviceState(device: GoveeDevice) async throws {
        let url = URL(string: "\(baseUrl)/\(Endpoint.deviceState.rawValue)")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Govee-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body = GoveeRequestBody(
            requestId: UUID().uuidString,
            payload: GoveeRequestPayload(
                sku: device.sku,
                device: device.device,
                capability: nil
            )
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        print(httpResponse.statusCode)
        
        let parsed = try decoder.decode(GoveeDeviceStateResponse.self, from: data)
        print(parsed)
    }
    
    func turnDevice(on: Bool, device: GoveeDevice) async throws {
        guard device.capabilities.contains(where: { $0.type == .onOff }) else {
            throw GoveeDeviceError.unsupportedCapability(GoveeDeviceCapabilityType.onOff.rawValue)
        }
        
        let url = URL(string: "\(baseUrl)/\(Endpoint.deviceControl.rawValue)")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Govee-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body = GoveeRequestBody(
            requestId: UUID().uuidString,
            payload: GoveeRequestPayload(
                sku: device.sku,
                device: device.device,
                capability: GoveeRequestCapability(
                    type: .onOff,
                    instance: .powerSwitch,
                    value: on ? 1 : 0
                )
            )
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        
//        TODO: Response handler
        
    }
    
    func setColorRGB(color: GoveeRGBColor, device: GoveeDevice) async throws {
        guard device.capabilities.contains(where: { $0.type == .colorSetting }) else {
            throw GoveeDeviceError.unsupportedCapability(GoveeDeviceCapabilityType.colorSetting.rawValue)
        }
        
        let url = URL(string: "\(baseUrl)/\(Endpoint.deviceControl.rawValue)")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Govee-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body = GoveeRequestBody(
            requestId: UUID().uuidString,
            payload: GoveeRequestPayload(
                sku: device.sku,
                device: device.device,
                capability: GoveeRequestCapability(
                    type: .colorSetting,
                    instance: .colorRgb,
                    value: color.colorToInt
                )
            )
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
    }
    
    func setTemperatureK(temperatureK: Int, device: GoveeDevice) async throws {
        guard device.capabilities.contains(where: { $0.type == .colorSetting }) else {
            throw GoveeDeviceError.unsupportedCapability(GoveeDeviceCapabilityType.colorSetting.rawValue)
        }
        
        guard temperatureK >= 2000 && temperatureK <= 9000 else {
            throw GoveeDeviceError.invalidParameter("Temperature must be between 2000 and 9000 K")
        }
        
        let url = URL(string: "\(baseUrl)/\(Endpoint.deviceControl.rawValue)")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Govee-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body = GoveeRequestBody(
            requestId: UUID().uuidString,
            payload: GoveeRequestPayload(
                sku: device.sku,
                device: device.device,
                capability: GoveeRequestCapability(
                    type: .colorSetting,
                    instance: .colorTemperature,
                    value: temperatureK
                )
            )
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
    }
    
    func setBrightness(brightness: Int, device: GoveeDevice) async throws {
        guard device.capabilities.contains(where: { $0.type == .range }) else {
            throw GoveeDeviceError.unsupportedCapability(GoveeDeviceCapabilityType.range.rawValue)
        }
        
        guard brightness >= 1 && brightness <= 100 else {
            throw GoveeDeviceError.invalidParameter("Brightness must be between 1 and 100")
        }
        
        let url = URL(string: "\(baseUrl)/\(Endpoint.deviceControl.rawValue)")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Govee-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body = GoveeRequestBody(
            requestId: UUID().uuidString,
            payload: GoveeRequestPayload(
                sku: device.sku,
                device: device.device,
                capability: GoveeRequestCapability(
                    type: .range,
                    instance: .brightness,
                    value: brightness
                )
            )
        )
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
    }
}
