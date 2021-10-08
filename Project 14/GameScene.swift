//
//  GameScene.swift
//  Project 14
//
//  Created by Kamil Pawlak on 05/08/2021.
//

import SpriteKit


class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var popupTime = 1.95
    var highscore1 = 0
    var highscore2 = 0
    var highscore3 = 0
    var level = 0
    var rounds = 0
    
    var bestPlayer1level = ""
    var bestPlayer2level = ""
    var bestPlayer3level = ""
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var newGameButton: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    var highScoresButton: SKLabelNode!
    var startGameButton: SKLabelNode!
    var level1Button: SKLabelNode!
    var level2Button: SKLabelNode!
    var level3Button: SKLabelNode!
    var highscore1Label: SKLabelNode!
    var highscore2Label: SKLabelNode!
    var highscore3Label: SKLabelNode!
    var backButton: SKLabelNode!
    var saveYourRecordButton: SKLabelNode!
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    
    
    override func didMove(to view: SKView) {
        
        //MARK: - Load Data
        let defaults = UserDefaults.standard
        highscore1 = defaults.integer(forKey: "Highscore1")
        highscore2 = defaults.integer(forKey: "Highscore2")
        highscore3 = defaults.integer(forKey: "Highscore3")
        
        bestPlayer1level = defaults.string(forKey: "BestPlayer1") ?? ""
        bestPlayer2level = defaults.string(forKey: "BestPlayer2") ?? ""
        bestPlayer3level = defaults.string(forKey: "BestPlayer3") ?? ""
        
        
        
        //MARK: - Front End (We create buttons,labels, slots and lives)
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        highScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highScoreLabel.position = CGPoint(x: 512, y: 8)
        highScoreLabel.fontSize = 48
        addChild(highScoreLabel)
        highScoreLabel.isHidden = true
        
        startGameButton = SKLabelNode(fontNamed: "Chalkduster")
        startGameButton.position = CGPoint(x: 512, y: 284)
        startGameButton.fontSize = 55
        startGameButton.zPosition = 1
        startGameButton.text = "Start Game"
        addChild(startGameButton)
        startGameButton.isHidden = false
        
        highScoresButton = SKLabelNode(fontNamed: "Chalkduster")
        highScoresButton.position = CGPoint(x: 512, y: 194)
        highScoresButton.fontSize = 55
        highScoresButton.zPosition = 1
        highScoresButton.text = "High Scores"
        addChild(highScoresButton)
        highScoresButton.isHidden = false
        
        newGameButton = SKLabelNode(fontNamed: "Chalkduster")
        newGameButton.position = CGPoint(x: 512, y: 284)
        newGameButton.fontSize = 55
        newGameButton.zPosition = 1
        newGameButton.text = "New Game"
        addChild(newGameButton)
        newGameButton.isHidden = true
        
        backButton = SKLabelNode(fontNamed: "Chalkduster")
        backButton.position = CGPoint(x: 512, y: 104)
        backButton.fontSize = 45
        backButton.zPosition = 1
        backButton.text = "Back"
        addChild(backButton)
        backButton.isHidden = true
        
        saveYourRecordButton = SKLabelNode(fontNamed: "Chalkduster")
        saveYourRecordButton.position = CGPoint(x: 512, y: 104)
        saveYourRecordButton.fontSize = 50
        saveYourRecordButton.zPosition = 1
        saveYourRecordButton.text = "Save Your Record"
        addChild(saveYourRecordButton)
        saveYourRecordButton.isHidden = true
        
        createLevelButons()
        createHighScoreLabels()
        createSlots()
        createLives()
        
    }
    
    //MARK: - What was Tapped
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        //MARK: - Check enemies and score points
        for node in tappedNodes {
            
            guard let whackSlot = node.parent?.parent as? WhackSlot else {continue} // we stop checking current item and we take another in array
            
            if !whackSlot.isVisible {continue}
            if whackSlot.isHit {continue}
            whackSlot.hit()
            
            if node.name == "charFriend" {
                score -= 2
                DispatchQueue.main.async {
                    self.run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                }
                whackSlot.charNode.xScale = 1.1
                whackSlot.charNode.yScale = 1.1
                subtractLife()
                
                
                
            } else if node.name == "charEnemy" {
                DispatchQueue.main.async {
                    self.run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                }
                whackSlot.charNode.xScale = 0.80
                whackSlot.charNode.yScale = 0.80
                score += 1
                
            }
        }
        
        //MARK: - check labels and buttons (probably tapped)
        if tappedNodes.contains(backButton) {
            startGameButton.isHidden = false
            highScoresButton.isHidden = false
            hideLevelButtons()
            highscore1Label.isHidden = true
            highscore2Label.isHidden = true
            highscore3Label.isHidden = true
            backButton.isHidden = true
        }
        
        if tappedNodes.contains(startGameButton) {
            startGameButton.isHidden = true
            highScoresButton.isHidden = true
            level1Button.isHidden = false
            level2Button.isHidden = false
            level3Button.isHidden = false
            backButton.isHidden = false
        }
        
        if tappedNodes.contains(highScoresButton) {
            startGameButton.isHidden = true
            highScoresButton.isHidden = true
            highscore1Label.isHidden = false
            highscore2Label.isHidden = false
            highscore3Label.isHidden = false
            backButton.isHidden = false
        }
        
        if tappedNodes.contains(newGameButton) {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: transition)
        }
        
        if tappedNodes.contains(saveYourRecordButton) {
            addYourNameToRecordList()
        }
        
        //MARK: - What Level was chosen?
        if tappedNodes.contains(level1Button) {
            level = 1
            startGame(highScoreLabelText: highscore1)
        }
        
        if tappedNodes.contains(level2Button) {
            level = 2
            popupTime = popupTime - (Double(level) / 10.0)
            startGame(highScoreLabelText: highscore2)
        }
        
        if tappedNodes.contains(level3Button) {
            level = 3
            popupTime = popupTime - (Double(level) / 8.0)
            startGame(highScoreLabelText: highscore3)
        }
    }
    
    
    //MARK: - Functions
    
    func createLives() {
        for i in 0 ..< 3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: CGFloat(834 + (i * 70)), y: 720)
            addChild(spriteNode)
            
            livesImages.append(spriteNode)
        }
    }
    
    func createSlots(){
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    }
    
    func createLevelButons() {
        level1Button = SKLabelNode(fontNamed: "Chalkduster")
        level1Button.position = CGPoint(x: 512, y: 374)
        level1Button.fontSize = 45
        level1Button.zPosition = 1
        level1Button.text = "Level 1"
        addChild(level1Button)
        level1Button.isHidden = true
        
        level2Button = SKLabelNode(fontNamed: "Chalkduster")
        level2Button.position = CGPoint(x: 512, y: 284)
        level2Button.fontSize = 45
        level2Button.zPosition = 1
        level2Button.text = "Level 2"
        addChild(level2Button)
        level2Button.isHidden = true
        
        level3Button = SKLabelNode(fontNamed: "Chalkduster")
        level3Button.position = CGPoint(x: 512, y: 194)
        level3Button.fontSize = 45
        level3Button.zPosition = 1
        level3Button.text = "Level 3"
        addChild(level3Button)
        level3Button.isHidden = true
    }
    
    func createHighScoreLabels() {
        highscore1Label = SKLabelNode(fontNamed: "Chalkduster")
        highscore1Label.position = CGPoint(x: 512, y: 374)
        highscore1Label.fontSize = 45
        highscore1Label.zPosition = 1
        highscore1Label.text = "Level 1 HS: \(highscore1) (\(bestPlayer1level))"
        addChild(highscore1Label)
        highscore1Label.isHidden = true
        
        highscore2Label = SKLabelNode(fontNamed: "Chalkduster")
        highscore2Label.position = CGPoint(x: 512, y: 284)
        highscore2Label.fontSize = 45
        highscore2Label.zPosition = 1
        highscore2Label.text = "Level 2 HS: \(highscore2) (\(bestPlayer2level))"
        addChild(highscore2Label)
        highscore2Label.isHidden = true
        
        highscore3Label = SKLabelNode(fontNamed: "Chalkduster")
        highscore3Label.position = CGPoint(x: 512, y: 194)
        highscore3Label.fontSize = 45
        highscore3Label.zPosition = 1
        highscore3Label.text = "Level 3 HS: \(highscore3) (\(bestPlayer3level))"
        addChild(highscore3Label)
        highscore3Label.isHidden = true
    }
    
    
    func createEnemy() {
        // If You have 0 lives return immediately
        if lives == 0 {return}
        
        rounds += 1
        
        //How many rounds game takes
        if rounds >= 50 {
            gameOver()
            checkNewRecord()
            return
        }
        
        popupTime *= 0.981
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 6 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in self?.createEnemy()
        }
    }
    
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func checkNewRecord() {
        
        switch level {
        case 1:
            if score > highscore1 {
                highScoreLabel.text = "Old Record: \(highscore1)"
                highscore1 = score
                addNewRecordLabel()
            }
        case 2:
            if score > highscore2 {
                highScoreLabel.text = "Old Record: \(highscore2)"
                highscore2 = score
                addNewRecordLabel()
            }
        case 3:
            if score > highscore3 {
                highScoreLabel.text = "Old Record: \(highscore3)"
                highscore3 = score
                addNewRecordLabel()
            }
        default:
            break
        }
    }
    
    func hideLevelButtons() {
        level1Button.isHidden = true
        level2Button.isHidden = true
        level3Button.isHidden = true
    }
    
    func startGame(highScoreLabelText: Int) {
        highScoreLabel.text = "Record: \(highScoreLabelText)"
        hideLevelButtons()
        backButton.isHidden = true
        highScoreLabel.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            [weak self] in self?.createEnemy()
        }
    }
    
    // this label will appear only if You break the record
    func addNewRecordLabel() {
        let highscoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        highscoreLabel.position = CGPoint(x: 512, y: 194)
        highscoreLabel.fontSize = 50
        highscoreLabel.zPosition = 1
        highscoreLabel.text = "New Record !!!"
        addChild(highscoreLabel)
        
        saveYourRecordButton.text = "Save Your Record"
        saveYourRecordButton.isHidden = false
    }
    
    func subtractLife() {
        lives -= 1
        
        var life: SKSpriteNode
        
        switch lives {
        case 2:
            life = livesImages[0]
        case 1:
            life = livesImages[1]
        case 0:
            life = livesImages[2]
            gameOver()
            // if You made 3 mistakes You can still break the record!
            checkNewRecord()
        default:
            return
        }
        
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration:0.1))
    }
    
    func gameOver() {
        for slot in slots {
            slot.hide()
        }
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 394)
        gameOver.zPosition = 1
        addChild(gameOver)
        newGameButton.isHidden = false
    }
    
    
}

