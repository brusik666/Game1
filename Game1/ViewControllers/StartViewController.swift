//
//  ViewController.swift
//  Game1
//
//  Created by Brusik on 04.11.2022.
//

import UIKit

class StartViewController: UIViewController {
    
    var isSoundOn: Bool = false

    @IBOutlet weak var switchSoundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func startGameButtonTapped(_ sender: Any) {
    }
    @IBAction func switchSoundButtonTapped(_ sender: Any) {
        switch isSoundOn {
        case false:
            isSoundOn = true
            switchSoundButton.titleLabel?.text = "SOUND OFF"
        case true:
            isSoundOn = false
            switchSoundButton.titleLabel?.text = "SOUND ON"
        }
    }
    @IBSegueAction func startGameSegue(_ coder: NSCoder) -> GameViewController? {
        return GameViewController(coder: coder, sounds: isSoundOn)
    }
}

