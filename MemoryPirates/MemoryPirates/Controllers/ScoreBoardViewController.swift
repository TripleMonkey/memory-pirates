//
//  ScoreBoardViewController.swift
//  GameOfMemory
//
//  Created by Nigel Krajewski on 12/17/20.
//

import UIKit
import CoreData


class ScoreBoardViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: Outlets and variables
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recordsTableView: UITableView!
    // String for player name
    var playerName: String = "New Player"
    
    
    // MARK: Core data
    
    // Context for core data object
    var managedObjectContext: NSManagedObjectContext = AppDelegate().persistentContainer.viewContext
    // Data provider
    var topScoresDataProvider: TopScoresDataProvider!
    // Data Source
    var topScoresDataSource: TopScoresDataSource!
    
    // MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set player name
        playerName = UserDefaults.standard.string(forKey: "name") ?? "New Player"
        nameTextField.text = playerName
        // Assign self as delegates
        nameTextField.delegate = self
        recordsTableView.delegate = self
        
        loadTopScores()
    }
    
    // Function to fill topScore table from saved data
    func loadTopScores() {
        // Initialize data provider
        self.topScoresDataProvider = TopScoresDataProvider(managedObjectContext: self.managedObjectContext)
        // Initialize data source
        self.topScoresDataSource = TopScoresDataSource(cellIdentifier: "reuseScoreCell01", tableView: self.recordsTableView, topScoresDataProvider: self.topScoresDataProvider)
        // Assign source to table
        self.recordsTableView.dataSource = self.topScoresDataSource
        self.recordsTableView.reloadData()
    }
    
    // MARK: Textfield delegate
    
    // Change returnKeyType based on textField text
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Change return key to Done when text entered
        if textField.text?.trimmingCharacters(in: [" ", "\t"]) != "", textField.returnKeyType == .default {
            textField.returnKeyType = .done
            textField.reloadInputViews()
        }
        // Change back to default style if all text removed
        else if textField.text?.trimmingCharacters(in: [" ", "\t"]) == "", textField.returnKeyType == .done {
            textField.returnKeyType = .default
            textField.reloadInputViews()
        }
    }
    
    // Assign player name when return key tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // If text was entered assign as player name
        playerName = textField.text?.trimmingCharacters(in: [" ", "\t"]) ?? ""
        // Hide keyboard
        textField.resignFirstResponder()
        // Show name change alert
        //PlayerProfile.shared.name = playerName
        UserDefaults.standard.set(playerName, forKey: "name")
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed to save after updating player name.")
        }
        showNameChangeAlert()
        return true
    }
    
    // Hide keyboard when tap anywhere outside keyboard or textfield
    override func touchesBegan(_ touch: Set<UITouch>, with event: UIEvent?) {
        // Use endEditing method to resign current first responder
        view.endEditing(true)
        super.touchesBegan(touch, with: event)
    }
    
    // MARK: Name change alert
    
    // Show alert to confirm name change
    func showNameChangeAlert() {
        let alert = UIAlertController(title: "Player name changed.", message: "Hello, \(playerName)!", preferredStyle: .alert)
        let continueButton = UIAlertAction(title: "Continue", style: .default, handler: nil)
        alert.addAction(continueButton)
        // Show Alert
        self.present(alert, animated: true, completion: nil)
    }
}