extension GameScene: UITextFieldDelegate {
    
    func addYourNameToRecordList() {
        // This is the only place where we save data - if You won't write your name tha data (score) won't be saved
        let ac = UIAlertController(title: "Save Your New Record", message: "Enter Your Name - max 15 characters", preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.delegate = self
        }
        
        let submitAction = UIAlertAction(title: "OK", style: .default) {
            [weak ac] _ in
            guard let userName = ac?.textFields?[0].text else {return}
            
            switch self.level {
            case 1:
                self.bestPlayer1level = userName
                let defaults = UserDefaults.standard
                defaults.set(self.bestPlayer1level, forKey: "BestPlayer1")
                defaults.set(self.highscore1, forKey: "Highscore1")
            case 2:
                self.bestPlayer2level = userName
                let defaults = UserDefaults.standard
                defaults.set(self.bestPlayer2level, forKey: "BestPlayer2")
                defaults.set(self.highscore2, forKey: "Highscore2")
            case 3:
                self.bestPlayer3level = userName
                let defaults = UserDefaults.standard
                defaults.set(self.bestPlayer3level, forKey: "BestPlayer3")
                defaults.set(self.highscore3, forKey: "Highscore3")
            default:
                break
            }
        }
        
        ac.addAction(submitAction)
        self.view?.window?.rootViewController!.present(ac, animated: true, completion: nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        // max char = 15
        return updatedText.count <= 15
    }
    
}


