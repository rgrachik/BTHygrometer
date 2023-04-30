//
//  ContentView.swift
//  BTHygrometer
//
//  Created by Роман Грачик on 28.04.2023.
//

import SwiftUI
import CoreBluetooth
import Foundation


struct ContentView: View {
    
    @State var darkMode = false
    @StateObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        
        VStack {
            HStack {
                Text(Date(), style: .date)
                Text(Date(), style: .time)
            }
            .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                
                HStack {
                    Image(systemName: "thermometer.medium")
                        .padding()
                        .foregroundColor(.gray)
                        .font(.system(size: 25))
                    Text("\(bluetoothManager.temperature, specifier: "%.0f")°C")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
                HStack {
                    Image(systemName: "gauge.medium")
                        .padding()
                        .foregroundColor(.gray)
                        .font(.system(size: 25))
                    Text("\(bluetoothManager.pressure, specifier: "%.1f") mm Hg")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
                HStack {
                    Image(systemName: "humidity")
                        .padding()
                        .foregroundColor(.gray)
                        .font(.system(size: 25))
                    Text("\(bluetoothManager.humidity, specifier: "%.0f") %")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
                HStack {
                    Image(systemName: "mount")
                        .padding()
                        .foregroundColor(.gray)
                        .font(.system(size: 25))
                    Text("\(bluetoothManager.altitude, specifier: "%.0f") m")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
            }
            .padding()
            .preferredColorScheme(darkMode == true ? .dark: .light)
            Toggle(isOn: $darkMode) {
                Text("Dark mode")
            }
            .foregroundColor(.gray)
            .tint(.orange)
            
            .padding()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

