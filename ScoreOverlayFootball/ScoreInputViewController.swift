//
//  ScoreInputViewController.swift
//  ScoreOverlayFootball
//
//  Created by Kyle Fenole on 9/11/17.
//  Copyright © 2017 Kyle Fenole. All rights reserved.
//

import Cocoa

class ScoreInputViewController: NSViewController {

    var scoreController: ViewController?
    @IBOutlet weak var openScoreButton: NSButtonCell!
    @IBOutlet weak var loadImgButton: NSButton!
    @IBOutlet weak var teamAScoreTextField: NSTextField!
    @IBOutlet weak var teamBScoreTextField: NSTextField!
    
    @IBOutlet weak var teamATOLTextField: NSTextField!
    @IBOutlet weak var teamBTOLTextField: NSTextField!
    
    @IBOutlet weak var downTextField: NSTextField!
    @IBOutlet weak var yardageTextFied: NSTextField!
    @IBOutlet weak var flagButton: NSButton!
    
    @IBOutlet weak var minutesTextField: NSTextField!
    //Static text field shoudl be seconds, typo im too lazy to change
    @IBOutlet weak var staticTextField: NSTextField!
    @IBOutlet weak var startTimeButton: NSButton!
    
    @IBOutlet weak var quarterTextField: NSTextField!
    
    @IBOutlet weak var halfButton: NSButton!
    @IBOutlet weak var otButton: NSButton!
    @IBOutlet weak var finalButton: NSButton!
    
    var timerIsRunning: Bool = false
    
    var clockCountdownTimer: Timer?
    var minutes: Int?
    var seconds: Int?
    
    var flag: Bool? = false
    
    var overlayImage: NSImage?
    
