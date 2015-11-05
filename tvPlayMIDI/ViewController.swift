//
//  ViewController.swift
//  tvPlayMIDI
//
//  Created by Gene De Lisa on 11/5/15.
//  Copyright © 2015 Gene De Lisa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let generator = SoundGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playAction(sender: UIButton) {
        generator.play()
    }

}

