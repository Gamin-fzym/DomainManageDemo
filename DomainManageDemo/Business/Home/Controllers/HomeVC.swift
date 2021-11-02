//
//  HomeVC.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import Foundation
import UIKit

class HomeVC: UIViewController {
    
    var homeRouteModel: HomeRouteModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        let but = UIButton(frame: CGRect(x: 100, y: 100, width: 120, height: 40))
        but.backgroundColor = .blue
        but.setTitleColor(.white, for: .normal)
        but.setTitle("域名切换", for: .normal)
        but.addTarget(self, action: #selector(continuousTapAction), for: .touchUpInside)
        self.view.addSubview(but)
        
        let reBut = UIButton(frame: CGRect(x: 100, y: 200, width: 120, height: 40))
        reBut.backgroundColor = .blue
        reBut.setTitleColor(.white, for: .normal)
        reBut.setTitle("网络请求", for: .normal)
        reBut.addTarget(self, action: #selector(tapNetRequestAction), for: .touchUpInside)
        self.view.addSubview(reBut)
    }
    
    /// 进入域名管理
    @objc func continuousTapAction() {
        let vc = DomainManageVC(nibName: "DomainManageVC", bundle: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    /// 网络请求
    @objc func tapNetRequestAction() {
        loadHomeRoute()
    }
    
}

extension HomeVC {
    
    func loadHomeRoute() {
        JRNetworkManager.shared.request(HomeAPI.getHomeRoute(), completed: { [weak self] (result) in
            guard let this = self else { return }
            this.homeRouteModel = HomeRouteModel.parseObject(json: result)
            DispatchQueue.main.async {
                //this.collectionView.reloadData()
            }
        }) { (status, error) in

        }
    }

}
