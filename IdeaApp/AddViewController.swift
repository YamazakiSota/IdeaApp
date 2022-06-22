//
//  AddViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/05/18.
//

import UIKit
import Eureka
import Firebase


class AddViewController:FormViewController{
    
    
    var UserName: String = ""
    var name:String = "aa"
    let calendar = Calendar(identifier: .gregorian)
    let date = Date()
    var IdeaTitle: String?
    var IdeaDetail: String?
    var IdeaGenreA: String = "選択なし"
    var UserID: String?
    var Username: String?
    
    let i: Int = 0
    let j: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //tableView.backgroundColor = UIColor(red: 254/255, green: 238/255, blue: 181/255, alpha: 1)
        
        let year = calendar.component(.year, from: date) // 3
        let month = calendar.component(.month, from: date) // 3
        let day = calendar.component(.day, from: date) // 1
        
        GetUserName()
        
        form
        // ここからセクション1
        +++ Section("内容")
        <<< TextRow { row in
            row.title = "タイトル"
            row.placeholder = "12文字まで"
            row.add(rule: RuleMaxLength(maxLength: 12))
        }.onChange{ row in
            self.IdeaTitle = row.value ?? "IdeaTitle"//変数に格納
        }
        <<< TextAreaRow { row in
            row.placeholder = "詳細を入力"
        }.onChange{ row in
            self.IdeaDetail = row.value ?? "IdeaDetail"//変数に格納
        }
        
        // ここからセクション2
        +++ Section("分類")
        
        <<< AlertRow<String>("") {
            $0.title = "ジャンル"
            $0.selectorTitle = "ジャンルを選択"
            $0.options = ["アプリ","日用品","その他"]
            $0.value = "選択してください"    // 初期選択項目
        }.onChange{[unowned self] row in
            IdeaGenreA = row.value ?? "選択なし"
        }
        
        // ここからセクション3
        +++ Section("情報")
        
        <<< LabelRow("LabelRow"){ row in
            row.title = "日付"
            row.value = "\(year)年\(month)月\(day)日"
        }
        
        <<< LabelRow("名前"){ row in
            row.title =   "名前"
            
        }.cellUpdate({ cell, row in
            row.value =   "\(self.UserName)"
            self.Username = row.value
        })
    }
    
    func GetUserName(){
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                if let snap = snapshot {
                    if let data = snap.data() {
                        self.UserName = data["name"] as! String
                        self.tableView.reloadData()
                    }
                } else if let error = error {
                    print("ユーザー名取得失敗: " + error.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func BackButton(){
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func toukouButton(){
        
        let year = calendar.component(.year, from: date) // 3
        let month = calendar.component(.month, from: date) // 3
        let day = calendar.component(.day, from: date) // 1
        
        let zeroFilledM = String(format: "%02d", month)
        let zeroFilledD = String(format: "%02d", day)
        
        let Timedate = "\(year).\(zeroFilledM).\(zeroFilledD)"
        
        if(self.IdeaGenreA == "選択なし"){
            let alert = UIAlertController(title: "ジャンルが選択されていません", message: nil, preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Delete button tapped")
                //ボタンを押したときの処理
            })
            
            alert.addAction(delete)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "アイデアを投稿しますか？", message: nil, preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "投稿", style: .default, handler: { (action) -> Void in
                print("Delete button tapped")
                //ボタンを押したときの処理
                
                
                if let title = self.IdeaTitle,
                   let detail = self.IdeaDetail,/* let Genre = self.IdeaGenre, */let name = self.Username{
                    // ②ログイン済みか確認
                    // ③FirestoreにTodoデータを作成する
                    let createdTime = FieldValue.serverTimestamp()
                    Firestore.firestore().collection("\(self.IdeaGenreA)のideas").document().setData(
                        [
                            "title": title,
                            "detail": detail,
                            "createdAt": createdTime,
                            "updatedAt": Timedate,
                            "Genre": self.IdeaGenreA,
                            "Name": name,
                            "UserID": Auth.auth().currentUser?.uid,
                            "LikeNum": self.i,
                            "ReportNum": self.j
                        ],merge: true
                        ,completion: { error in
                            if let error = error {
                                // ③が失敗した場合
                                print("アイデア投稿失敗: " + error.localizedDescription)
                                let dialog = UIAlertController(title: "アイデア投稿失敗", message: error.localizedDescription, preferredStyle: .alert)
                                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(dialog, animated: true, completion: nil)
                            } else {
                                print("TODO作成成功")
                                // ④Todo一覧画面に戻る
                                //self.dismiss(animated: true, completion: nil)
                                self.navigationController?.popViewController(animated: true)
                            }
                        })
                    
                }
                
                /*if let title = self.IdeaTitle,
                   let detail = self.IdeaDetail,let name = self.Username{
                    // ②ログイン済みか確認
                    // ③FirestoreにTodoデータを作成する
                    let createdTime = FieldValue.serverTimestamp()
                    Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "nil").collection("myidea").document().setData(
                        [
                            "title": title,
                            "detail": detail,
                            "createdAt": createdTime,
                            "updatedAt": Timedate,
                            "Genre": self.IdeaGenre,
                            "Name": name,
                            "UserID": Auth.auth().currentUser?.uid,
                            "LikeNum": self.i,
                            "ReportNum": self.j
                        ],merge: true
                        ,completion: { error in
                            if let error = error {
                                // ③が失敗した場合
                                print("アイデア投稿失敗: " + error.localizedDescription)
                                let dialog = UIAlertController(title: "アイデア投稿失敗", message: error.localizedDescription, preferredStyle: .alert)
                                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(dialog, animated: true, completion: nil)
                            } else {
                                print("TODO作成成功")
                                // ④Todo一覧画面に戻る
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    
                }*/
                
            })
            
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                print("Cancel button tapped")
            })
            
            alert.addAction(delete)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


