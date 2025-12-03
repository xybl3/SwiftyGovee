//
//  GoveeError.swift
//  SwiftyGovee
//
//  Created by Olivier Marszałkowski on 02/12/2025.
//

import Foundation

public enum GoveeError: Error {
    case decodingError
    case rateLimitExceeded
    case unauthorizedApiKey
    case instanceNotFound
    
}

public enum GoveeDeviceError: Error {
    case unsupportedCapability(String)
    case invalidParameter(String)
}
