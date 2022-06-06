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
    var IdeaGenre: String = "選択なし"
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
        let Timedate = "\(year).\(month).\(day)"
        /*/ ナビゲーションの右上にラベルをセット
        if let navigationBar = self.navigationController?.navigationBar {
            let imageFrame = CGRect(x: (self.view.frame.size.width / 2) - 40, y: 3, width: 80, height: 33)
            let image = UIImageView(frame: imageFrame)  // ラベルサイズと位置
            image.image = UIImage(named: "attaraiina")
            navigationBar.addSubview(image)
        }*/
        
        
        
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
            $0.options = ["アプリ","日用品","エンタメ","その他"]
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
            self.Username = row.value
        })
        
        /*日付は取得する形でいいかな
         <<< DateRow("Date"){
         $0.title = "日付"
         $0.value = Date()
         }*/
        
        
        /*
        +++ Section("　")
        
        <<< ButtonRow("Button2") {row in
            row.tag = "delete_row"
            row.title = "投稿する"
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                
                let alert = UIAlertController(title: "投稿", message: "投稿してもよろしいですか？", preferredStyle: .alert)
                
                let delete = UIAlertAction(title: "投稿", style: .default, handler: { (action) -> Void in
                    print("Delete button tapped")
                    //ボタンを押したときの処理
                    
                    if let title = self.IdeaTitle,
                       let detail = self.IdeaDetail, let Genre = self.IdeaGenre, let name = self.Username{
                        // ②ログイン済みか確認
                            // ③FirestoreにTodoデータを作成する
                            let createdTime = FieldValue.serverTimestamp()
                            Firestore.firestore().collection("\(Genre)のideas").document().setData(
                                [
                                    "title": title,
                                    "detail": detail,
                                    "createdAt": createdTime,
                                    "updatedAt": Timedate,
                                    "Genre": Genre,
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
                        
                    }

                })
                
                let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                    print("Cancel button tapped")
                })
                
                alert.addAction(delete)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)

            }
        }*/
        
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
    
    @IBAction func toukouButton(){
        
        let year = calendar.component(.year, from: date) // 3
        let month = calendar.component(.month, from: date) // 3
        let day = calendar.component(.day, from: date) // 1
        let Timedate = "\(year).\(month).\(day)"
        
        
        if(self.IdeaGenre == "選択なし"){
            let alert = UIAlertController(title: "注意", message: "ジャンルが選択されていません", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Delete button tapped")
                //ボタンを押したときの処理
                


            })
            
            
            alert.addAction(delete)

            
            self.present(alert, animated: true, completion: nil)
            
        }else{
        let alert = UIAlertController(title: "投稿", message: "投稿してもよろしいですか？", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "投稿", style: .default, handler: { (action) -> Void in
            print("Delete button tapped")
            //ボタンを押したときの処理
            
            
            if let title = self.IdeaTitle,
               let detail = self.IdeaDetail,/* let Genre = self.IdeaGenre, */let name = self.Username{
                // ②ログイン済みか確認
                    // ③FirestoreにTodoデータを作成する
                    let createdTime = FieldValue.serverTimestamp()
                Firestore.firestore().collection("\(self.IdeaGenre)のideas").document().setData(
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
                
            }

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
    

