//
//  Test.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 03/12/2025.
//

import Testing

@testable import SwiftyGovee

@Suite(.serialized)
struct Test {

    let client = GoveeClient(apiKey: "")
    
    @Test("Device discover")
    func discoverDevices() async throws {
        
        let devices = try await client.fetchDevices()
        
        #expect(!devices.isEmpty)
        
        #expect(devices[14].type == .light)
    }
    
    @Test("Power device off")
    func switchDevicePower() async throws {
        let devices = try await client.fetchDevices()
        #expect(!devices.isEmpty)
        
        let targetDevice = devices[14]
        
        #expect(targetDevice.type == .light)
        
        try await client.turnDevice(on: true, device: targetDevice)
    }
    
    @Test("Set device RGB color")
    func setDeviceRgb() async throws {
        let devices = try await client.fetchDevices()
        #expect(!devices.isEmpty)
        
        let targetDevice = devices[14]
        
        #expect(targetDevice.type == .light)
        
        try await client.setColorRGB(color: .init(red: 255, green: 0, blue: 0), device: targetDevice)
        
        try await Task.sleep(nanoseconds: 1_000_000_000 * 2)
        
        try await client.setColorRGB(color: .init(red: 0, green: 255, blue: 0), device: targetDevice)
        
        try await Task.sleep(nanoseconds: 1_000_000_000 * 2)
        
        try await client.setColorRGB(color: .init(red: 0, green: 0, blue: 255), device: targetDevice)
        
        try await Task.sleep(nanoseconds: 1_000_000_000 * 2)
        
        try await client.setColorRGB(color: .init(red: 255, green: 255, blue: 255), device: targetDevice)

    }
    
    @Test("Set color temperature")
    func setDeviceColorTemperature() async throws {
        let devices = try await client.fetchDevices()
        #expect(!devices.isEmpty)
        
        let targetDevice = devices[14]
        
        #expect(targetDevice.type == .light)
        
        try await client.setTemperatureK(temperatureK: 3000, device: targetDevice)
    }
    
    @Test("Set brightness")
    func setDeviceBrightness() async throws {
        let devices = try await client.fetchDevices()
        #expect(!devices.isEmpty)
        
        let targetDevice = devices[14]
        
        #expect(targetDevice.type == .light)
        
        try await client.setBrightness(brightness: 100, device: targetDevice)
        try await Task.sleep(nanoseconds: 1_000_000_000 * 2)
        try await client.setBrightness(brightness: 1, device: targetDevice)

    }
    
    @Test("DeviceState")
    func getDeviceState() async throws {
        let devices = try await client.fetchDevices()
        #expect(!devices.isEmpty)
        
        let targetDevice = devices[14]
        
        #expect(targetDevice.type == .light)
        try await client.getDeviceState(device: targetDevice)
    }
}
