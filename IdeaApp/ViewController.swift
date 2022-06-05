//
//  ViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/05/18.
//

import UIKit
import Firebase
import FirebaseAuth
import AppTrackingTransparency
import AdSupport

class ViewController: UIViewController {
    
    @IBOutlet var Loginview: UIView!
    @IBOutlet var Registerview: UIView!
    
    @IBOutlet weak var LoginEmailTextField: UITextField!
    @IBOutlet weak var LoginPasswordTextField: UITextField!
    @IBOutlet weak var RegisterEmailTextField: UITextField!
    @IBOutlet weak var RegisterPasswordTextField: UITextField!
    @IBOutlet weak var RegisterNameTextField: UITextField!
    
    
    var window: UIWindow?
    var Idea: String = "XXX"
    var BlockUser: String = "YYY"
    var ReportIdea: String = "ZZZ"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Loginview.layer.cornerRadius = 20
        Registerview.layer.cornerRadius = 20
        
    }
    
    @IBAction func tapRegisterButton(_ sender: Any) {
        if let email = RegisterEmailTextField.text,
            let password = RegisterPasswordTextField.text,
            let name = RegisterNameTextField.text {
            // ①FirebaseAuthにemailとpasswordでアカウントを作成する
            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                if let user = result?.user {
                    print("ユーザー作成完了 uid:" + user.uid)
                    // ②FirestoreのUsersコレクションにdocumentID = ログインしたuidでデータを作成する
                    Firestore.firestore().collection("users").document(user.uid).setData([
                        "name": name
                    ], completion: { error in
                        if let error = error {
                            // ②が失敗した場合
                            print("Firestore 新規登録失敗 " + error.localizedDescription)
                            let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                        } else {
                            print("ユーザー作成完了 name:" + name)
                            // ③成功した場合はTodo一覧画面に画面遷移を行う
                            let storyboard: UIStoryboard = self.storyboard!
                            let next = storyboard.instantiateViewController(withIdentifier: "Navi0ViewController")
                            next.modalPresentationStyle = .fullScreen
                            self.present(next, animated: true, completion: nil)
                        }
                    })
                        
                        Firestore.firestore().collection("users/\(user.uid)/likeidea").document().setData(
                            [   "Likeidea": self.Idea,
                            ],merge: true
                            ,completion: { error in
                                if let error = error {
                                    // ③が失敗した場合
                                    print("アイデア投稿失敗: " + error.localizedDescription)
                                    let dialog = UIAlertController(title: "アイデア投稿失敗", message: error.localizedDescription, preferredStyle: .alert)
                                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(dialog, animated: true, completion: nil)
                                } else {
                                    print("idea作成成功")
                                    // ④Todo一覧画面に戻る
                                }
                            
                    })
                    
                    Firestore.firestore().collection("users/\(user.uid)/blockuser").document().setData(
                        [   "blockuser": self.BlockUser,
                        ],merge: true
                        ,completion: { error in
                            if let error = error {
                                // ③が失敗した場合
                                print("アイデア投稿失敗: " + error.localizedDescription)
                            } else {
                                print("idea作成成功")
                                // ④Todo一覧画面に戻る
                            }
                        
                })
                    
                    
                    Firestore.firestore().collection("users/\(user.uid)/reportidea").document().setData(
                        [   "ReportIdea": self.ReportIdea,
                        ],merge: true
                        ,completion: { error in
                            if let error = error {
                                // ③が失敗した場合
                                print("アイデア投稿失敗: " + error.localizedDescription)
                            } else {
                                print("idea作成成功")
                                // ④Todo一覧画面に戻る
                            }
                        
                })

                    
                } else if let error = error {
                    // ①が失敗した場合
                    print("Firebase Auth 新規登録失敗 " + error.localizedDescription)
                    let dialog = UIAlertController(title: "新規登録失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            })
        }
    }

    
    @IBAction func tapLoginButton(_ sender: Any){
        if let email = LoginEmailTextField.text,
                    let password = LoginPasswordTextField.text {
                    // ①FirebaseAuthにemailとpasswordでログインを行う
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
                        if let user = result?.user {
                            print("ログイン完了 uid:" + user.uid)
                            // ②成功した場合はTodo一覧画面に画面遷移を行う
                            let storyboard: UIStoryboard = self.storyboard!
                            let next = storyboard.instantiateViewController(withIdentifier: "Navi0ViewController")
                            next.modalPresentationStyle = .fullScreen
                            self.present(next, animated: true, completion: nil)
                            
                        } else if let error = error {
                            // ①が失敗した場合
                            print("ログイン失敗 " + error.localizedDescription)
                            let dialog = UIAlertController(title: "ログイン失敗", message: /*error.localizedDescription*/"ログインに失敗しました", preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                        }
                    })
                }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //ATT対応
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                print("Allow Tracking")
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied:
                print("拒否")
            case .restricted:
                print("制限")
            case .notDetermined:
                showRequestTrackingAuthorizationAlert()
            @unknown default:
                fatalError()
            }
        } else {// iOS14未満
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                print("Allow Tracking")
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            } else {
                print("制限")
            }
        }
    }
    

    private func showRequestTrackingAuthorizationAlert() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    print("🎉")
                    //IDFA取得
                    print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
                case .denied, .restricted, .notDetermined:
                    print("😥")
                @unknown default:
                    fatalError()
                }
            })
        }
    }


}

