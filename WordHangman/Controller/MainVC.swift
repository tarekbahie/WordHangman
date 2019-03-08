//
//  ViewController.swift
//  WordHangman
//
//  Created by tarek bahie on 3/8/19.
//  Copyright © 2019 tarek bahie. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func newGameBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toNewGame", sender: self)
    }
    
}

