//
//  CoreDataManager.swift
//  BTHygrometer
//
//  Created by Роман Грачик on 20.05.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() // Создание синглтона (одиночки)
    
    private init() {} // Приватный инициализатор, чтобы предотвратить создание экземпляров класса извне
    
    // Ленивое свойство для доступа к контексту CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Parameters") // Замените "YourDataModel" на имя вашей модели данных CoreData
        
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Ошибка инициализации контейнера CoreData: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    // Получение контекста CoreData
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Сохранение контекста CoreData
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("Контекст CoreData сохранен")
            } catch {
                let nsError = error as NSError
                fatalError("Ошибка при сохранении контекста CoreData: \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
