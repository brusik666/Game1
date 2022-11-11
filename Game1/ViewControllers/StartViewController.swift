//
//  ViewController.swift
//  Game1
//
//  Created by Brusik on 04.11.2022.
//

import UIKit

class StartViewController: UIViewController {
    
    var isSoundOn: Bool = true

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
            switchSoundButton.setTitle("SOUND ON", for: .normal)
        case true:
            isSoundOn = false
            switchSoundButton.setTitle("SOUND OFF", for: .normal)
        }
    }
    @IBSegueAction func startGameSegue(_ coder: NSCoder) -> GameViewController? {
        return GameViewController(coder: coder, sounds: isSoundOn)
    }
}

