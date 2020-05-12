//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Adrian Gallardo on 29/04/20.
//  Copyright © 2020 adriangallardo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
  
  var audioRecorder: AVAudioRecorder!

  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configUI(isRecording: false)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    guard flag else {
        print ("recording was not successful")
        return
    }
    performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "stopRecording"{
      let playSoundsVC = segue.destination as! PlaySoundsViewController
      let recordedAudioURL = sender as! URL
      playSoundsVC.recordedAudioURL = recordedAudioURL
    }
  }
  
  //MARK: - Buttons functions
  
  @IBAction func recordAudio(_ sender: Any) {
    configUI(isRecording: true)
    
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
    configUI(isRecording: false)
    
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
  
  //MARK: - UI Functions
  
  //Configure UI to enable or disable record button.
  func configUI(isRecording: Bool){
    recordingLabel.text = isRecording ? "Recording in progress" : "Tap to Record"
    recordButton.isEnabled = !isRecording
    stopButton.isEnabled = isRecording
  }

}

