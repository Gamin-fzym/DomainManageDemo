//
//  NetstatAlertVC.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import UIKit

class NetstatAlertVC: UIViewController {

    @IBOutlet weak var returnBut: UIButton!
    @IBOutlet weak var sureBut: UIButton!
    private var reloadBlock:((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    public func tranferReloadBlock(callback:@escaping ((String) -> Void)) {
        self.reloadBlock = callback
    }
    
    /// 确认
    @IBAction func confirmBtnClick(_ sender: Any) {
        // self.dismiss(animated: false, completion: nil)
        if self.reloadBlock != nil {
            self.reloadBlock!("刷新了")
        }
    }
    
    @IBAction func returnAction(_ sender: Any) {
        if self.reloadBlock != nil {
            self.reloadBlock!("刷新了")
        }
        self.dismiss(animated: false, completion: nil)
    }
    
}
