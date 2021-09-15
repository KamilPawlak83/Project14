# Project14

### Project Description

This Project is my extension to Project14 from 100 Days of Swift by Paul Hudson: github.com/twostraws/HackingWithSwift/tree/main/Classic/project14.

During this Game you have to hit proper pinguins to score the highest result.
If you lose 3 lives or the 50 rounds elipse the game will be over.
Good luck :)

I added several important features like:
* 3 different levels,
* high score for each level(I used UserDefaults)
* high score list, 
* new game button, 
* new record label with info about your success,
* save your name if you break the record with 15 char limitation (I used UserDefaults), 
* 3 lives with graphic implementation - so game will be terminated if you lose your 3 lives or the number of rounds (50) will end, 
* simple app icon :)

### What We can learn from this code

* Mostly how to use SpriteKit :)
* How to create buttons in SKLabelNode
* We can understand how func touchesBegan works
* UserDefaults
* DispatchQueue.main.async
* How to play sound by SKAction.playSoundFileNamed
* Switch Case 
* how to add TextField to allertController
* and how to use delegate (textField.delegate) to change textField property (max 15 char)

### UI example

![Game](https://user-images.githubusercontent.com/73897166/133444753-075af67d-0f29-444a-80e1-35fa0302014c.png)


#### To Do List

* I want to reorganized info about New Record - right now user don't know if he see button or label.
* I want do add reset highscore Button (with biometric authentification).




