//
//  Model.swift
//  testBT
//
//  Created by Роман Грачик on 29.04.2023.
//


import SwiftUI
import CoreBluetooth
import Foundation


let serviceUUID = CBUUID(string: "FFE0")
let characteristicUUID = CBUUID(string: "0xFFE1")

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic: CBCharacteristic!
    private var timer: Timer?
    
    @Published var temperature: Double = 0
    @Published var pressure: Double = 0
    @Published var humidity: Double = 0
    @Published var altitude: Double = 0
    
    var receivedData = Data()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
   
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            print("Bluetooth is not available")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        self.peripheral.delegate = self
        centralManager.stopScan()
        centralManager.connect(self.peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == characteristicUUID {
                    self.characteristic = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        
        if let data = characteristic.value {
            receivedData.append(data)
            
            if let jsonString = String(data: receivedData, encoding: .utf8) {
                print("Received JSON string: \(jsonString)")
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: receivedData, options: [])
                    if let jsonDict = jsonObject as? [String: Double],
                       let temperature = jsonDict["temperature"],
                       let pressure = jsonDict["pressure"],
                       let humidity = jsonDict["humidity"],
                       let altitude = jsonDict["altitude"] {
                        
                        DispatchQueue.main.async {
                                   // Обновляем значения свойств
                                   self.temperature = temperature
                                   self.pressure = pressure
                                   self.humidity = humidity
                                   self.altitude = altitude
                               }
                        
                        // Print the values to console
                        print("Temperature: \(temperature)°C")
                        print("Pressure: \(pressure) mm Hg")
                        print("Humidity: \(humidity) %")
                        print("Altitude: \(altitude) meters")
                        
                    }
                    
                    self.receivedData.removeAll()
                    
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
    }
}
