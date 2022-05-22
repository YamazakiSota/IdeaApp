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

    var taitoru: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let year = calendar.component(.year, from: date) // 3
        let month = calendar.component(.month, from: date) // 3
        let day = calendar.component(.day, from: date) // 1
        
        
        var IdeaIdin: String?
        var IdeaTitlein: String?
        var IdeaDetailin: String?
        var IdeaGenrein: String?

        
        
        print(IdeaTitle)
        
        form
        // ここからセクション1
        +++ Section("内容")
        <<< TextRow { row in
            row.title = "\(self.IdeaTitle)"
            row.placeholder = "タイトルを入力"
        }.onChange{ row in
            IdeaTitlein = row.value ?? "IdeaTitle"//変数に格納
        }
        <<< TextAreaRow { row in
            row.placeholder = "詳細を入力"
        }.onChange{ row in
            IdeaDetailin = row.value ?? "IdeaDetail"//変数に格納
        }
        
        // ここからセクション2
        +++ Section("ラベル")
        
        <<< LabelRow("LabelRow"){ row in
            row.title = "LabelRow"
            row.value = "\(year)年\(month)月\(day)日"
        }
        
        
        // ここからセクション3
        +++ Section("情報")
        <<< AlertRow<String>("") {
            $0.title = "ジャンル"
            $0.selectorTitle = "ジャンルを選択"
            $0.options = ["アプリ","日用品","生活","エンタメ"]
            $0.value = "選択してください"    // 初期選択項目
        }.onChange{[unowned self] row in
            IdeaGenrein = row.value ?? "選択なし"
            /*if (GenreNum == "アプリ"){
             print(GenreNum)
             }else{
             print("aaaa")
             }*/
            
        }
        
        /*日付は取得する形でいいかな
         <<< DateRow("Date"){
         $0.title = "日付"
         $0.value = Date()
         }*/
        
        
        <<< ButtonRow() {
            $0.title = "Delete"
        }.cellSetup() {cell, row in
            
            cell.tintColor = UIColor.red
        }.onCellSelection {[unowned self] ButtonCellOf, row in
            if let user = Auth.auth().currentUser {
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
            }        }
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
