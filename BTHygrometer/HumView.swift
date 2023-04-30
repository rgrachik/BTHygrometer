//
//  HumView.swift
//  BTHygrometer
//
//  Created by Роман Грачик on 29.04.2023.
//

import SwiftUI

struct BluetoothView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    
    var body: some View {
        VStack {
            Text(bluetoothManager.receivedData)
                .padding()
            Button("Connect") {
                bluetoothManager.connect()
            }
        }
    }
}


struct HumView_Previews: PreviewProvider {
    static var previews: some View {
        BluetoothView()
    }
}
