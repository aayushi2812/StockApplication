//
//  CoreDataManager.swift
//  StockApplication
//
//  Created by user265285 on 11/28/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "Model") // Replace with your .xcdatamodeld file name
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveStock(name: String, performanceId: String, status: String, rank: String) {
        let context = CoreDataManager.shared.context

        // Create a new Stock object
        let stock = Stock(context: context)
        
        // Set the attributes
        stock.name = name
        stock.performanceID = performanceId
        stock.rank = rank
        stock.status = status
        
        // Save the context
        do {
            try context.save()
            print("Stock saved successfully!")
        } catch {
            print("Failed to save stock: \(error)")
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Changes saved to Core Data")
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    func fetchStocks() -> [Stock] {
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        do {
            let stocks = try context.fetch(fetchRequest)
            return stocks
        } catch {
            print("Failed to fetch stocks: \(error)")
            return [] // Return an empty array in case of an error
        }
    }
    
    func deleteStock(_ stockName: String) {
        let context = persistentContainer.viewContext

        // Fetch the object to delete if it's a managed object
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", stockName)

        do {
            let results = try context.fetch(fetchRequest)
            if let stockEntity = results.first {
                context.delete(stockEntity)
                try context.save() // Persist the changes
                print("Successfully deleted stock: \(stockName)")
            }
        } catch {
            print("Failed to delete stock: \(error)")
        }
    }
    
    func updateStockStatus(for stockName: String, newStatus: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Stock> = Stock.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", stockName)

        do {
            let results = try context.fetch(fetchRequest)
            if let stockEntity = results.first {
                stockEntity.status = newStatus // Update the status
                try context.save()
                print("Updated stock status to \(newStatus)")
            }
        } catch {
            print("Failed to update stock status: \(error)")
        }
    }

}
