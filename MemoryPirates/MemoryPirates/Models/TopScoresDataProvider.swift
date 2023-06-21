//
//  TopScoresDataProvider.swift
//  GameOfMemory
//
//  Created by Nigel Krajewski on 1/3/21.
//

import Foundation
import UIKit
import CoreData

protocol TopScoresDataProviderDelegate {
    func topScoresDataProviderDidInsert(indexPath: IndexPath)
}

class TopScoresDataProvider: NSObject, NSFetchedResultsControllerDelegate {
    
    // Delegate for data provider protocol
    var delegate: TopScoresDataProviderDelegate!
    // Vars for managed object
    var fetchResultsController: NSFetchedResultsController<Score>!
    var managedObjectContext: NSManagedObjectContext = AppDelegate.sharedContext
    var sections: [NSFetchedResultsSectionInfo]? {
        get {
            return self.fetchResultsController.sections
        }
    }
    
    // Initializer
    init(managedObjectContext: NSManagedObjectContext) {
        
        self.managedObjectContext = managedObjectContext
        let request = NSFetchRequest<Score>(entityName: "Score")
        request.sortDescriptors = [NSSortDescriptor(key: "elapsedTime", ascending: false)]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        self.fetchResultsController.delegate = self
        try! self.fetchResultsController.performFetch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            self.delegate.topScoresDataProviderDidInsert(indexPath: newIndexPath!)
        }
    }
    
    func object(at indexPath: IndexPath) -> Score {
        return self.fetchResultsController.object(at: indexPath)
    }
}
