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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let year = calendar.component(.year, from: date) // 3
        let month = calendar.component(.month, from: date) // 3
        let day = calendar.component(.day, from: date) // 1
        
        
        var IdeaTitle: String?
        var IdeaDetail: String?
        var IdeaGenre: String?
        var UserID: String?
        var Username: String?
        
        let i: Int = 0
        
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
        
        
        
        
        
        form
        // ここからセクション1
        +++ Section("内容")
        <<< TextRow { row in
            row.title = "タイトル"
            row.placeholder = "12文字まで"
            row.add(rule: RuleMaxLength(maxLength: 12))
        }.onChange{ row in
            IdeaTitle = row.value ?? "IdeaTitle"//変数に格納
        }
        <<< TextAreaRow { row in
            row.placeholder = "詳細を入力"
        }.onChange{ row in
            IdeaDetail = row.value ?? "IdeaDetail"//変数に格納
        }
        
        // ここからセクション2
        +++ Section("分類")
        
        <<< AlertRow<String>("") {
            $0.title = "ジャンル"
            $0.selectorTitle = "ジャンルを選択"
            $0.options = ["アプリ","日用品","生活","エンタメ","その他"]
            $0.value = "選択してください"    // 初期選択項目
        }.onChange{[unowned self] row in
            IdeaGenre = row.value ?? "選択なし"
            /*if (GenreNum == "アプリ"){
             print(GenreNum)
             }else{
             print("aaaa")
             }*/
            
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
            Username = row.value
        })
        
        /*日付は取得する形でいいかな
         <<< DateRow("Date"){
         $0.title = "日付"
         $0.value = Date()
         }*/
        
        +++ Section("操作")
        
        <<< ButtonRow("Button2") {row in
            row.tag = "delete_row"
            row.title = "保存する"
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                //ボタンを押したときの処理
                
                if let title = IdeaTitle,
                   let detail = IdeaDetail, let Genre = IdeaGenre, let name = Username{
                    // ②ログイン済みか確認
                    if let user = Auth.auth().currentUser {
                        // ③FirestoreにTodoデータを作成する
                        let createdTime = FieldValue.serverTimestamp()
                        Firestore.firestore().collection("ideas").document().setData(
                            [
                                "title": title,
                                "detail": detail,
                                "createdAt": createdTime,
                                "updatedAt": createdTime,
                                "Genre": Genre,
                                "Name": name,
                                "UserID": Auth.auth().currentUser?.uid,
                                "LikeNum": i
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
                    }
                }
            }
        }
        
        /*<<< ButtonRow() {
            $0.title = "Delete"
        }.cellSetup() {cell, row in
            
            cell.tintColor = UIColor.red
        }.onCellSelection {[unowned self] ButtonCellOf, row in
            //ボタンを押したときの処理
        }*/
    }
    
    @IBAction func BackButton(){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
