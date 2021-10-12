//
//  MessageBox.swift
//  WeatherApp(MVVM+combine)
//
//  Created by Sergey on 12.10.2021.
//

import Foundation
import UIKit



extension UIViewController{
    func messageBox(title: String, message: String, actionTitle: String, comment: String, logMessage: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(title, comment: comment), style: .default, handler: { _ in
            NSLog(logMessage)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
