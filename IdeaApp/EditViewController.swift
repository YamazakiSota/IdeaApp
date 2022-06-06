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
    var TimeArray: String = ""
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
    var name: String = "aa"
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 254/255, green: 238/255, blue: 181/255, alpha: 1)
       

        // 戻るボタンのタイトルを"完了"に変更します。

        
        /*if let user = Auth.auth().currentUser {
            // ②ログインしているユーザー名の取得
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                if let snap = snapshot {
                    if let data = snap.data() {
                        self.name = data["name"] as! String
                    }
                } else if let error = error {
                    print("ユーザー名取得失敗: " + error.localizedDescription)
                }
                
                print(self.name)
                // ナビゲーションの右上にラベルをセット
                // ラベルサイズと位置
                
                if let navigationBar = self.navigationController?.navigationBar {
                    let labelFrame = CGRect(x: self.view.frame.size.width - 70 , y: 0, width: 55.0, height: navigationBar.frame.height)
                  let label = UILabel(frame: labelFrame)  // ラベルサイズと位置
                    label.text = self.name
                  label.textColor = UIColor.lightGray // テキストカラー
                  navigationBar.addSubview(label)
                }
                
            })

        }*/

        
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
            /*+++ Section() {
             $0.header = {
             let header = HeaderFooterView<UIView>(.callback({let view = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: 30))
             view.backgroundColor = UIColor(red: 254/255, green: 238/255, blue: 181/255, alpha: 1)
             return view
             }))
             return header
             }()
             }*/
            
            
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
            
            /*.cellUpdate{ cell, row in
                //cell.detailTextLabel?.textColor = UIColor(red: 254/255, green: 238/255, blue: 181/255, alpha: 1)
                cell.textLabel?.textColor = .black
            }*/
            
            <<< LabelRow("名前"){ row in
                row.title =   "名前"
                row.value =   "\(NameArray!)"
            }
            
            <<< LabelRow("日付"){ row in
                row.title =   "日付"
                row.value =   "\(TimeArray)"
            }
            
            <<< LabelRow("欲しい"){ row in
                row.title =   "あったらいいな"
                row.value =   "\(LikeNumArray!)"
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
                    
                    (self.form) +++ Section("　")
                    
                    <<< ButtonRow() {
                        $0.title = "削除"
                    }.cellSetup() {cell, row in
                        
                        cell.tintColor = UIColor.red
                    }.onCellSelection {[unowned self] ButtonCellOf, row in
                        
                        let alert = UIAlertController(title: "削除", message: "この投稿を削除しますか？", preferredStyle: .alert)
                        
                        let delete = UIAlertAction(title: "削除する", style: .destructive, handler: { (action) -> Void in
                            print("Delete button tapped")
                            //ボタンを押したときの処理
                            Firestore.firestore().collection("\(self.IdeaGenre!)のideas").document(self.IdeaId).delete(){ error in
                                if let error = error {
                                    print("TODO削除失敗: " + error.localizedDescription)
                                    let dialog = UIAlertController(title: "TODO削除失敗", message: error.localizedDescription, preferredStyle: .alert)
                                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(dialog, animated: true, completion: nil)
                                } else {
                                    print("TODO削除成功")
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        })
                        
                        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                            print("Cancel button tapped")
                        })
                        
                        alert.addAction(delete)
                        alert.addAction(cancel)
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
          
            
            /*
             (self.form) +++ Section("戻る")
             <<< ButtonRow() {
             $0.title = "戻る"
             }.cellSetup() {cell, row in
             
             cell.tintColor = UIColor.blue
             }.onCellSelection {[unowned self] ButtonCellOf, row in
             self.dismiss(animated: true, completion: nil)
             }
             */
            
            
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
            
            <<< LabelRow("日付"){ row in
                row.title =   "日付"
                row.value =   "\(TimeArray)"
            }
            <<< LabelRow("欲しい"){ row in
                row.title =   "欲しい数"
                row.value =   "\(LikeNumArray!)"
            }

            
            
            //いいねセクション
            +++ Section("欲しい")
            
            <<< SwitchRow(){ row in
                row.title = "あったらいいな"
                
                
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
                    self.tableView.reloadData()
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
                    self.tableView.reloadData()
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
            
            
            
            
            (self.form) +++ Section("コメント")
            
            <<< TextAreaRow { row in
                row.placeholder = "もうすでにこのアイデアがある時や\n制作したよって時に教えてあげよう！"
            }.onChange{ row in
                self.Comment = row.value ?? "Comment"//変数に格納
            }
            
            
            <<< ButtonRow("Button2") {row in
                row.tag = "delete_row"
                row.title = "投稿する"
                
            }.onCellSelection{[unowned self] ButtonCellOf, row in
                
                let alert = UIAlertController(title: "コメント投稿", message: "コメントを投稿してもよろしいですか？\nコメントは削除することができません。", preferredStyle: .alert)
                
                let delete = UIAlertAction(title: "投稿", style: .default, handler: { (action) -> Void in
                    print("Delete button tapped")
                    //ボタンを押したときの処理
                    self.navigationController?.popViewController(animated: true)
                    
                    if let comment = self.Comment{
                        // ②ログイン済みか確認
                        if let user = self.UserName {
                            // ③Firestoreにコメントデータを作成する
                            Firestore.firestore().collection("\(self.IdeaGenre!)のideas/\(self.IdeaId!)/Comment").document().setData(
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
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                })
                        }
                    }
                    
                })
                
                let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                    print("Cancel button tapped")
                })
                
                alert.addAction(delete)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                
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
                    
                    
                    (self.form) +++ Section("　")
                    
                    <<< ButtonRow() {
                        $0.title = "ブロック"
                    }.cellSetup() {cell, row in
                        
                        cell.tintColor = UIColor.red
                    }.onCellSelection {[unowned self] ButtonCellOf, row in
                        
                        let alert = UIAlertController(title: "ブロック", message: "このユーザーをブロックしますか？", preferredStyle: .alert)
                        
                        let delete = UIAlertAction(title: "ブロックする", style: .destructive, handler: { (action) -> Void in
                            print("Delete button tapped")
                            //ボタンを押したときの処理
                            if let user = Auth.auth().currentUser {
                                Firestore.firestore().collection("users/\(user.uid)/blockuser").document().setData(
                                    [   "blockuser": self.NameIDArray!,
                                    ],merge: true
                                    ,completion: { error in
                                        if let error = error {
                                            // ③が失敗した場合
                                            print("アイデア投稿失敗: " + error.localizedDescription)
                                            
                                        } else {
                                            print("idea作成成功")
                                            self.navigationController?.popViewController(animated: true)
                                            // ④Todo一覧画面に戻る
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
                    
                    <<< ButtonRow() {
                        $0.title = "報告"
                    }.cellSetup() {cell, row in
                        cell.tintColor = UIColor.red
                    }.onCellSelection{[unowned self] ButtonCellOf, row in
                        
                        let alert = UIAlertController(title: "報告", message: "この投稿を報告しますか？", preferredStyle: .alert)
                        
                        let delete = UIAlertAction(title: "報告する", style: .destructive, handler: { (action) -> Void in
                            print("Delete button tapped")
                            //ボタンを押したときの処理
                            
                            self.l = 0
                            
                            for i in self.ReportIdeaArray{
                                if(i == self.IdeaId!){
                                    self.l = 1
                                }
                            }
                            
                            if(self.l == 0){
                                
                                
                                self.ReportNumArray! += 1
                                
                                Firestore.firestore().collection("\(self.IdeaGenre!)のideas").document(self.IdeaId!).setData(
                                    [   "ReportNum": self.ReportNumArray!,
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
                                        [   "ReportIdea": self.IdeaId!,
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
                            
                            if(self.ReportNumArray >= 10){
                                Firestore.firestore().collection("\(self.IdeaGenre!)のideas").document(self.IdeaId).delete(){ error in
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
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                            print("Cancel button tapped")
                        })
                        
                        alert.addAction(delete)
                        alert.addAction(cancel)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    self.tableView.reloadData()
                } else if let error = error {
                    print("取得失敗: ccc" + error.localizedDescription)
                }
            })
            
            
            
            
            
            
            /*(self.form) +++ Section("戻る")
             <<< ButtonRow() {
             $0.title = "戻る"
             }.cellSetup() {cell, row in
             cell.tintColor = UIColor.blue
             }.onCellSelection {[unowned self] ButtonCellOf, row in
             self.dismiss(animated: true, completion: nil)
             }*/
            
            
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
    
    
    @IBAction func BackButton(){
        self.navigationController?.popViewController(animated: true)
        
    }
    
}


