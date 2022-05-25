//
//  ListViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/05/18.
//

import UIKit
import Firebase

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var Label1: UILabel!
    
    @IBOutlet weak var ListSegmentedControl: UISegmentedControl!
    


    // Firestoreから取得するTodoのid,title,detail,isDoneを入れる配列を用意
    var IdeaIdArray: [String] = []
    var IdeaTitleArray: [String] = []
    var IdeaDetailArray: [String] = []
    var IdeaGenreArray: [String] = []
    var NameIDArray: [String] = []
    var NameArray: [String] = []
    
    var DateArray : [Date] = []
    

    

    var Genre: String = "アプリ"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // ①ログイン済みかどうか確認
            if let user = Auth.auth().currentUser {
                // ②ログインしているユーザー名の取得
                Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                    if let snap = snapshot {
                        if let data = snap.data() {
                            self.Label1.text = data["name"] as? String
                        }
                    } else if let error = error {
                        print("ユーザー名取得失敗: " + error.localizedDescription)
                    }
                })
                
                
                Firestore.firestore().collection("ideas").whereField("Genre", isEqualTo: Genre).order(by: "createdAt",descending: true).addSnapshotListener({ (querySnapshot, error) in
                                if let querySnapshot = querySnapshot {
                                    var idArray:[String] = []
                                    var titleArray:[String] = []
                                    var detailArray:[String] = []
                                    var genreArray:[String] = []
                                    var nameidArray:[String] = []
                                    var nameArray:[String] = []
                                    var dataArray:[Data] = []
                                    
                                    for doc in querySnapshot.documents {
                                        let data = doc.data()
                                        let blockList:[String:Bool] = UserDefaults.standard.object(forKey: "blocked") as! [String:Bool]
                                        if let dataid = data["UserID"]{
                                            if let bloclFlag = blockList["\(dataid)"],bloclFlag == true{
                                                //ブロックリストの中のuserの投稿の場合は配列に追加しない
                                                print("aaa")
                                            }else{
                                                idArray.append(doc.documentID)
                                                titleArray.append(data["title"] as! String)
                                                detailArray.append(data["detail"] as! String)
                                                genreArray.append(data["Genre"] as! String)
                                                nameidArray.append(data["UserID"] as! String)
                                                nameArray.append(data["Name"] as! String)
                                                
                                                
                                                self.IdeaIdArray = idArray
                                                self.IdeaTitleArray = titleArray
                                                self.IdeaDetailArray = detailArray
                                                self.IdeaGenreArray = genreArray
                                                self.NameIDArray = nameidArray
                                                self.NameArray = nameArray
                                                self.tableView.reloadData()
                                                
                                            }
                                        }

                                    }

                                    
                                } else if let error = error {
                                    print("取得失敗: bbb" + error.localizedDescription)
                                }
                            })
                
                
                    }
        
        }
        
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return IdeaTitleArray.count
        }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = IdeaTitleArray[indexPath.row]
            cell.detailTextLabel?.text = NameArray[indexPath.row]
            
            cell.textLabel?.font = UIFont(name: "Arial", size: 20)
            cell.detailTextLabel?.font = UIFont(name: "Arial", size: 13)

            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let storyboard: UIStoryboard = self.storyboard!
            let next = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
            next.IdeaId = IdeaIdArray[indexPath.row]
            next.IdeaTitle = IdeaTitleArray[indexPath.row]
            next.IdeaDetail = IdeaDetailArray[indexPath.row]
            next.IdeaGenre = IdeaGenreArray[indexPath.row]
            next.NameIDArray = NameIDArray[indexPath.row]
            next.NameArray = NameArray[indexPath.row]
            self.present(next, animated: true, completion: nil)
        }
    

    @IBAction func tapAddButton(_ sender: Any){
        
        // ①Todo作成画面に画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "NaviViewController")
        self.present(next, animated: true, completion: nil)

    }

    
    @IBAction func tapLogoutButton(_ sender: Any) {
            // ①ログイン済みかどうかを確認
            if Auth.auth().currentUser != nil {
                // ②ログアウトの処理
                do {
                    try Auth.auth().signOut()
                    print("ログアウト完了")
                    // ③成功した場合はログイン画面へ遷移
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    self.present(next, animated: true, completion: nil)
                } catch let error as NSError {
                    print("ログアウト失敗: " + error.localizedDescription)
                    // ②が失敗した場合
                    let dialog = UIAlertController(title: "ログアウト失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        }
    
    
    @IBAction func ChangeListControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
                case 0:
                    Genre = "アプリ"
                    getIdeaDataForFirestore()
                case 1:
                    Genre = "日用品"
                    getIdeaDataForFirestore()
                case 2:
                    Genre = "生活"
                    getIdeaDataForFirestore()
                case 3:
                    Genre = "エンタメ"
                    getIdeaDataForFirestore()
                case 4:
                    Genre = "その他"
                    getIdeaDataForFirestore()
                default:
                    Genre = "アプリ"
                    getIdeaDataForFirestore()
                }
    }
    
    @IBAction func changeOrderControl(_ sender: UISegmentedControl){
        
    }

    // FirestoreからTodoを取得する処理
    func getIdeaDataForFirestore() {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("ideas").whereField("Genre", isEqualTo: Genre).order(by: "createdAt",descending: true).addSnapshotListener/*.getDocuments*/(/*completion: */{ (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var idArray:[String] = []
                    var titleArray:[String] = []
                    var detailArray:[String] = []
                    var genreArray:[String] = []
                    var nameidArray:[String] = []
                    var nameArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        print("ああああああ")
                    }
                    self.IdeaIdArray = idArray
                    self.IdeaTitleArray = titleArray
                    self.IdeaDetailArray = detailArray
                    self.IdeaGenreArray = genreArray
                    self.NameIDArray = nameidArray
                    self.NameArray = nameArray
                    print(self.IdeaTitleArray)
                    self.tableView.reloadData()
                    
                } else if let error = error {
                    print("取得失敗: ccc" + error.localizedDescription)
                }
            })
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
