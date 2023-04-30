import SwiftUI
import CoreBluetooth

let centralManager = CBCentralManager()

struct BltView: View {
    @State var temperature: Double = 0
    @State var humidity: Double = 0
    var arduinoPeripheral: CBPeripheral?

    var body: some View {
        VStack {
            Text("Temperature: \(temperature)")
            Text("Humidity: \(humidity)")
        }
        .onAppear {
            centralManager.delegate = self
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
}

struct BltView_Previews: PreviewProvider {
    static var previews: some View {
        BltView()
    }
}

extension BltView: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        arduinoPeripheral = peripheral
        centralManager.stopScan()
        centralManager.connect(arduinoPeripheral!, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}

extension BltView: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid == CBUUID(string: "2A6E") {
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == CBUUID(string: "2A6E") {
            let data = characteristic.value!
            let byteArray = [UInt8](data)
            let temperatureValue = Double(byteArray[1]) + (Double(byteArray[0]) / 100.0)
            let humidityValue = Double(byteArray[3]) + (Double(byteArray[2]) / 100.0)
            temperature = temperatureValue
            humidity = humidityValue
        }
    }
}

