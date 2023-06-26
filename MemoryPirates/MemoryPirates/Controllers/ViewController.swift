///*
// Student:    Nigel Krajewski
// Term:       202012
// Course:     MDV3730-O
// */
//
////
////  ViewController.swift
////  GameOfMemory
////
////  Created by Nigel Krajewski on 11/30/20.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//class ViewController: UIViewController, UITableViewDelegate {
//    
//    // MARK: Trait collection override
//    
//    // Override trait collection for ipad portrait (w:c, h:r) to match iphone portrait view
//    override var traitCollection: UITraitCollection {
//        // If ipad in portrait mode change constraints
//        var traits = super.traitCollection
//        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
//            traits = UITraitCollection(traitsFrom:[UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
//        }
//        // Will return custom traits or super of trait collection depending on result of if check
//        return traits
//    }
//    /*
//     Console warning and bug still exist in trait override causing occassional improper layout of ipad portrait on launch.
//     This bug corrects itself when rotating device and does not reappear unless app is restarted.
//     Still looking for a better way to implement. May need to set constraints programmatically?
//     */
//    
//    // Override to prevent animation on orientaion change
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        coordinator.animate(alongsideTransition: nil, completion:
//                                {_ in
//            UIView.setAnimationsEnabled(false)
//        })
//    }
//    /* iPad still animates on first transition, additional transitions are not animated.*/
//    
//    // MARK: Core data
//    
//    // Create context for core data object
//    var managedObjectContext: NSManagedObjectContext = AppDelegate.sharedContext
//    
//    // MARK: Outlets, Variables
//    
//    // Outlets
//    @IBOutlet weak var navItem: UINavigationItem!
//    @IBOutlet weak var currentTimeLabel: UILabel!
//    @IBOutlet weak var bestTimeLabel: UILabel!
//    @IBOutlet weak var matchedCountLabel: UILabel!
//    @IBOutlet weak var moveCountLabel: UILabel!
//    @IBOutlet weak var cardStackView: UIStackView!
//    @IBOutlet weak var resetButton: UIBarButtonItem!
//    @IBOutlet weak var playButton: UIView!
//    
//    // Timer instance
//    var elapsedTimer: Timer?
//    // Array to hold tapped cards
//    var matchAttempt = [Int]()
//    // Var for match count
//    var matchCount = Int()
//    // Playthrough for current round
//    var currentGame: Playthrough!
//    // Int to track move count
//    var moves = 0
//    // String for player name
//    var playerName: String = UserDefaults.standard.string(forKey: "name") ?? ""
//    
//    
//    // MARK: ViewDidLoad
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Authenticate Game Center user
//        GameCenterManager().authenticatePlayer()
//        GameCenterManager().accessPoint.isActive = true
//        
//        if playButton != nil {
//            // Hide play button until game play check
//            playButton.isHidden = true
//            playButton.isUserInteractionEnabled = false
//            // Play opening sound
//            playAudio(sound: "launchSound", type: ".mp3")
//            // Begin game playthrough
//            if currentGame == nil {
//                toggleGameState()
//            }
//        }
//    }
//    
//    // MARK: Tap actions
//    
//    // Begin playThrough when play button tapped
//    @IBAction func handlePlayTap(_ sender: UIButton) {
//        toggleGameState()
//        startGame()
//        // Start elapsed time counter
//        self.elapsedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
//    }
//    
//    // Reset game via alert
//    @IBAction func handleGameReset(_ sender: UIBarButtonItem) {
//        // Create alert
//        let alert = UIAlertController(title: "Start new game?" , message: "Current game progress will be lost.", preferredStyle: UIAlertController.Style.alert)
//        // Create buttons
//        // Restart game if OK button tapped
//        let okButton = UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
//            self.endGame()
//            self.startGame()
//        })
//        // Else dismiss alert
//        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
//        // Add buttons to alert
//        alert.addAction(okButton)
//        alert.addAction(cancelButton)
//        // Show alert
//        self.present(alert, animated: true, completion:  nil)
//    }
//    
//    // Select cards
//    @IBAction func handleCardTap(_ sender: UIButton) {
//        // Change card state
//        if matchAttempt.count < 2 {
//            sender.isSelected = true
//            sender.isUserInteractionEnabled = false
//        }
//        matchAttempt.append(sender.tag)
//        // Delay match attempt to allow viewing of selections
//        if matchAttempt.count == 2 {
//            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(matchCheck), userInfo: nil, repeats: false)
//        }
//    }
//    
//    // MARK: Navigation
//    // Prepare segue by passing in games list and assigning protocol delegate
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "toOptions" {
////            let destination: ScoreBoardViewController = segue.destination as! ScoreBoardViewController
////            // Pass games to options view
////            destination.managedObjectContext = managedObjectContext
////            destination.topScoresDataProvider = topScoresDataProvider
////            // Hide Game center access point
////            GameCenterManager().accessPoint.isActive = false
////        }
////    }
//}
//
