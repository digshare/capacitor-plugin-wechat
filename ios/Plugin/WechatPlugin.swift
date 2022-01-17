import Foundation
import Capacitor

public enum WechatPluginError: String, LocalizedError {
    case ConfigurationEmpty = "Configuration is empty, check again"
}

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(WechatPlugin)
public class WechatPlugin: CAPPlugin {
    private let implementation = Wechat()
        
    public override func load() {
        guard let wechatAppId = self.getConfigValue("appId") as? String else {
            print("config not found")
            return
        }
        guard let universalLink = self.getConfigValue("universalLink") as? String else {
            print("config not found")
            return
        }
        
        implementation.registerApp(wechatAppId, universalLink: universalLink)
        
//        UIApplication.shared.delegate.
    }
    
    @objc func login(_ call: CAPPluginCall) {
        implementation.auth()
    }

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": "yo"
        ])
    }
    
    @objc func single(_ call: CAPPluginCall) {
        print("123")
        call.resolve()
    }
}
