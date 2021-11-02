//
//  HomeVC.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation
import UIKit

protocol DomainManageListDelegate: NSObjectProtocol {
    func cellTapSwitch(_ path: String , _ status: Bool)
}

class DomainManageListCell: UITableViewCell {

    @IBOutlet weak var titlelab: UILabel!
    @IBOutlet weak var switchBut: UIButton!
    // false:切换 true:删除
    var status: Bool = false
    var path: String = "" {
        didSet {
            titlelab.text = path
            if path == AppUserDefaults.shared.useDomain {
                titlelab.textColor = .red
                switchBut.isHidden = true
            } else {
                titlelab.textColor = .black
                switchBut.isHidden = false
            }
            if status {
                switchBut.setTitle("删除域名", for: .normal)
                switchBut.setTitleColor(.red, for: .normal)
            } else {
                switchBut.setTitle("切换域名", for: .normal)
                switchBut.setTitleColor(.systemBlue, for: .normal)
            }
        }
    }
    weak var delegate: DomainManageListDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tapSwitchAction(_ sender: Any) {
        self.delegate?.cellTapSwitch(path, status)
    }
    
}
