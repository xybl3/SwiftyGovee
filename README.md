# SwiftyGovee

SwiftyGovee is a lightweight Swift package that provides a minimal and fast implementation of basic Govee API functionality.

This package was created in the fastest possible way in order to become functional quickly.
It will be polished, improved, and expanded in the future.

Full API documentation is available at:
https://developer.govee.com/reference/get-you-devices

⸻

## Features

Current functionality includes:
    •    Fetching device list
    •    Turning devices on and off
    •    Setting RGB color (single RGB values, not segmented lighting)
    •    Adjusting brightness
    •    Adjusting color temperature in Kelvins
    •    Fetching the current state of a device

⸻

## Limitations

Govee sensors are not supported at this moment.
They may work with the underlying API, but no dedicated data models or convenience methods have been added for them yet.

⸻

## Examples

Below are usage examples based on the real tests included in the package.

### Device discovery

```swift
let client = GoveeClient(apiKey: "")

let devices = try await client.fetchDevices()
print("Devices:", devices)

guard let firstLight = devices.first(where: { $0.type == .light }) else {
    fatalError("No light devices found")
}

print("Selected device:", firstLight)
``` 

### Turn a device on or off
```swift
let client = GoveeClient(apiKey: "")

let devices = try await client.fetchDevices()
let device = devices[14]

try await client.turnDevice(on: true, device: device)
```

### Set RGB color

```swift
let client = GoveeClient(apiKey: "")

let devices = try await client.fetchDevices()
let device = devices[14]

// Red
try await client.setColorRGB(
    color: .init(red: 255, green: 0, blue: 0),
    device: device
)
try await Task.sleep(nanoseconds: 2_000_000_000)

// Green
try await client.setColorRGB(
    color: .init(red: 0, green: 255, blue: 0),
    device: device
)
try await Task.sleep(nanoseconds: 2_000_000_000)

// Blue
try await client.setColorRGB(
    color: .init(red: 0, green: 0, blue: 255),
    device: device
)
try await Task.sleep(nanoseconds: 2_000_000_000)

// White
try await client.setColorRGB(
    color: .init(red: 255, green: 255, blue: 255),
    device: device
)
```

### Set color temperature (Kelvins)

```swift
let client = GoveeClient(apiKey: "")

let devices = try await client.fetchDevices()
let device = devices[14]

try await client.setTemperatureK(temperatureK: 3000, device: device)
```

### Set brightness

```swift
let client = GoveeClient(apiKey: "")

let devices = try await client.fetchDevices()
let device = devices[14]

try await client.setBrightness(brightness: 100, device: device)
try await Task.sleep(nanoseconds: 2_000_000_000)

try await client.setBrightness(brightness: 1, device: device)
```

### Fetch device state
```swift
let client = GoveeClient(apiKey: "")

let devices = try await client.fetchDevices()
let device = devices[14]

let state = try await client.getDeviceState(device: device)
print("Device state:", state)
```

⸻

Contributions

Contributions are welcome.
If you would like to help improve structure, add sensor support, or expand functionality, feel free to open a pull request or file an issue.

