///*
// Student:    Nigel Krajewski
// Term:       202012
// Course:     MDV3730-O
// */
//
////
////  ViewControllerExtension.swift
////  GameOfMemory
////
////  Created by Nigel Krajewski on 12/5/20.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//extension ViewController {
//    // ViewController extension to hold gameplay and animations
//    
//    // MARK: Game play
//    
//    // Start game by assigning and showing cards images for 5 seconds
//    func startGame() {
//        // Instance of new game
//        currentGame = Playthrough(cards: [Card])
//        // Clear any previous matched pairs
//        clearMatches()
//        // Drill down in stack view to get row count row count
//        guard let columnToCount = cardStackView.arrangedSubviews[0] as? UIStackView
//        else { return }
//        let rowCount = columnToCount.arrangedSubviews.count
//        
//        for i in 0..<currentGame.cardValues.count {
//            // Use division and mod to position images in stack view
//            guard let column = cardStackView.arrangedSubviews[i/rowCount] as? UIStackView,
//                  let cardButton = column.arrangedSubviews[i%rowCount] as? UIButton
//            else { return }
//            // Assign radomized pairs list image with matching int position
//            cardButton.setImage(UIImage(named: "cardFace\(currentGame.cardValues[i])"), for: .selected)
//            // Set matching tags for views (add 1 to avoid default 0 tag value)
//            cardButton.tag = i+1
//            // Give images springy appearance
//            animateScale(view: cardButton, minScale: 0.4, timesRepeating: 1)
//            resetButton.isEnabled.toggle()
//        }
//        // Show cards
//        flipAllCards()
//        // Set timer to hide cards after 5 seconds
//        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(flipAllCards), userInfo: nil, repeats: false)
//        playAudio(sound: "countDownSound", type: ".mp3")
//        // Wait 5 seconds then set playthrough start time after timer stops
//        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setStartTime), userInfo: nil, repeats: false)
//        if currentGame.startTime != nil {
//            // Start elapsed time counter
//            self.elapsedTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
//        }
//    }
//    
//    // Function to end game
//    func endGame() {
//        guard currentGame != nil
//            else { return }
//        if matchCount == 15 {
//            
//            // Finalize game values and add new score to core data
//            let newPlaythrough = NSEntityDescription.insertNewObject(forEntityName: "Score", into: self.managedObjectContext) as! Score
//            newPlaythrough.totalMoves = Int16(moves)
//            newPlaythrough.timeStarted = currentGame.startTime
//            newPlaythrough.playerName = UserDefaults.standard.string(forKey: "name")
//            newPlaythrough.elapsedTime = currentGame.startTime!.timeIntervalSinceNow
//
//            // Add score to game center leaderboard
//            // Pass elapsed time multipled by -100 to format for positive value in miliseconds
//            GameCenterManager().reportScore(chests: moves, timeInMilliseconds: Int(newPlaythrough.elapsedTime*(-100)))
//            
//            // Stop timer
//            elapsedTimer?.invalidate()
//            // End game animation and audio
//            playAudio(sound: "completeSound", type: ".mp3")
//            animateGameEnd()
//            
//            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(toggleGameState), userInfo: nil, repeats: false)
//            
//            // Save to CoreData
//            do {
//                print("We are here")
//                try managedObjectContext.save()
//            }
//            catch {
//                print("Error saving score in endGame function.")
//            }
//        }
//        // Clear playthrough and reset moves, match count and label
//        currentGame = nil
//        // Reset moves, match count and labels
//        moves = 0
//        matchCount = 0
//        matchedCountLabel.text = "\(matchCount.description) / 15"
//        moveCountLabel.text = moves.description
//        currentTimeLabel.text = "00:00:00"
//        
//        // TODO: Reload table view
//        
//    }
//    
//    // Function to assign card values for game playthrough
//    func assignValues() -> [Int] {
//        // Arrays to hold image numbers
//        var imageNumbers = [Int]()
//        // Get random number for face card value
//        var randomInt = Int()
//        var matchingNumbers = [Int]()
//        while imageNumbers.count < 15 {
//            // Get random int value
//            randomInt = Int.random(in: 1...143)
//            // Filter for matches to randomInt in arrayOfInts
//            matchingNumbers = imageNumbers.filter({ (number) -> Bool in
//                return number == randomInt
//            })
//            if matchingNumbers.count == 0 {
//                // Assign random int to array
//                imageNumbers.append(randomInt)
//            }
//        }
//        // Add image numbers to self
//        for int in 0..<imageNumbers.count {
//            imageNumbers.append(imageNumbers[int])
//        }
//        return imageNumbers.shuffled()
//    }
//    
//    // Clear matches
//    func clearMatches() {
//        for i in 0..<currentGame.cards.count {
//            // Make sure object is UIButton
//            guard let button = self.view.viewWithTag(i+1) as? UIButton
//            // Else check next object
//            else { continue }
//            // Reset button states and match list
//            button.isSelected = false
//            button.isUserInteractionEnabled = true
//            button.alpha = 1
//            matchAttempt.removeAll()
//        }
//    }
//    
//    // MARK: @objc functions
//    
//    // Check for match
//    @objc func matchCheck() {
//        // If guard passes, 2 buttons have been selected and can be compared
//        guard let cardOne = view.viewWithTag(matchAttempt[0]) as? UIButton,
//              let cardTwo = view.viewWithTag(matchAttempt[1]) as? UIButton
//        else { return }
//        // Increase move count
//        moves += 2
//        moveCountLabel.text = moves.description
//        // Compare card values
//        if cardOne.image(for: .selected) == cardTwo.image(for: .selected) {
//            playAudio(sound: "matchSound", type: ".mp3")
//            // Animate change to matched state
//            animateCardMatch(buttonOne: cardOne, buttonTwo: cardTwo)
//            // Clear matchAttempt add to match count
//            matchAttempt.removeAll()
//            matchCount += 1
//            // Update matched label
//            matchedCountLabel.text = "\(matchCount.description) / 15"
//            if matchCount == 15 {
//                endGame()
//            }
//        }
//        else {
//            playAudio(sound: "noMatchSound", type: ".mp3")
//            // Flip selected cards back
//            cardOne.isSelected = false
//            cardOne.isUserInteractionEnabled = true
//            cardTwo.isSelected = false
//            cardTwo.isUserInteractionEnabled = true
//            matchAttempt.removeAll()
//        }
//    }
//
//    // Function to all hide or show cards
//    @objc func flipAllCards() {
//        
//        for i in 0..<currentGame.cards.count {
//            // Make sure object is UIButton
//            guard let cardButton = self.view.viewWithTag(i+1) as? UIButton
//            // Else check next object
//            else { continue }
//            // Toggle button state and user interaction
//            cardButton.isSelected.toggle()
//            cardButton.isUserInteractionEnabled.toggle()
//        }
//        // Toggle reset button
//        resetButton.isEnabled.toggle()
//    }
//    
//    // Function to toggle play button and game state
//    @objc func toggleGameState() {
//        cardStackView.isUserInteractionEnabled.toggle()
//        playButton.isHidden.toggle()
//        playButton.isUserInteractionEnabled.toggle()
//        resetButton.isEnabled.toggle()
//        if !playButton.isHidden {
//            animateScale(view: playButton, minScale: 0.89, timesRepeating: .infinity)
//            cardStackView.alpha = 0.5
//        }
//        else {
//            cardStackView.alpha = 1.0
//        }
//    }
//    
//    // Function to diplay elapsed time
//    @objc func updateElapsedTime() {
//        // Create formatter to convert double to formatted string
//        let componentFormatter = DateComponentsFormatter()
//        componentFormatter.includesApproximationPhrase = false
//        componentFormatter.allowedUnits = [.hour, .minute, .second]
//        componentFormatter.unitsStyle = .positional
//        componentFormatter.zeroFormattingBehavior = .pad
//        // Set current time label with formatted elapsed time
//        currentTimeLabel.text = componentFormatter.string(from: currentGame.startTime?.timeIntervalSinceNow ?? 0)
//    }
//    
//    // Function to set start time
//    @objc func setStartTime() {
//        currentGame.startTime = Date()
//    }
//    
//    // MARK: Animations
//    
//    // Animation to add spring effect to view parameter
//    func animateScale(view: UIView, minScale: Float, timesRepeating: Float) {
//        // Create CASpringAnimation with key path to adjsut view scale
//        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
//        // Assign animation properties to effect view
//        springAnimation.duration = 4.5
//        springAnimation.fromValue = minScale
//        springAnimation.toValue = 1.0
//        springAnimation.autoreverses = false
//        springAnimation.repeatCount = timesRepeating
//        // Set springyness of view, lower value equals more bounce
//        springAnimation.damping = 1.0
//        // Add animation to parameter view's layer
//        view.layer.add(springAnimation, forKey: nil)
//    }
//    
//    // Animation to show then hide view
//    func viewFadeInFadeOut(view: UIView) {
//        // Create CABasic animation with key path to adjust view opacity
//        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
//        // Assign properties to animation
//        fadeAnimation.duration = 1
//        fadeAnimation.fromValue = 1.0
//        fadeAnimation.toValue = 0.8
//        fadeAnimation.autoreverses = false
//        fadeAnimation.repeatCount = 3
//        // Add to layer
//        view.layer.add(fadeAnimation, forKey: nil)
//    }
//    
//    // Animate card match
//    func animateCardMatch(buttonOne: UIButton, buttonTwo: UIButton) {
//        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
//            buttonOne.setImage(UIImage(named: "matchedImage"), for: .selected)
//            buttonOne.alpha = 0.5
//            buttonTwo.setImage(UIImage(named: "matchedImage"), for: .selected)
//            buttonTwo.alpha = 0.5
//        }
//        animator.startAnimation()
//    }
//    
//    // Playthough completed animation
//    @objc func animateGameEnd() {
//        // Create image and label to display completion animation
//        var winView = UIImageView(frame: CGRect(x: view.bounds.midX, y: view.bounds.midY, width: view.bounds.width/2, height: view.bounds.height/2))
//        let winLabel = UILabel(frame: CGRect(x: view.bounds.midX, y: view.bounds.midY, width: view.bounds.width/0.9, height: view.bounds.height/2))
//        // Set view contents
//        winView = UIImageView(image: UIImage(named: "completionImage"))
//        winView.alpha = 0.0
//        // Set label text parameters
//        winLabel.text = "GREAT JOB!"
//        winLabel.font = winLabel.font.withSize(60)
//        winLabel.adjustsFontSizeToFitWidth = true
//        winLabel.textColor = .white
//        winLabel.textAlignment = .center
//        winLabel.alpha = 0.0
//        view.addSubview(winView)
//        view.addSubview(winLabel)
//        viewFadeInFadeOut(view: winView)
//        viewFadeInFadeOut(view: winLabel)
//        // Center subViews within view
//        winView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2.5)
//        winLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 1.5)
//    }
//}
