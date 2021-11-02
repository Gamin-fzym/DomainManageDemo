//
//  HomeVC.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation
import UIKit

class DomainManageVC: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var operationBut: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var listData: [String] = []
    
    deinit {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prepareData()
    }
    
    func setupUI() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "DomainManageListCell", bundle: nil), forCellReuseIdentifier: "DomainManageListCell")
    }
    
    func prepareData() {
        var list = AppUserDefaults.shared.domainList ?? []
        if list.count == 0 {
            list.append(AppUserDefaults.shared.useDomain ?? "")
        }
        listData = list
        tableView.reloadData()
    }
    
    @IBAction func tapOperationAction(_ sender: Any) {
        operationBut.isSelected = !operationBut.isSelected
        tableView.reloadData()
    }
    
    @IBAction func tapReturnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSwitchAction(_ sender: Any) {
        if let text = searchTextField.text, text.contains("http") {
            AppUserDefaults.shared.useDomain = text
            if !listData.contains(text) {
                listData.append(text)
                AppUserDefaults.shared.domainList = listData
            }
            tableView.reloadData()
            return
        }
        AlertHUD.showText("请输入域名")
    }
    
}

extension DomainManageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DomainManageListCell", for: indexPath) as! DomainManageListCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.status = operationBut.isSelected
        cell.path = listData[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DomainManageListCell {
            let path = cell.path
            searchTextField.text = path
        }
    }
    
}

extension DomainManageVC: DomainManageListDelegate {
    
    func cellTapSwitch(_ path: String, _ status: Bool) {
        if status == false { // 切换
            if path.contains("http") {
                AppUserDefaults.shared.useDomain = path
                tableView.reloadData()
            } else {
                AlertHUD.showText("域名无效,请重新切换")
            }
        } else { // 删除
            listData.removeAll{ $0 == path}
            AppUserDefaults.shared.domainList = listData
            tableView.reloadData()
        }
    }
    
}
