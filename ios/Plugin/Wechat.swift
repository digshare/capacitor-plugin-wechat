import Foundation
import Capacitor

@objc public class Wechat: NSObject, WXApiDelegate {
    var appId: String = ""
    var universalLink: String = ""
    // TODO: remove
    var secret = ""
    
    var viewController = UIViewController()
    
    @objc public func registerApp(_ appid: String, universalLink: String) {
        print(appid, universalLink)
        
        WXApi.registerApp(appid, universalLink: universalLink)
        self.appId = appid
        self.universalLink = universalLink
        WXApi.startLog(by: .detail, logBlock: {log in
            print(#line, log)
        })
    }
    
    @objc public func auth() {
        print("login")
        let req = SendAuthReq()
        
        req.scope = "snsapi_userinfo"
        WXApi.send(req)
    }
    
    public func onReq(_ req: BaseReq) {
        print(req)
    }
    
    public func onResp(_ resp: BaseResp) {
        if let resp = resp as? SendAuthResp {
            if let code = resp.code, resp.errCode == 0 {
                self.loginSuccessByCode(code: code)
            }
        }
    }
    
    func loginSuccessByCode(code: String) {
        let urlString = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(self.appId)&secret=\(self.secret)&code=\(code)&grant_type=authorization_code"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async(execute: {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if error == nil && data != nil {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        let access_token = dic["access_token"] as! String
                        let openID = dic["openid"] as! String
                        self.requestUserInfo(access_token, openID)
                    } catch  {
                        print(#function)
                    }
                    return
                }
            })
        }.resume()
    }
    
    func requestUserInfo(_ token: String, _ openID: String) {
        
        let urlString = "https://api.weixin.qq.com/sns/userinfo?access_token=\(token)&openid=\(openID)"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "GET"
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async(execute: {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if error == nil && data != nil {
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                        
                        //dic当中包含了微信登录的个人信息，用于用户创建、登录、绑定等使用
                        print(#line, dic)
                        
                    } catch  {
                        print(#function)
                    }
                    return
                }
            })
        }.resume()
    }
    
    public func pareseRecirection() -> String {
        return "oh shit"
    }
    
    @objc public func echo(_ value: String) -> String {
        return value
    }
}
