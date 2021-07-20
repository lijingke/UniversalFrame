//
//  ViewController.swift
//  shopping
//
//  Created by 李京珂 on 2021/7/19.
//

import UIKit
import SnapKit
import TZImagePickerController

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        let label = UILabel(frame: .zero)
        label.text = "Hello World!"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
