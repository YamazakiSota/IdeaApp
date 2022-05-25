//
//  EditViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/05/18.
//

import UIKit
import Eureka
import Firebase


class EditViewController: FormViewController {
    
    
    var IdeaId: String!
    var IdeaTitle: String!
    var IdeaDetail: String!
    var IdeaGenre: String!
    var NameIDArray: String!
    var NameArray: String!
    var LikeNumArray: Int!
    var tem: Int!
    
    var LikeIdArray: [String] = []
    
    
    
    var taitoru: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if(NameIDArray == Auth.auth().currentUser?.uid){
            //自分の投稿の場合
            
            form
            // ここからセクション1
            +++ Section("内容")
            <<< LabelRow("タイトル") { row in
                //row.value = "タイトル"
                row.title = "\(self.IdeaTitle!)"
            }
            <<< TextAreaRow { row in
                row.placeholder = "\(self.IdeaDetail!)"
                row.disabled = true
            }.cellSetup{ cell, row in
                cell.placeholderLabel?.textColor = .darkGray
                cell.placeholderLabel?.tintColor = .darkGray
            }
            
            
            // ここからセクション2
            +++ Section("情報")
            
            <<< LabelRow("LabelRow"){ row in
                row.title = "ジャンル"
                row.value = "\(IdeaGenre!)"
            }
            
            <<< LabelRow("名前"){ row in
                row.title =   "名前"
                row.value =   "\(NameArray!)"
            }
            
            
            +++ Section("管理")
            
            <<< ButtonRow() {
                $0.title = "削除"
            }.cellSetup() {cell, row in
                
                cell.tintColor = UIColor.red
            }.onCellSelection {[unowned self] ButtonCellOf, row in
                Firestore.firestore().collection("ideas").document(IdeaId).delete(){ error in
                    if let error = error {
                        print("TODO削除失敗: " + error.localizedDescription)
                        let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
                        dialog.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(dialog, animated: true, completion: nil)
                    } else {
                        print("TODO削除成功")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
            
            <<< ButtonRow() {
                $0.title = "戻る"
            }.cellSetup() {cell, row in
                
                cell.tintColor = UIColor.blue
            }.onCellSelection {[unowned self] ButtonCellOf, row in
                self.dismiss(animated: true, completion: nil)
            }
            
            
            
        }else {
            //他の人の投稿
            
            
            form
            // ここからセクション1
            +++ Section("内容")
            <<< LabelRow("タイトル") { row in
                //row.value = "タイトル"
                row.title = "\(self.IdeaTitle!)"
            }
            <<< TextAreaRow { row in
                row.placeholder = "\(self.IdeaDetail!)"
                row.disabled = true
            }.cellSetup{ cell, row in
                cell.placeholderLabel?.textColor = .darkGray
                cell.placeholderLabel?.tintColor = .darkGray
            }
            
            
            // ここからセクション2
            +++ Section("情報")
            
            <<< LabelRow("LabelRow"){ row in
                row.title = "ジャンル"
                row.value = "\(IdeaGenre!)"
            }
            
            <<< LabelRow("名前"){ row in
                row.title =   "名前"
                row.value =   "\(NameArray!)"
            }
            
            
            +++ Section("情報")
            
            <<< ButtonRow() {
                $0.title = "ブロック"
            }.cellSetup() {cell, row in
                
                cell.tintColor = UIColor.red
            }.onCellSelection {[unowned self] ButtonCellOf, row in
                //誰もブッロクしていない場合はとりあえずキー値"blocked"に初期値を入れる
                if UserDefaults.standard.object(forKey: "blocked") == nil{
                    let XXX = ["XX" : true]
                    UserDefaults.standard.set(XXX, forKey: "blocked")
                }
                var blockDic:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
                blockDic["\(NameIDArray!) "] = true
                UserDefaults.standard.set(blockDic, forKey: "blocked")
                self.dismiss(animated: true, completion: nil)
            }
            
            <<< ButtonRow() {
                $0.title = "戻る"
            }.cellSetup() {cell, row in
                
                cell.tintColor = UIColor.blue
            }.onCellSelection {[unowned self] ButtonCellOf, row in
                self.dismiss(animated: true, completion: nil)
            }

            
            
            +++ Section("いいね")
            
            <<< SwitchRow(){ row in
                row.title = "欲しい"
                
                
                
                if(self.tem == 0){
                    row.value = false
                }else{
                    row.value = true
                }
                
                
                
            }.onChange{[unowned self] row in
                if row.value! == true{
                    
                    
                    self.LikeNumArray! += 1
                    
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/likeidea").document().setData(
                            [   "Likeidea": IdeaId!,
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
                    }
                    
                    Firestore.firestore().collection("ideas").document(IdeaId!).setData(
                        [   "LikeNum": LikeNumArray!,
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
                            }
                        })
                    
                    
                    
                    
                    
                }else{
                    self.LikeNumArray! -= 1
                    
                    
                    Firestore.firestore().collection("ideas").document(IdeaId!).setData(
                        [   "LikeNum": LikeNumArray!,
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
                            }
                        })
                    
                    
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/likeidea").document().delete(){ error in
                            if let error = error {
                                print("TODO削除失敗: " + error.localizedDescription)
                                let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
                                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                                self.present(dialog, animated: true, completion: nil)
                            } else {
                                print("TODO削除成功")
                                
                            }
                        }
                    }
                    
                    
                }
                
            }
        }
    }
    
    
    
    
    
    @IBAction func Back2Button(){
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
