//
//  CreateTimerVC.swift
//  LocalNotificationsLab
//
//  Created by Oscar Victoria Gonzalez  on 2/20/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit

protocol NotificationControllerDelegate: AnyObject {
    func didCreateNotification(_ createNotification: CreateTimerVC)
}


class CreateTimerVC: UIViewController {
    
    weak var delegate: NotificationControllerDelegate?
    
    @IBOutlet weak var timePicker: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 5 // current time plus 5 seconds
    
    var hour: Double = 0
    var minutes: Double = 0
    var seconds: Double = 0
    
    var theTime = Double()
    
    var message = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        configureTimePicker()
        
    }
    
    func configureTimePicker() {
        timePicker.dataSource = self
        timePicker.delegate = self
    }
    
    private func createLocalNotification() {
        // step 1: create the content
        let content = UNMutableNotificationContent()
        content.title = titleTextField.text ?? "No Title"
        content.body = "\(message)"
        content.sound = .default
        
        // TODO: userInfo dictionary can hold additional data
        
        // step 2: create identifier
        let identifier = UUID().uuidString // unique string
        
        // 3 possible triggers
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: theTime, repeats: false)
        
        
        let requaet = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // add request to the UNNotificationCenter
        UNUserNotificationCenter.current().add(requaet) { (error) in
            if let error = error {
                print("error adding request: \(error)")
            } else {
                
            }
        }
    }
    
    
    @IBAction func enterButton(_ sender: UIButton) {
     createLocalNotification()
     delegate?.didCreateNotification(self)
     dismiss(animated: true)
    }
    
}

extension CreateTimerVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60
            
        default:
            return 0
        }
    }
    
}

extension CreateTimerVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row) hour"
        case 1:
            return "\(row) min"
        case 2:
            return "\(row) sec"
        default:
            return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
                case 0:
                    hour = Double(row * 3600)
                    print("\(hour) seconds")
                case 1:
                    minutes = Double(row * 60)
                    print("\(minutes) seconds")
                case 2:
                    seconds = Double(row)
                    print("\(seconds) seconds")
                default:
                    break;
                }
        let totalSeconds = hour + minutes + seconds
        let str = totalSeconds.asString(style: .full)
        message = str
        print(message)
        theTime = totalSeconds
        print(theTime)
    }
    
}

extension Double {
func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
  let formatter = DateComponentsFormatter()
  formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
  formatter.unitsStyle = style
  guard let formattedString = formatter.string(from: self) else { return "" }
  return formattedString
}
}