    var filePanel:NSOpenPanel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        
    }
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "a" {
            if let destination = segue.destinationController as? ViewController {
                // Disabling Button From here is a bit sloppy,but am too lazy to do segue programatically
                openScoreButton.isEnabled = false
                print(self.overlayImage)
                destination.overlayImage = self.overlayImage
                scoreController = destination
                doInitialLoad()

//                updateName(name: "Hello There")

            }
        }
    }
    @IBAction func teamAScoreTextFieldChanged(_ sender: NSTextField) {
        if let scoreAInt = Int(teamAScoreTextField.stringValue) {
            updateScoreA(scoreA: (scoreAInt))
        } else {
            print("Invalid entry for score A")
        }
    }
    @IBAction func teamBScoreTextFieldChanged(_ sender: NSTextField) {
        if let scoreBInt = Int(teamBScoreTextField.stringValue) {
            updateScoreB(scoreB: (scoreBInt))
        } else {
            print("Invalid entry for score B")
        }
    }
    @IBAction func teamATOLTextFieldChanged(_ sender: NSTextField) {
        if let tolAInt = Int(teamATOLTextField.stringValue) {
            updateTOLA(tolA: tolAInt)
        } else {
            print("Invalid entry for tol A")
        }
    }
    @IBAction func teamBTOLTextFieldChanged(_ sender: NSTextField) {
        if let tolBInt = Int(teamBTOLTextField.stringValue) {
            updateTOLB(tolB: tolBInt)
        } else {
            print("Invalid entry for tol B")
        }
    }
    @IBAction func downTextFieldChanged(_ sender: NSTextField) {
        if let downsInt = Int(downTextField.stringValue) {
            updateDowns(down: downsInt)
        } else {
            print("Invalid entry for Downs")
        }
    }
    @IBAction func yardageTextFieldChanged(_ sender: NSTextField) {
        if let yardInt = Int(yardageTextFied.stringValue) {
            updateYardage(yards: yardInt)
        } else {
            print("Invalid entry for yardage")
        }
    }
    @IBAction func minutesTextFieldChanged(_ sender: NSTextField) {
        if let minutesInt = Int(minutesTextField.stringValue) {
            updateMinutes(min: minutesInt)
        } else {
            print("Invalid entry for minutes")
        }
    }
    @IBAction func secondsTextFieldChanged(_ sender: NSTextField) {
        if let secondsInt = Int(staticTextField.stringValue) {
//            if secondsInt < 10
            updateSeconds(sec: secondsInt)
        } else {
            print("Invalid entry for seconds")
        }
    }
    @IBAction func startTimeButtonPressed(_ sender: NSButton) {
        if timerIsRunning == false {
            scoreController?.timeRunning = true
            timerIsRunning = true
            sender.title = "Stop"
            startCountdownTimer()
        } else {
            scoreController?.timeRunning = false
            timerIsRunning = false
            sender.title = "Start"
            stopCountdownTimer()
        }
    }
    
    @IBAction func halfButtonInteract(_ sender: NSButton) {
        if sender.state == NSControl.StateValue.on {
            updateSpecialTime(time: 0)
            otButton.state = NSControl.StateValue.off
            finalButton.state = NSControl.StateValue.off
        } else {
            updateSpecialTime(time: -1)
        }
    }
    @IBAction func otButtonInteract(_ sender: NSButton) {
        if sender.state == NSControl.StateValue.on {
            updateSpecialTime(time: 1)
            halfButton.state = NSControl.StateValue.off
            finalButton.state = NSControl.StateValue.off
        } else {
            updateSpecialTime(time: -1)
        }
    }
    @IBAction func finalButtonInteract(_ sender: NSButton) {
        if sender.state == NSControl.StateValue.on {
            updateSpecialTime(time: 2)
            otButton.state = NSControl.StateValue.off
            halfButton.state = NSControl.StateValue.off
        } else {
            updateSpecialTime(time: -1)
        }
    }
    @IBAction func quarterTextFieldChanged(_ sender: NSTextField) {
        if let quarterInt = Int(quarterTextField.stringValue) {
            updateQuarter(quarter: quarterInt)
        } else {
            print("Invalid entry for quarter")
        }
    }
    
    @IBAction func flagButtonPressed(_ sender: NSButton) {
        if flag == false {
            flag = true
        } else {
            flag = false
        }
        self.updateFlag(flag: self.flag!)
    }
    @IBAction func loadImgButtonPressed(_ sender: NSButton) {
        chooseImageDirectory()
        openScoreButton.isEnabled = true
    }
    
    
    func updateScoreA(scoreA: Int) {
        scoreController?.teamAScore = scoreA
    }
    func updateScoreB(scoreB: Int) {
        scoreController?.teamBScore = scoreB
    }
    func updateTOLA(tolA: Int) {
        scoreController?.teamATOL = tolA
    }
    func updateTOLB(tolB: Int) {
        scoreController?.teamBTOL = tolB
    }
    func updateDowns(down: Int) {
        scoreController?.down = down
    }
    func updateQuarter(quarter: Int) {
        scoreController?.quarter = quarter
    }
    func updateYardage(yards: Int) {
        scoreController?.yards = yards
    }
    func updateMinutes(min: Int) {
        scoreController?.minutes = min
    }
    func updateSeconds(sec: Int) {
        scoreController?.seconds = sec
    }
    func updateSpecialTime(time: Int) {
        scoreController?.specialTime = time
    }
    func updateTimeRunning(timeRun: Bool) {
        scoreController?.timeRunning = timeRun
    }
    func updateFlag(flag: Bool) {
        scoreController?.flag = flag
    }
    
    func startCountdownTimer() {
        //        self.clockCountdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.countdownOneSecond), userInfo: nil, repeats: true)
        if self.clockCountdownTimer == nil {
            self.clockCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                self.countdownOneSecond()
            })
        }
    }
    func stopCountdownTimer() {
        if self.clockCountdownTimer != nil {
            self.clockCountdownTimer?.invalidate()
            self.clockCountdownTimer = nil
        }
    }
    func countdownOneSecond() {
//        let currentClockString = self.clockLabel.stringValue
        let currentMinutes = minutesTextField.stringValue //currentClockString.components(separatedBy: ":")[0]
        let currentSeconds = staticTextField.stringValue //currentClockString.components(separatedBy: ":")[1]
        //        print(currentClockString)
        var newIntMinutes = 0
        if let intMinutes = Int(currentMinutes) {
            newIntMinutes = intMinutes
        }
        
        var newIntSeconds = 0
        var newStringSeconds = ""
        if let intSeconds = Int(currentSeconds) {
            
            if intSeconds == 0 {
                if newIntMinutes >= 1 {
                    newIntSeconds = 59
                    newIntMinutes -= 1
                } else {
                    // Invalidate Timer
                    newIntSeconds = 0
                    newIntMinutes = 0
                }
            } else {
                newIntSeconds = intSeconds - 1
            }
            newStringSeconds = "\(newIntSeconds)"
            if newIntSeconds < 10 {
                newStringSeconds = "0\(newIntSeconds)"
            }
            self.minutes = newIntMinutes
            self.seconds = newIntSeconds
        }
        let newClockString = "\(newIntMinutes)" + ":" + "\(newStringSeconds)"
        self.minutesTextField.stringValue = "\(newIntMinutes)"
        self.staticTextField.stringValue = "\(newStringSeconds)"
//        self.clockLabel.stringValue = "\(newClockString)"
    }
    func doInitialLoad() {

        if let scoreAInt = Int(teamAScoreTextField.stringValue) {
                updateScoreA(scoreA: (scoreAInt))
            } else {
                print("Invalid entry for score A")
            }


        if let scoreBInt = Int(teamBScoreTextField.stringValue) {
                updateScoreB(scoreB: (scoreBInt))
            } else {
                print("Invalid entry for score B")
            }


        if let tolAInt = Int(teamATOLTextField.stringValue) {
                updateTOLA(tolA: tolAInt)
            } else {
                print("Invalid entry for tol A")
            }


        if let tolBInt = Int(teamBTOLTextField.stringValue) {
                updateTOLB(tolB: tolBInt)
            } else {
                print("Invalid entry for tol B")
            }


        if let downsInt = Int(downTextField.stringValue) {
                updateDowns(down: downsInt)
            } else {
                print("Invalid entry for Downs")
            }


        if let yardInt = Int(yardageTextFied.stringValue) {
                updateYardage(yards: yardInt)
            } else {
                print("Invalid entry for yardage")
            }
        

        if let minutesInt = Int(minutesTextField.stringValue) {
                updateMinutes(min: minutesInt)
            } else {
                print("Invalid entry for minutes")
            }


        if let secondsInt = Int(staticTextField.stringValue) {
                //            if secondsInt < 10
                updateSeconds(sec: secondsInt)
            } else {
                print("Invalid entry for seconds")
            }


//        if timerIsRunning == false {
//                scoreController?.timeRunning = true
//                timerIsRunning = true
//                sender.title = "Stop"
//                startCountdownTimer()
//            } else {
//                scoreController?.timeRunning = false
//                timerIsRunning = false
//                sender.title = "Start"
//                stopCountdownTimer()
//            }

        

//        if sender.state == NSControl.StateValue.on {
//                updateSpecialTime(time: 0)
//                otButton.state = NSControl.StateValue.off
//                finalButton.state = NSControl.StateValue.off
//            } else {
//                updateSpecialTime(time: -1)
//            }
//
//
//        if sender.state == NSControl.StateValue.on {
//                updateSpecialTime(time: 1)
//                halfButton.state = NSControl.StateValue.off
//                finalButton.state = NSControl.StateValue.off
//            } else {
//                updateSpecialTime(time: -1)
//            }
//
//
//        if sender.state == NSControl.StateValue.on {
//                updateSpecialTime(time: 2)
//                otButton.state = NSControl.StateValue.off
//                halfButton.state = NSControl.StateValue.off
//            } else {
//                updateSpecialTime(time: -1)
//            }


        if let quarterInt = Int(quarterTextField.stringValue) {
                updateQuarter(quarter: quarterInt)
            } else {
                print("Invalid entry for quarter")
            }

    }
    func chooseImageDirectory() {
        filePanel = NSOpenPanel()
        filePanel?.title = "Choose Images Directory"
        filePanel?.defaultButtonCell?.title = "Select"
        filePanel?.canChooseDirectories = false
        filePanel?.canChooseFiles = true
        filePanel?.allowedFileTypes = ["png"]
        var url: URL?
        filePanel?.begin { (result) in
            if result.rawValue == NSFileHandlingPanelOKButton {
                url = self.filePanel?.urls[0]
                print("url", url)
                let imageFile = NSImage(byReferencing: url!)
                print("imageFile", imageFile)
                self.overlayImage = imageFile
            }
        }
    }

    
    
}
