//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jose Álvarez Vázquez on 8/1/21.
//

import UIKit
import AVFoundation
import Foundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: Outlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: Variables
    var audioRecorder: AVAudioRecorder!
    var identifierSegue: String = "stopRecording"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    // This function will change the state of the UIButtons
    func changeUIbuttons(isRecording: Bool){
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        recordingLabel.text = isRecording ? "Record in progress" : "Tap to Record"
    }
   
    // MARK: Actions
    @IBAction func recordAudio(_ sender: Any) {
        
        changeUIbuttons(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        changeUIbuttons(isRecording: false)

        audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: identifierSegue, sender: audioRecorder.url)
        } else {
            print("The recording wasn't successful")
        }
    }
    
    // This prepares the segue to PlaySoundsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifierSegue {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

