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
    
    
    @IBOutlet weak var ShareButton: UIButton!
    
    
    var IdeaId: String!
    var IdeaTitle: String!
    var IdeaDetail: String!
    var IdeaGenre: String!
    var NameIDArray: String!
    var NameArray: String!
    var LikeNumArray: Int!
    var ReportNumArray: Int!
    var UserLikeId: String = ""
    var TimeArray: String = ""
    var tem: Int = 0
    var UserName: String!
    var Comment: String?
    var LikeIdArray: [String] = []
    var CommentArray: [String] = []
    var CommentNameArray: [String] = []
    var ReportIdeaArray: [String] = []
    var ReportIdeaIDArray: [String] = []
    var commentId: [String] = []
    
    var k = 0
    var tag = 0
    var sect = 0
    var l = 0
    var name: String = "aaa"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 254/255, green: 238/255, blue: 181/255, alpha: 1)
        

        
        self.ShareButton.contentHorizontalAlignment = .center
        
        
        ReportIdeaSet()
        WantIdeaSet()
        GetUserName()
        
        if(self.NameIDArray == Auth.auth().currentUser?.uid){
            //自分の投稿の場合
            
            form
            
            //セクション①
            +++ Section("内容")
            <<< LabelRow("タイトル") { row in
                row.title = "\(self.IdeaTitle!)"
            }
            <<< TextAreaRow { row in
                row.placeholder = "\(self.IdeaDetail!)"
                row.disabled = true
            }.cellSetup{ cell, row in
                cell.placeholderLabel?.textColor = .darkGray
                cell.placeholderLabel?.tintColor = .darkGray
            }
            
            
            
            // セクション②
            +++ Section("情報")
            
            <<< LabelRow("LabelRow"){ row in
                row.title = "ジャンル"
                row.value = "\(IdeaGenre!)"
            }
            
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
            
            /*.cellUpdate{ cell, row in
             //cell.detailTextLabel?.textColor = UIColor(red: 254/255, green: 238/255, blue: 181/255, alpha: 1)
             cell.textLabel?.textColor = .black
             }*/
            
            
            Firestore.firestore().collection("\(IdeaGenre!)のideas/\(IdeaId!)/Comment").addSnapshotListener({ (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var commentArray:[String] = []
                    var commentnameArray:[String] = []
                    var commentId:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        commentArray.append(data["Comment"] as! String)
                        commentnameArray.append(data["Name"] as! String)
                        commentId.append(doc.documentID)
                        self.tableView.reloadData()
                        self.sect = 1
                    }
                    self.commentId = commentId
                    
                    if(self.sect == 1){
                        (self.form) +++ Section("Atta!!")
                    }
                    self.sect = 0
                    print(commentArray)
                    for option in commentArray {
                        self.form.last! <<< TextAreaRow(option){ listRow in
                            listRow.placeholder = option + "\n投稿者：\(commentnameArray[self.k])"
                            listRow.disabled = true
                            listRow.tag = "\(self.tag)"
                            
                            self.tag += 1
                        }.cellSetup{ cell, row in
                            cell.placeholderLabel?.textColor = .darkGray
                            cell.placeholderLabel?.tintColor = .darkGray
                        }
                        
                        <<< ButtonRow() {
                            $0.title = "コメント削除"
                        }.cellSetup() {cell, row in
                            cell.tintColor = UIColor.red
                        }.onCellSelection {[unowned self] ButtonCellOf, row in
                            let alert = UIAlertController(title: "コメントを削除しますか？", message: nil, preferredStyle: .alert)
                            
                            let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (action) -> Void in
                                print("Delete button tapped")
                                //ボタンを押したときの処理
                                Firestore.firestore().collection("\(self.IdeaGenre!)のideas").document(self.IdeaId).collection("Comment").document(self.commentId[self.k]).delete(){ error in
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
                        self.k += 1
                        
                        }
                    
                    self.k = 0
                    

                    self.tableView.reloadData()
                } else if let error = error {
                    print("取得失敗: ccc" + error.localizedDescription)
                }
                (self.form) +++ Section("　")
                
                <<< ButtonRow() {
                    $0.title = "削除"
                }.cellSetup() {cell, row in
                    
                    cell.tintColor = UIColor.red
                }.onCellSelection {[unowned self] ButtonCellOf, row in
                    
                    let alert = UIAlertController(title: nil, message: "アイデアを削除しますか？", preferredStyle: .alert)
                    
                    let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (action) -> Void in
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
            //セクション①
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
            
            
            // セクション②
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
            
            
            
            //セクション③
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
                            })
                    }
                    
                    Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId!).setData(
                        [   "LikeNum": LikeNumArray!,
                        ],merge: true
                        ,completion: { error in
                        })
                    
                    let randomInt = Int.random(in: 1..<4)
                    print("\(randomInt)aaa")
                    if(randomInt == 1){
                    let alert = UIAlertController(title: "このアイデアを知らせよう！！", message: nil, preferredStyle: .alert)
                    
                    let delete = UIAlertAction(title: "共有", style: .default, handler: { (action) -> Void in
                        print("Delete button tapped")
                        //ボタンを押したときの処理
                        let activityItems = ["私も『\(self.IdeaTitle!)』が欲しい！\n\nあなたも「あったらいいな」をシェアしよう！！\n(もしかしたら作ってもらえるかも...)\n\nダウンロードはこちら\n(iPhoneのみ)\nhttps://apps.apple.com/jp/app/%E3%81%82%E3%81%A3%E3%81%9F%E3%82%89%E3%81%84%E3%81%84%E3%81%AA/id1628333605"]
                        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                        self.present(activityVC, animated: true)
                        self.navigationController?.popViewController(animated: true)
                    
                        
                    })
                    
                    let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
                        print("Cancel button tapped")
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    alert.addAction(delete)
                    alert.addAction(cancel)
                    
                    self.present(alert, animated: true, completion: nil)
                    }
                    self.tableView.reloadData()
                }else{
                    self.LikeNumArray! -= 1
                    Firestore.firestore().collection("\(IdeaGenre!)のideas").document(IdeaId!).setData(
                        [   "LikeNum": LikeNumArray!,
                        ],merge: true
                        ,completion: { error in
                        })
                    
                    
                    if let user = Auth.auth().currentUser {
                        Firestore.firestore().collection("users/\(user.uid)/likeidea").document(    UserLikeId).delete(){ error in
                        }
                    }
                    self.tableView.reloadData()
                }
                
                
                
                
            }
            
            (self.form) +++ Section("Atta!!")
            
            <<< TextAreaRow { row in
                row.placeholder = "もうすでにこのアイデアがある時や\n制作したよって時に教えてあげよう！"
            }.onChange{ row in
                self.Comment = row.value ?? "Comment"
            }

            
            
            <<< ButtonRow("Button2") {row in
                row.tag = "delete_row"
                row.title = "投稿する"
            }.onCellSelection{[unowned self] ButtonCellOf, row in
                
                let alert = UIAlertController(title: "コメントを投稿しますか？", message: "この操作は取り消せません", preferredStyle: .alert)
                
                let delete = UIAlertAction(title: "投稿", style: .default, handler: { (action) -> Void in
                    print("Delete button tapped")
                    //ボタンを押したときの処理
                    self.navigationController?.popViewController(animated: true)
                    
                    if let comment = self.Comment{
                        if let user = self.UserName {
                            Firestore.firestore().collection("\(self.IdeaGenre!)のideas/\(self.IdeaId!)/Comment").document().setData(
                                [   "Comment": comment,
                                    "Name": user,
                                ],merge: true
                                ,completion: { error in
                                    if let error = error {
                                        // ③が失敗した場合
                                        print("コメント投稿失敗: " + error.localizedDescription)
                                        
                                    } else {
                                        
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
                        
                        let alert = UIAlertController(title: "このユーザーをブロックしますか？", message: nil, preferredStyle: .alert)
                        
                        let delete = UIAlertAction(title: "ブロック", style: .destructive, handler: { (action) -> Void in
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
                        
                        let alert = UIAlertController(title: "この投稿を報告しますか？", message: nil, preferredStyle: .alert)
                        
                        let delete = UIAlertAction(title: "報告", style: .destructive, handler: { (action) -> Void in
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
    
    func WantIdeaSet(){
        
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
                } else {
                }
            })
        }
    }
    func ReportIdeaSet(){
        
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
                    
                } else {
                }
            })
        }
    }
    
    func GetUserName(){
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                if let snap = snapshot {
                    if let data = snap.data() {
                        self.UserName = data["name"] as? String
                        self.tableView.reloadData()
                    }
                } else {
                }
            })
        }
    }
    
    @IBAction func TapShareButton(){
        let activityItems = ["私も『\(self.IdeaTitle!)』が欲しい！\n\nあなたも「あったらいいな」をシェアしよう！！\n(もしかしたら作ってもらえるかも...)\n\nダウンロードはこちら\n(iPhoneのみ)\nhttps://apps.apple.com/jp/app/%E3%81%82%E3%81%A3%E3%81%9F%E3%82%89%E3%81%84%E3%81%84%E3%81%AA/id1628333605"]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
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


