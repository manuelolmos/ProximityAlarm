//
//  LogViewController.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 30/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {

    @IBOutlet weak var loggingTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            loggingTextView.text = try String(contentsOf: Logger.shared.loggingFileUrl, encoding: .utf8)
        } catch {}
    }
}
