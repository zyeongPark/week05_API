//
//  ViewController.swift
//  week05_API
//
//  Created by 박지영 on 2021/10/07.
//

//import UIKit
////api 활용 프로젝트
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }
//
//
//}

import Foundation
import UIKit
import NaverThirdPartyLogin
import Alamofire

class LoginViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate {
    
    
    @IBOutlet weak var name: UILabel! //name 설정
    @IBOutlet weak var email: UILabel! //email 설정
    @IBOutlet weak var naverButton: UIButton!
    
    let NaverloginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    override func viewDidLoad() {
        NaverloginInstance?.delegate = self
    }
    
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getInfo()
    }
    
    // referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        NaverloginInstance?.accessToken
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    @IBAction func login(_ sender: Any) {
        
        NaverloginInstance?.requestThirdPartyLogin()
    }
    
    @IBAction func logout(_ sender: Any) {
        NaverloginInstance?.requestDeleteToken()
    }
    
    // RESTful API, id가져오기
    func getInfo() {
      guard let isValidAccessToken = NaverloginInstance?.isValidAccessTokenExpireTimeNow() else { return }
      
      if !isValidAccessToken {
        return
      }
      
      guard let tokenType = NaverloginInstance?.tokenType else { return }
      guard let accessToken = NaverloginInstance?.accessToken else { return }
        
      let urlStr = "https://openapi.naver.com/v1/nid/me"
      let url = URL(string: urlStr)!
      
      let authorization = "\(tokenType) \(accessToken)"
      
      let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
      
      req.responseJSON { response in
        guard let result = response.value as? [String: Any] else { return }
        guard let object = result["response"] as? [String: Any] else { return }
        guard let email = object["email"] as? String else { return }
        guard let name = object["name"] as? String else {return}
        
        print(email)
        
        self.email.text = "\(email)"
        self.name.text = "\(name)"
      }
    }
    
}
