//
//  AlertHUD.swift
//  DomainManageDemo
//
//  Created by MaciOS on 2021/11/1.
//

import UIKit
import Toast_Swift
import SVProgressHUD
import MBProgressHUD

struct AlertHUD {
    
    static func showText(_ text: String) {
        dismiss()
        UIApplication.shared.keyWindow?.makeToast(text, duration: 1.5, position: .center)
    }
    
    static func showMsg(_ msg: String, style: SVProgressHUDStyle = .dark) {
        guard let window = UIApplication.shared.keyWindow else {
            showText(msg)
            return
        }
        dismiss()
        let hud = MBProgressHUD.showAdded(to: window, animated: true)
        hud.label.text = msg
        hud.minSize = CGSize(width: 100, height: 100)
        hud.animationType = .zoomOut
        hud.mode = .text
        hud.bezelView.backgroundColor = .black
        hud.bezelView.style = .blur
        hud.bezelView.blurEffectStyle = .dark
        hud.label.textColor = .white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            MBProgressHUD.hide(for: window, animated: true)
        }
    }
    
    // MARK: - show
    static func show(_ msg: String?, style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.show(withStatus: msg)
    }
    
    static func show(_ style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.show()
    }
    
    static func show(_ msg: String?, progress: Float, style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.showProgress(progress, status: msg)
    }
    
    // MARK: - Success
    static func showSuccess(_ msg: String?, style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.showSuccess(withStatus: msg)
        self.dismiss(withDelay: 1.0)
    }
    
    // MARK: - Error
    static func showError(_ msg: String, style: SVProgressHUDStyle = .dark) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.showError(withStatus: msg)
        self.dismiss(withDelay: 1.0)
    }
    
    static func dismiss(withDelay: TimeInterval) {
        SVProgressHUD.dismiss(withDelay: withDelay)
    }
    
    static func dismiss() {
        SVProgressHUD.dismiss()
    }
    
}
