//
//  SoundGenerator.swift
//  tvPlayMIDI
//
//  Created by Gene De Lisa on 6/8/14.
//  Copyright (c) 2014 Gene De Lisa. All rights reserved.
//

import Foundation
import AudioToolbox
import CoreAudio
import AVFoundation

class SoundGenerator  {
    
    var midiPlayer:AVMIDIPlayer!
    
    init() {
        createAVMIDIPlayer()
        setSessionPlayback()
        setSessionActive()
    }
    
    func setSessionPlayback() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
    }
    
    func setSessionActive() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    // not used here.
    func createAVMIDIPlayer(musicSequence:MusicSequence) {
        
        guard let bankURL = NSBundle.mainBundle().URLForResource("GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        }
        
        var status = OSStatus(noErr)
        var data:Unmanaged<CFData>?
        status = MusicSequenceFileCreateData (musicSequence,
            MusicSequenceFileTypeID.MIDIType,
            MusicSequenceFileFlags.EraseFile,
            480, &data)
        if status != noErr {
            print("error \(status)")
        }
        
        if let md = data {
            let midiData = md.takeUnretainedValue() as NSData
            do {
                try self.midiPlayer = AVMIDIPlayer(data: midiData, soundBankURL: bankURL)
                print("created midi player with sound bank url \(bankURL)")
            } catch let error as NSError {
                print("nil midi player")
                print("Error \(error.localizedDescription)")
            }
            data?.release()
            
            self.midiPlayer.prepareToPlay()
        }
        
    }
    
    func createAVMIDIPlayer() {
        
        guard let midiFileURL = NSBundle.mainBundle().URLForResource("sibeliusGMajor", withExtension: "mid") else {
            fatalError("\"sibeliusGMajor.mid\" file not found.")
        }
        
        guard let bankURL = NSBundle.mainBundle().URLForResource("GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        }
        
        //        guard let bankURL = NSBundle.mainBundle().URLForResource("gs_instruments", withExtension: "dls") else {
        //            fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
        //        }
        
        
        do {
            try self.midiPlayer = AVMIDIPlayer(contentsOfURL: midiFileURL, soundBankURL: bankURL)
            print("created midi player with sound bank url \(bankURL)")
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        self.midiPlayer.prepareToPlay()
    }
    
    // called fron the button's action
    func play() {
        dispatch_async(dispatch_queue_create("com.rockhoppertech.Play",nil), {
            
            self.midiPlayer.play { () -> Void in
                print("finished playing")
                self.midiPlayer.currentPosition = 0
            }
        })
    }
    
    
    func stop() {
        self.midiPlayer.stop()
    }
    
    
    
}

