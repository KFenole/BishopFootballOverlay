//
//  ViewController.swift
//  ScoreOverlayFootball
//
//  Created by Kyle Fenole on 9/8/17.
//  Copyright © 2017 Kyle Fenole. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var backgroundImaegView: NSImageView!
    
    @IBOutlet weak var teamALabel: NSTextField!
    @IBOutlet weak var teamAScoreLabel: NSTextField!
    
    @IBOutlet weak var teamBLabel: NSTextField!
    @IBOutlet weak var teamBScoreLabel: NSTextField!
    
    @IBOutlet weak var downYardageLabel: NSTextField!
    
    @IBOutlet weak var quarterLabel: NSTextField!
    @IBOutlet weak var clockLabel: NSTextField!
    
    @IBOutlet weak var teamATOLProgressI: NSProgressIndicator!
    @IBOutlet weak var teamATOLProgressII: NSProgressIndicator!
    @IBOutlet weak var teamATOLProgressIII: NSProgressIndicator!
    @IBOutlet weak var teamBTOLProgressI: NSProgressIndicator!
    @IBOutlet weak var teamBTOLProgressII: NSProgressIndicator!
    @IBOutlet weak var teamBTOLProgressIII: NSProgressIndicator!
    
    @IBOutlet weak var flagBGImageView: NSImageView!
    
    var teamAScore: Int?
    var teamBScore: Int?
    var teamATOL: Int?
    var teamBTOL: Int?
    
    var down: Int?
    var yards: Int?
    
    var quarter: Int?
    var minutes: Int?
    var seconds: Int?
    
    var specialTime: Int?
    
    // Bools
    var timeRunning: Bool? = false
    var flag: Bool?
    
    var overlayImage: NSImage?
    var loadedImage: Bool = false
    
    var clockCountdownTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.wantsLayer = true
        
        if overlayImage != nil {
            self.backgroundImaegView.image = self.overlayImage
        } else {
            print("nil fro the overlayimage")
        }
        
        if #available(OSX 10.12, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                
                // TeamA Score Refresh
                if self.teamAScore != nil {
                    self.teamAScoreLabel.stringValue = "\(self.teamAScore!)"
                } else {
                    print("Failed to get score for Team A")
                }
                // TeamB Score Refresh
                if self.teamBScore != nil {
                    self.teamBScoreLabel.stringValue = "\(self.teamBScore!)"
                } else {
                    print("Failed to get score for Team B")
                }
                // TeamA TOL Refresh
                if self.teamATOL != nil {
                    if self.teamATOL == 2 {
                        self.teamATOLProgressI.doubleValue = 1.0
                        self.teamATOLProgressII.doubleValue = 1.0
                        self.teamATOLProgressIII.doubleValue = 0.0
                    } else if self.teamATOL == 1 {
                        self.teamATOLProgressI.doubleValue = 1.0
                        self.teamATOLProgressII.doubleValue = 0.0
                        self.teamATOLProgressIII.doubleValue = 0.0
                    } else if self.teamATOL == 0 {
                        self.teamATOLProgressI.doubleValue = 0.0
                        self.teamATOLProgressII.doubleValue = 0.0
                        self.teamATOLProgressIII.doubleValue = 0.0
                    } else {
                        self.teamATOLProgressI.doubleValue = 1.0
                        self.teamATOLProgressII.doubleValue = 1.0
                        self.teamATOLProgressIII.doubleValue = 1.0
                    }
                } else {
                    print("Failed to get TOL for Team A")
                }
                // TeamA TOL Refresh
                if self.teamBTOL != nil {
                    if self.teamBTOL == 2 {
                        self.teamBTOLProgressI.doubleValue = 1.0
                        self.teamBTOLProgressII.doubleValue = 1.0
                        self.teamBTOLProgressIII.doubleValue = 0.0
                    } else if self.teamBTOL == 1 {
                        self.teamBTOLProgressI.doubleValue = 1.0
                        self.teamBTOLProgressII.doubleValue = 0.0
                        self.teamBTOLProgressIII.doubleValue = 0.0
                    } else if self.teamBTOL == 0 {
                        self.teamBTOLProgressI.doubleValue = 0.0
                        self.teamBTOLProgressII.doubleValue = 0.0
                        self.teamBTOLProgressIII.doubleValue = 0.0
                    } else {
                        self.teamBTOLProgressI.doubleValue = 1.0
                        self.teamBTOLProgressII.doubleValue = 1.0
                        self.teamBTOLProgressIII.doubleValue = 1.0
                    }
                } else {
                    print("Failed to get TOL for Team A")
                }
                // Yards and Down Refresh
                if self.down != nil && self.yards != nil {
                    var yardsString = "\(self.yards!)"
                    if self.yards! < 0 {
                        yardsString = "Goal"
                    }
                    var downString = "\(self.down)"
                    if self.down == 1 {
                        downString = "1st"
                    } else if self.down == 2 {
                        downString = "2nd"
                    } else if self.down == 3 {
                        downString = "3rd"
                    } else if self.down == 4 {
                        downString = "4th"
                    }
                    self.downYardageLabel.stringValue = "\(downString) and \(yardsString)"
                } else {
                    print("Failed to get yards and/or down")
                }
                // Quarter Refresh
                if self.quarter != nil {
                    var quarterString = "\(self.quarter!)"
                    if self.quarter == 4 {
                        quarterString = "4th"
                    } else if self.quarter == 3 {
                        quarterString = "3rd"
                    } else if self.quarter == 2 {
                        quarterString = "2nd"
                    } else if self.quarter == 1 {
                        quarterString = "1st"
                    }
                    if self.specialTime == 0 {
                        quarterString = "Half"
                    } else if self.specialTime == 1 {
                        quarterString = "OT"
                    } else if self.specialTime == 2 {
                        quarterString = "Final"
                    }
                    self.quarterLabel.stringValue = "\(quarterString)"
                } else {
                    print("Failed to get quarter")
                }
                //            if !self.timeRunning! {
                // Minute Refresh
                if self.minutes != nil {
                    let currentClockString = self.clockLabel.stringValue
                    let currentSeconds = currentClockString.components(separatedBy: ":")[1]
                    let newClockString = "\(self.minutes!)" + ":" + "\(currentSeconds)"
                    
                    self.clockLabel.stringValue = "\(newClockString)"
                    print(newClockString, "Min")
                } else {
                    print("Failed to get minutes")
                }
                // Second Refresh
                if self.seconds != nil {
                    let currentClockString = self.clockLabel.stringValue
                    let currentMinutes = currentClockString.components(separatedBy: ":")[0]
                    var secondsString = "\(self.seconds!)"
                    if self.seconds! < 10 {
                        secondsString = "0\(self.seconds!)"
                    }
                    let newClockString = "\(currentMinutes)" + ":" + "\(secondsString)"
                    
                    self.clockLabel.stringValue = "\(newClockString)"
                    print(newClockString, "Sec")
                } else {
                    print("Failed to get seconds")
                }
                //            }
                
                
                if self.timeRunning == true {
                    self.startCountdownTimer()
                } else {
                    if self.clockCountdownTimer != nil {
                        self.clockCountdownTimer?.invalidate()
                        self.clockCountdownTimer = nil
                    }
                }
                
                if self.flag == true {
                    self.downYardageLabel.stringValue = "FLAG"
                    //                self.downYardageLabel.textColor = NSColor.white
                    self.flagBGImageView.isHidden = false
                } else {
                    self.downYardageLabel.textColor = NSColor.black
                    self.flagBGImageView.isHidden = true
                }
                
                //Check if image has loaded
                if self.overlayImage != nil && self.loadedImage == false {
                    self.backgroundImaegView.image = self.overlayImage
                    self.loadedImage = true
                }
            })
        } else {
            // Fallback on earlier versions
            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.mainTimerStuffElCap), userInfo: nil, repeats: true)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    override func awakeFromNib() {
        if self.view.layer != nil {
//            let color: CGColor? = CGColor(red: 0.057, green: 0.978, blue: 0.000, alpha: 1.00)
            let color = CGColor(red: 0.035, green: 0.899, blue: 1.000, alpha: 1.00)
            self.view.layer?.backgroundColor = color
        }
//        overlayBackgroundImageView.layer?.backgroundColor = NSColor(calibratedRed: 0.592, green: 0.610, blue: 0.598, alpha: 1.00).cgColor
        
    }
    func startCountdownTimer() {
//        self.clockCountdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.countdownOneSecond), userInfo: nil, repeats: true)
        if self.clockCountdownTimer == nil {
            if #available(OSX 10.12, *) {
                self.clockCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (Timer) in
                    self.countdownOneSecond()
                })
            } else {
                // Fallback on earlier versions
                self.clockCountdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.countdownOneSecond), userInfo: nil, repeats: true)
            }
        }
    }
    @objc func countdownOneSecond() {
        let currentClockString = self.clockLabel.stringValue
        let currentMinutes = currentClockString.components(separatedBy: ":")[0]
        let currentSeconds = currentClockString.components(separatedBy: ":")[1]
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
        
        self.clockLabel.stringValue = "\(newClockString)"
    }
    func updateTOLQuarters() {
        teamATOLProgressI.controlTint = NSControlTint.blueControlTint //NSControlTint(rawValue: 0)!
    }
    @objc func mainTimerStuffElCap() {
        // TeamA Score Refresh
        if self.teamAScore != nil {
            self.teamAScoreLabel.stringValue = "\(self.teamAScore!)"
        } else {
            print("Failed to get score for Team A")
        }
        // TeamB Score Refresh
        if self.teamBScore != nil {
            self.teamBScoreLabel.stringValue = "\(self.teamBScore!)"
        } else {
            print("Failed to get score for Team B")
        }
        // TeamA TOL Refresh
        if self.teamATOL != nil {
            if self.teamATOL == 2 {
                self.teamATOLProgressI.doubleValue = 1.0
                self.teamATOLProgressII.doubleValue = 1.0
                self.teamATOLProgressIII.doubleValue = 0.0
            } else if self.teamATOL == 1 {
                self.teamATOLProgressI.doubleValue = 1.0
                self.teamATOLProgressII.doubleValue = 0.0
                self.teamATOLProgressIII.doubleValue = 0.0
            } else if self.teamATOL == 0 {
                self.teamATOLProgressI.doubleValue = 0.0
                self.teamATOLProgressII.doubleValue = 0.0
                self.teamATOLProgressIII.doubleValue = 0.0
            } else {
                self.teamATOLProgressI.doubleValue = 1.0
                self.teamATOLProgressII.doubleValue = 1.0
                self.teamATOLProgressIII.doubleValue = 1.0
            }
        } else {
            print("Failed to get TOL for Team A")
        }
        // TeamA TOL Refresh
        if self.teamBTOL != nil {
            if self.teamBTOL == 2 {
                self.teamBTOLProgressI.doubleValue = 1.0
                self.teamBTOLProgressII.doubleValue = 1.0
                self.teamBTOLProgressIII.doubleValue = 0.0
            } else if self.teamBTOL == 1 {
                self.teamBTOLProgressI.doubleValue = 1.0
                self.teamBTOLProgressII.doubleValue = 0.0
                self.teamBTOLProgressIII.doubleValue = 0.0
            } else if self.teamBTOL == 0 {
                self.teamBTOLProgressI.doubleValue = 0.0
                self.teamBTOLProgressII.doubleValue = 0.0
                self.teamBTOLProgressIII.doubleValue = 0.0
            } else {
                self.teamBTOLProgressI.doubleValue = 1.0
                self.teamBTOLProgressII.doubleValue = 1.0
                self.teamBTOLProgressIII.doubleValue = 1.0
            }
        } else {
            print("Failed to get TOL for Team A")
        }
        // Yards and Down Refresh
        if self.down != nil && self.yards != nil {
            var yardsString = "\(self.yards!)"
            if self.yards! < 0 {
                yardsString = "Goal"
            }
            var downString = "\(self.down)"
            if self.down == 1 {
                downString = "1st"
            } else if self.down == 2 {
                downString = "2nd"
            } else if self.down == 3 {
                downString = "3rd"
            } else if self.down == 4 {
                downString = "4th"
            }
            self.downYardageLabel.stringValue = "\(downString) and \(yardsString)"
        } else {
            print("Failed to get yards and/or down")
        }
        // Quarter Refresh
        if self.quarter != nil {
            var quarterString = "\(self.quarter!)"
            if self.quarter == 4 {
                quarterString = "4th"
            } else if self.quarter == 3 {
                quarterString = "3rd"
            } else if self.quarter == 2 {
                quarterString = "2nd"
            } else if self.quarter == 1 {
                quarterString = "1st"
            }
            if self.specialTime == 0 {
                quarterString = "Half"
            } else if self.specialTime == 1 {
                quarterString = "OT"
            } else if self.specialTime == 2 {
                quarterString = "Final"
            }
            self.quarterLabel.stringValue = "\(quarterString)"
        } else {
            print("Failed to get quarter")
        }
        //            if !self.timeRunning! {
        // Minute Refresh
        if self.minutes != nil {
            let currentClockString = self.clockLabel.stringValue
            let currentSeconds = currentClockString.components(separatedBy: ":")[1]
            let newClockString = "\(self.minutes!)" + ":" + "\(currentSeconds)"
            
            self.clockLabel.stringValue = "\(newClockString)"
            print(newClockString, "Min")
        } else {
            print("Failed to get minutes")
        }
        // Second Refresh
        if self.seconds != nil {
            let currentClockString = self.clockLabel.stringValue
            let currentMinutes = currentClockString.components(separatedBy: ":")[0]
            var secondsString = "\(self.seconds!)"
            if self.seconds! < 10 {
                secondsString = "0\(self.seconds!)"
            }
            let newClockString = "\(currentMinutes)" + ":" + "\(secondsString)"
            
            self.clockLabel.stringValue = "\(newClockString)"
            print(newClockString, "Sec")
        } else {
            print("Failed to get seconds")
        }
        //            }
        
        
        if self.timeRunning == true {
            self.startCountdownTimer()
        } else {
            if self.clockCountdownTimer != nil {
                self.clockCountdownTimer?.invalidate()
                self.clockCountdownTimer = nil
            }
        }
        
        if self.flag == true {
            self.downYardageLabel.stringValue = "FLAG"
            //                self.downYardageLabel.textColor = NSColor.white
            self.flagBGImageView.isHidden = false
        } else {
            self.downYardageLabel.textColor = NSColor.black
            self.flagBGImageView.isHidden = true
        }
        
        //Check if image has loaded
        if self.overlayImage != nil && self.loadedImage == false {
            self.backgroundImaegView.image = self.overlayImage
            self.loadedImage = true
        }
    }
}

