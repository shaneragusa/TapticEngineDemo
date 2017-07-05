//
//  InterfaceController.swift
//  TapticEngineDemo WatchKit Extension
//
//  Created by Shane Ragusa on 5/30/17.
//  Copyright © 2017 Shane Ragusa. All rights reserved.
//

import WatchKit
import Foundation



class InterfaceController: WKInterfaceController {

    var repeatValue = Float(1.0)
    var currentPick = 0
    var timer = Timer()
    var list = LinkedList<Int>()
    var length = 0;
    var count = 0;
    
    var playPress = false;
    var pressed = [false, false, false, false, false, false, false]
    var vibTimer = Timer()
    
    @IBOutlet var notification: WKInterfaceButton!
    @IBOutlet var up: WKInterfaceButton!
    @IBOutlet var success: WKInterfaceButton!
    @IBOutlet var fail: WKInterfaceButton!
    @IBOutlet var start: WKInterfaceButton!
    @IBOutlet var stop: WKInterfaceButton!
    @IBOutlet var click: WKInterfaceButton!

    
    @IBOutlet var play: WKInterfaceButton!

    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        play.setBackgroundColor(UIColor.green)
        notification.setBackgroundColor(UIColor.gray)
        up.setBackgroundColor(UIColor.gray)
        success.setBackgroundColor(UIColor.gray)
        fail.setBackgroundColor(UIColor.gray)
        start.setBackgroundColor(UIColor.gray)
        stop.setBackgroundColor(UIColor.gray)
        click.setBackgroundColor(UIColor.gray)
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    
    //Changes the time at which vibrations will play in sequence
    @IBAction func sliderChange(_ value: Float) {
        repeatValue = value + 1.0
    }

    
    
    //The following 7 functions add the given vibration pattern to the sequence
    
    @IBAction func notifPressed() {
        if(!playPress && !pressed[0]){
        WKInterfaceDevice.current().play(WKHapticType.notification)
        list.append(value: 0)
        notification.setBackgroundColor(UIColor.blue)
        length+=1
        pressed[0] = true
        }
    }
    
    
    @IBAction func upPressed() {
        if(!playPress && !pressed[1]){
            WKInterfaceDevice.current().play(WKHapticType.directionUp)
        list.append(value: 1)
        up.setBackgroundColor(UIColor.blue)
        length+=1
        pressed[1]=true
        }
    }
    
    
    
    
    @IBAction func succPressed() {
        if(!playPress && !pressed[2]){
            WKInterfaceDevice.current().play(WKHapticType.success)
        list.append(value: 2)
        success.setBackgroundColor(UIColor.blue)
        length+=1
        pressed[2] = true
        }
    }
    
    
    @IBAction func failPressed() {
        if(!playPress && !pressed[3]){
            WKInterfaceDevice.current().play(WKHapticType.failure)
        list.append(value: 3)
        fail.setBackgroundColor(UIColor.blue)
        length+=1
        pressed[3] = true
        }
    }
    
    
    
    
    @IBAction func startPressed() {
        if(!playPress && !pressed[4]){
            WKInterfaceDevice.current().play(WKHapticType.start)
        list.append(value: 4)
        start.setBackgroundColor(UIColor.blue)
        length+=1
        pressed[4] = true
        }
    }

    
    @IBAction func stopPressed() {
        if(!playPress && !pressed[5]){
            WKInterfaceDevice.current().play(WKHapticType.stop)
        list.append(value: 5)
        stop.setBackgroundColor(UIColor.blue)
        length+=1
        pressed[5]=true
        }
    }
    
    @IBAction func clickPressed() {
        if(!playPress && !pressed[6]){
            WKInterfaceDevice.current().play(WKHapticType.click)
        list.append(value: 6)
        click.setBackgroundColor(UIColor.blue)
        length+=1
        pressed[6]=true
        }
    }

    
    func playVibration( value: Int){
        
        switch value{
            
        //Adv. 1
        case 0:
            WKInterfaceDevice.current().play(WKHapticType.notification)
            playNext(value: 1.0*repeatValue)
            break
            
        //Adv. 2
        case 1:
            WKInterfaceDevice.current().play(WKHapticType.directionUp)
            playNext(value: 0.4*repeatValue)
            break
            
        //Adv. 3
        case 2:
            WKInterfaceDevice.current().play(WKHapticType.success)
            playNext(value: 0.4*repeatValue)
            break
            
        //Basic 1
        case 3:
            WKInterfaceDevice.current().play(WKHapticType.failure)
            playNext(value: 0.6*repeatValue)
            break
            
        //Basic 2
        case 4:
            WKInterfaceDevice.current().play(WKHapticType.start)
            playNext(value: 0.2*repeatValue)
            break
            
        //Adv. 4
        case 5:
            WKInterfaceDevice.current().play(WKHapticType.stop)
            playNext(value: 0.5*repeatValue)
            
            break
            
        //Basic 3
        case 6:
            WKInterfaceDevice.current().play(WKHapticType.click)
            playNext(value: 0.15*repeatValue)
            break
            
            
        default:
            break
            
        }
        
    }

    
    //When the play button is pressed
    @IBAction func playPressed() {
        
        
        if(!playPress){
            play.setBackgroundColor(UIColor.red)
            play.setTitle("Stop")
            playPress = true
            playSequence()
        }
        
        else{
            invalidatePlay()
        }
    }

    
    func invalidatePlay(){
        playPress = false
        vibTimer.invalidate()
        play.setBackgroundColor(UIColor.green)
        play.setTitle("Play")
        count = 0

    }
   
    @IBAction func reset() {
        list.removeAll()
        invalidatePlay()
        length = 0
        notification.setBackgroundColor(UIColor.gray)
        up.setBackgroundColor(UIColor.gray)
        success.setBackgroundColor(UIColor.gray)
        fail.setBackgroundColor(UIColor.gray)
        start.setBackgroundColor(UIColor.gray)
        stop.setBackgroundColor(UIColor.gray)
        click.setBackgroundColor(UIColor.gray)
        pressed = [false, false, false, false, false, false, false]
        
    }
    
    //Plays the next vibration in the sequence
    func playNext(value: Float){
        
        vibTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(value), repeats: false) {
            
            (vibTimer) in
            if(self.count >= self.length){
                self.count = 0;
            }
            let current = self.list.nodeAt(index: self.count)
            self.count+=1
            self.playVibration(value: (current?.val())!)
        }
    }
    
    
    //Starts the vibration sequence
    func playSequence(){
        
        if(length>=1){
            
            let current = self.list.nodeAt(index: self.count)
            self.count+=1
            self.playVibration(value: (current?.val())!)
        
        }
    }
    
    
    
    
    
    
}















