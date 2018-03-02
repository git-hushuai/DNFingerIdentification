//
//  ViewController.swift
//  DNFingerprintIdentification
//
//  Created by 露乐ios on 2018/3/2.
//  Copyright © 2018年 露乐ios. All rights reserved.
//

import UIKit
import LocalAuthentication
fileprivate extension Selector
{
    static let fingerIdentificationAction = #selector(ViewController.fingerIdentificationAction);
}

class ViewController: UIViewController {

    
    lazy var actionBtn : UIButton = {
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100);
        btn.center = self.view.center
        btn.setTitle("指纹扫描", for: UIControlState.normal)
        btn.backgroundColor = UIColor.orange
        btn.addTarget(self, action: .fingerIdentificationAction, for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    @objc func fingerIdentificationAction(){
        let systemVersion = UIDevice.current.systemVersion as NSString
        print("systemVersion double value:\(systemVersion.doubleValue)")
        if systemVersion.doubleValue >= 8.0 {
            let conytext = LAContext.init()
            if conytext.canEvaluatePolicy(LAPolicy(rawValue: Int(kLAPolicyDeviceOwnerAuthenticationWithBiometrics))!, error: nil){
                // 允许使用指纹识别
                conytext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "允许使用设备指纹识别", reply: { (success:Bool, error:Error?) in
                    if success {
                        print("指纹识别成功")
                    }else{
                        print("scan fingleIdentfication error : \(error!)")
                        let scanError =  error! as NSError
                        // 排除用户取消
                        if scanError.code != -2 {
                            // 指纹识别 Touch ID 提供3+2次指纹识别机会，三次识别识别后，指纹验证框消失（会报错code = -1）然后点击指纹会再次弹框可验证两次，如果五次指纹识别全部错误，就需要手动输入数字密码，数字密码可以输入6次，如果6次输入密码错误，系统停止验证，等待验证时间后会再次提供验证的机会，正确及验证成功一次，错误则时间累加等待验证，以此类推
                            /**
                             * Code=-2 "Canceled by user."
                             */
                            /**
                             * Code=-1 "Application retry limit exceeded."
                             */
                            /**
                             * Code=-8 "Biometry is locked out."
                             */
                        }
                        
                    }
                })
            }
        }else{
            print("请确保5S以上机型，并且TouchID已经打开")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(self.actionBtn);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

