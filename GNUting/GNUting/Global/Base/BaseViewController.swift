//
//  BaseViewController.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import UIKit

class BaseViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
    }
    func setBackgroundColor() {
        view.backgroundColor = .white
    }
}
