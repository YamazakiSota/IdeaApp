//
//  EditViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/05/18.
//

import UIKit
import Eureka
import Firebase
import ImageRow


class EditViewController: FormViewController {
    
    
    var IdeaId: String!
    var IdeaTitle: String!
    var IdeaDetail: String!
    var IdeaGenre: String!
    var NameIDArray: String!
    var NameArray: String!
    var LikeNumArray: Int!
    var ReportNumArray: Int!
    var UserLikeId: String!
    var tem: Int = 0
    
    var UserName: String!
    
    var LikeIdArray: [String] = []
    var CommentArray: [String] = []
    var CommentNameArray: [String] = []
    
    var ReportIdeaArray: [String] = []
    var ReportIdeaIDArray: [String] = []
    
    var Comment: String?
    
    var k = 0
    var tag = 0
    var sect = 0
    var l = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document("\(user.uid)").collection("reportidea").addSnapshotListener({(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var reportideaArray:[String] = []
                    var reportideaidArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        reportideaidArray.append(doc.documentID)
                        reportideaArray.append(data["ReportIdea"] as! String)
                    }
                    self.ReportIdeaArray = reportideaArray
                    self.ReportIdeaIDArray = reportideaidArray
                    
                } else if let error = error {
                    //row.value = false
                    print("取得失敗: ddd" + error.localizedDescription)
                    
                }
            })
        }
        
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/likeidea").addSnapshotListener({(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var LikeideaArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        LikeideaArray.append(data["Likeidea"] as! String)
                    }
                    self.LikeIdArray = LikeideaArray
                    
                    self.tableView.reloadData()
                } else if let error = error {
                    //row.value = false
                    print("取得失敗: ddd" + error.localizedDescription)
                    
                }
            })
        }
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                if let snap = snapshot {
                    if let data = snap.data() {
                        self.UserName = data["name"] as? String
                        self.tableView.reloadData()
                    }
                } else if let error = error {
                    print("ユーザー名取得失敗: " + error.localizedDescription)
                }
            })
        }
        
        
        
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
            
            
            
            (self.form) +++ Section("管理")
            
            <<< ButtonRow() {
                $0.title = "削除"
            }.cellSetup() {cell, row in
                
                cell.tintColor = UIColor.red
            }.onCellSelection {[unowned self] ButtonCellOf, row in
                Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId).delete(){ error in
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
            
            //(self.form)
            
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
            //ここはアイデアセクション
            +++ Section("内容")
            <<< LabelRow("タイトル") { row in
                //row.value = "タイトル"
                row.title = "\(self.IdeaTitle!)"
                row.tag = "\(self.IdeaTitle!)"
            }
            <<< TextAreaRow { row in
                row.placeholder = "\(self.IdeaDetail!)"
                row.disabled = true
            }.cellSetup{ cell, row in
                cell.placeholderLabel?.textColor = .darkGray
                cell.placeholderLabel?.tintColor = .darkGray
            }
            
            
            // ここから情報セクション
            (self.form) +++ Section("情報")
            
            <<< LabelRow("LabelRow"){ row in
                row.title = "ジャンル"
                row.value = "\(self.IdeaGenre!)"
                row.tag = "\(self.tag)"
                self.tag += 1
            }
            
            <<< LabelRow("名前"){ row in
                row.title =   "名前"
                row.value =   "\(self.NameArray!)"
                row.tag = "\(self.tag)"
                self.tag += 1
            }
            
            
            
            //いいねセクション
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
                                } else {
                                    print("idea作成成功")
                                    // ④Todo一覧画面に戻る
                                }
                            })
                    }
                    
                    Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId!).setData(
                        [   "LikeNum": LikeNumArray!,
                        ],merge: true
                        ,completion: { error in
                            if let error = error {
                                // ③が失敗した場合
                                print("アイデア投稿失敗: " + error.localizedDescription)
                            } else {
                                print("TODO作成成功")
                                // ④Todo一覧画面に戻る
                            }
                        })
                    
                    
                    
                    
                    
                }else{
                    self.LikeNumArray! -= 1
                    
                    
                    Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId!).setData(
                        [   "LikeNum": LikeNumArray!,
                        ],merge: true
                        ,completion: { error in
                            if let error = error {
                                // ③が失敗した場合
                                print("アイデア投稿失敗: " + error.localizedDescription)
                            } else {
                                print("TODO作成成功")
                                // ④Todo一覧画面に戻る
                            }
                        })
                    
                    
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/likeidea").document(    UserLikeId!).delete(){ error in
                            if let error = error {
                                print("TODO削除失敗: " + error.localizedDescription)
                            } else {
                                print("TODO削除成功")
                            }
                        }
                    }
                }
            }
            
            
            
            
            /*ここから練習1
             if(self.tem == 0){
             
             (self.form) +++ Section("いいね")
             
             <<< ImageRow(){ row in
             row.title = "欲しいに追加していないよ"
             row.value = UIImage(named: "7591_color")
             row.clearAction = .no
             row.disabled = true
             }.cellSetup() {cell, row in
             cell.backgroundColor = UIColor.white
             cell.tintColor = UIColor.red
             }
             
             
             <<< ButtonRow("Button2") {row in
             row.tag = "hoshii_row"
             row.title = "欲しいに追加"
             
             }.cellSetup() {cell, row in
             cell.backgroundColor = UIColor.white
             cell.tintColor = UIColor.blue
             }.onCellSelection{[unowned self] ButtonCellOf, row in
             
             self.LikeNumArray! += 1
             self.dismiss(animated: true, completion: nil)
             
             if let user = Auth.auth().currentUser {
             Firestore.firestore().collection("users/\(user.uid)/likeidea").document().setData(
             [   "Likeidea": IdeaId!,
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
             }
             
             Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId!).setData(
             [   "LikeNum": LikeNumArray!,
             ],merge: true
             ,completion: { error in
             if let error = error {
             // ③が失敗した場合
             print("アイデア投稿失敗: " + error.localizedDescription)
             } else {
             print("TODO作成成功")
             // ④Todo一覧画面に戻る
             }
             })
             
             }
             }else{
             
             (self.form) +++ Section("いいね")
             
             <<< ImageRow(){ row in
             row.title = "欲しいに追加しているよ"
             row.value = UIImage(named: "saru")
             row.clearAction = .no
             row.disabled = true
             }
             
             <<< ButtonRow("Button1") {row in
             row.tag = "hoshii2_row"
             row.title = "欲しいから削除"
             
             }.cellSetup() {cell, row in
             cell.backgroundColor = UIColor.red
             cell.tintColor = UIColor.black
             }.onCellSelection{[unowned self] ButtonCellOf, row in
             
             self.dismiss(animated: true, completion: nil)
             self.LikeNumArray! -= 1
             
             
             Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId!).setData(
             [   "LikeNum": LikeNumArray!,
             ],merge: true
             ,completion: { error in
             if let error = error {
             // ③が失敗した場合
             print("アイデア投稿失敗: " + error.localizedDescription)
             } else {
             print("TODO作成成功")
             // ④Todo一覧画面に戻る
             }
             })
             
             
             if let user = Auth.auth().currentUser {
             Firestore.firestore().collection("users/\(user.uid)/likeidea").document(    UserLikeId!).delete(){ error in
             if let error = error {
             print("TODO削除失敗: " + error.localizedDescription)
             } else {
             print("TODO削除成功")
             }
             }
             }
             }
             }
             
             //これで練習1終わり*/
            
            
            
            
            (self.form) +++ Section("もうあるよ！！")
            
            <<< TextAreaRow { row in
                row.placeholder = "詳細を入力"
            }.onChange{ row in
                self.Comment = row.value ?? "Comment"//変数に格納
            }
            
            
            <<< ButtonRow("Button2") {row in
                row.tag = "delete_row"
                row.title = "投稿する"
                
            }.onCellSelection{[unowned self] ButtonCellOf, row in
                
                self.dismiss(animated: true, completion: nil)
                
                if let comment = Comment{
                    // ②ログイン済みか確認
                    if let user = UserName {
                        // ③Firestoreにコメントデータを作成する
                        Firestore.firestore().collection("\(IdeaGenre!)のideas/\(IdeaId!)/Comment").document().setData(
                            [   "Comment": comment,
                                "Name": user,
                            ],merge: true
                            ,completion: { error in
                                if let error = error {
                                    // ③が失敗した場合
                                    print("コメント投稿失敗: " + error.localizedDescription)
                                    
                                } else {
                                    print("コメント作成成功")
                                    // ④Todo一覧画面に戻る
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                    }
                }
                
            }
            
            
            
            Firestore.firestore().collection("\(IdeaGenre!)のideas/\(IdeaId!)/Comment").addSnapshotListener/*.getDocuments*/(/*completion: */{ (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var commentArray:[String] = []
                    var commentnameArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        commentArray.append(data["Comment"] as! String)
                        commentnameArray.append(data["Name"] as! String)
                        self.tableView.reloadData()
                        self.sect = 1
                    }
                    
                    if(self.sect == 1){
                        (self.form) +++ Section("みんなからのコメント")
                    }
                    self.sect = 0
                    print(commentArray)
                    for option in commentArray {
                        self.form.last! <<< TextAreaRow(option){ listRow in
                            listRow.placeholder = option + "\n投稿者：\(commentnameArray[self.k])"
                            listRow.disabled = true
                            listRow.tag = "\(self.tag)"
                            self.k += 1
                            self.tag += 1
                        }.cellSetup{ cell, row in
                            cell.placeholderLabel?.textColor = .darkGray
                            cell.placeholderLabel?.tintColor = .darkGray
                        }
                    }
                    self.k = 0
                    
                    self.tableView.reloadData()
                } else if let error = error {
                    print("取得失敗: ccc" + error.localizedDescription)
                }
            })
                
                
                (self.form) +++ Section("操作")
                
                <<< ButtonRow() {
                    $0.title = "ブロック"
                }.cellSetup() {cell, row in
                    
                    cell.tintColor = UIColor.red
                }.onCellSelection {[unowned self] ButtonCellOf, row in
                    
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/blockuser").document().setData(
                            [   "blockuser": NameIDArray!,
                            ],merge: true
                            ,completion: { error in
                                if let error = error {
                                    // ③が失敗した場合
                                    print("アイデア投稿失敗: " + error.localizedDescription)
                                    
                                } else {
                                    print("idea作成成功")
                                    self.dismiss(animated: true, completion: nil)
                                    // ④Todo一覧画面に戻る
                                }
                            })
                    }
                    
                }
                
                <<< ButtonRow() {
                    $0.title = "報告"
                }.cellSetup() {cell, row in
                    cell.tintColor = UIColor.red
                }.onCellSelection {[unowned self] ButtonCellOf, row in
                    
                    l = 0
                    
                    for i in self.ReportIdeaArray{
                        if(i == IdeaId!){
                            l = 1
                        }
                    }
                    
                    if(l == 0){
                        
                        
                        self.ReportNumArray! += 1
                        
                        Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId!).setData(
                            [   "ReportNum": ReportNumArray!,
                            ],merge: true
                            ,completion: { error in
                                if let error = error {
                                    // ③が失敗した場合
                                    print("アイデア投稿失敗: " + error.localizedDescription)
                                } else {
                                    print("TODO作成成功")
                                    // ④Todo一覧画面に戻る
                                }
                            })
                        
                        if let user = Auth.auth().currentUser {
                            Firestore.firestore().collection("users/\(user.uid)/reportidea").document().setData(
                                [   "ReportIdea": IdeaId!,
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
    
}
