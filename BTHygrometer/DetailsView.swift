//
//  DetailsView.swift
//  BTHygrometer
//
//  Created by Роман Грачик on 20.05.2023.
//

import SwiftUI
import CoreData

struct DataListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: Parameters.entity(), sortDescriptors: [], animation: .default)
    private var yourEntities: FetchedResults<Parameters>

    var body: some View {
        List(yourEntities, id: \.self) { entity in
            Text("Temperature: \(entity.temperature)")
            Text("Humidity: \(entity.humidity)")
        }
        .environment(\.managedObjectContext, viewContext) // Связываем контекст Core Data
    }
}



struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DataListView()
    }
}
