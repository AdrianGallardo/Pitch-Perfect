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
  enum RecordingState {case recording, notRecording}

  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    stopButton.isEnabled = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  @IBAction func recordAudio(_ sender: Any) {
    configUI(.recording)
    
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
    configUI(.notRecording)
    
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag{
      performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }else{
      print("Recording was not succeful")
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "stopRecording"{
      let playSoundsVC = segue.destination as! PlaySoundsViewController
      let recordedAudioURL = sender as! URL
      playSoundsVC.recordedAudioURL = recordedAudioURL
    }
  }
  
  //Configure UI to enable or disable record button.
  func configUI(_ recordingState: RecordingState){
    switch(recordingState) {
    case .recording:
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        recordingLabel.text = "Record in progresss"
    case .notRecording:
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        recordingLabel.text = "Tap to record"
    }
  }
  
}

