//
//  ViewController.swift
//  anchors
//
//  Created by John Richardson on 1/6/17.
//  Copyright © 2017 John Richardson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topView.backgroundColor = UIColor.blue
        
        topView.translatesAutoresizingMaskIntoConstraints = false

        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

