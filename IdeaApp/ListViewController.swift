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
    
    @IBOutlet weak var OrderSegmentedControl: UISegmentedControl!
    
    // Firestoreから取得するTodoのid,title,detail,isDoneを入れる配列を用意
    var IdeaIdArray: [String] = []
    var IdeaTitleArray: [String] = []
    var IdeaDetailArray: [String] = []
    var IdeaGenreArray: [String] = []
    var NameIDArray: [String] = []
    var NameArray: [String] = []
    var LikeIdArray: [String] = []
    var UserLikeIdArray: [String] = []
    var BlockUserArray: [String] = []
    var BlockUserIdArray: [String] = []
    var ReportIdeaArray: [String] = []
    var ReportIdeaIDArray: [String] = []
    var LikeNumArray: [Int] = []
    var ReportNumArray: [Int] = []
    var CommentArray: [String] = []
    var CommentNameArray: [String] = []
    var TimeArray: [String] = []
    
    var tem: Int = 0
    var k: Int = 0
    var s: Int = 0
    var sc: Int = 0
    
    var Genre: String = "アプリ"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //OrderSegmentedControl.selectedSegmentIndex = 0
        //sc = 0
        
        
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
        }
            
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users").document("\(user.uid)").collection("likeidea").addSnapshotListener({(querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        var LikeideaArray:[String] = []
                        var UserlikeideaArray:[String] = []
                        for doc in querySnapshot.documents {
                            let data = doc.data()
                            UserlikeideaArray.append(doc.documentID)
                            LikeideaArray.append(data["Likeidea"] as! String)
                        }
                        self.LikeIdArray = LikeideaArray
                        self.UserLikeIdArray = UserlikeideaArray
                    } else if let error = error {
                        //row.value = false
                        print("取得失敗: ddd" + error.localizedDescription)
                        
                    }
                })
            }
            
            
            
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users").document("\(user.uid)").collection("blockuser").addSnapshotListener({(querySnapshot, error) in
                    if let querySnapshot = querySnapshot {
                        var blockuserArray:[String] = []
                        var blockuseridArray:[String] = []
                        for doc in querySnapshot.documents {
                            let data = doc.data()
                            blockuseridArray.append(doc.documentID)
                            blockuserArray.append(data["blockuser"] as! String)
                        }
                        self.BlockUserArray = blockuserArray
                        self.BlockUserIdArray = blockuseridArray
                        
                    } else if let error = error {
                        //row.value = false
                        print("取得失敗: ddd" + error.localizedDescription)
                        
                    }
                })
            }
            
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

        
        if(sc == 0){
            Firestore.firestore().collection("\(Genre)のideas").order(by: "createdAt",descending: true).addSnapshotListener/*.getDocuments*/(/*completion: */{(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var idArray:[String] = []
                    var titleArray:[String] = []
                    var detailArray:[String] = []
                    var genreArray:[String] = []
                    var nameidArray:[String] = []
                    var nameArray:[String] = []
                    var likenumArray:[Int] = []
                    var timeArray:[String] = []
                    var reportnumArray:[Int] = []
                    
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        
                        for i in self.BlockUserArray{
                            if(i == data["UserID"] as! String){
                                self.s = 1
                                break
                            }
                            else{
                                self.s = 0
                            }
                        }
                        if (self.s == 0){
                            idArray.append(doc.documentID)
                            titleArray.append(data["title"] as! String)
                            detailArray.append(data["detail"] as! String)
                            genreArray.append(data["Genre"] as! String)
                            nameidArray.append(data["UserID"] as! String)
                            nameArray.append(data["Name"] as! String)
                            likenumArray.append(data["LikeNum"] as! Int)
                            reportnumArray.append(data["ReportNum"] as! Int)
                            timeArray.append(data["updatedAt"] as! String)
                            //let createtime = data["createdAt"] as! Timestamp
                            //let dateVal = createtime.dateValue()
                            //print(createtime)
                            //timeArray.append("\(dateVal)")
                        }
                        
                    }
                    self.IdeaIdArray = idArray
                    self.IdeaTitleArray = titleArray
                    self.IdeaDetailArray = detailArray
                    self.IdeaGenreArray = genreArray
                    self.NameIDArray = nameidArray
                    self.NameArray = nameArray
                    self.LikeNumArray = likenumArray
                    self.TimeArray = timeArray
                    self.ReportNumArray = reportnumArray
                    self.tableView.reloadData()
                } else if let error = error {
                    print("取得失敗: ccc" + error.localizedDescription)
                }
            })
        }else{
            Firestore.firestore().collection("\(Genre)のideas").order(by: "LikeNum",descending: true).addSnapshotListener/*.getDocuments*/(/*completion: */{(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var idArray:[String] = []
                    var titleArray:[String] = []
                    var detailArray:[String] = []
                    var genreArray:[String] = []
                    var nameidArray:[String] = []
                    var nameArray:[String] = []
                    var likenumArray:[Int] = []
                    var reportnumArray:[Int] = []
                    var timeArray:[String] = []
                    
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        
                        for i in self.BlockUserArray{
                            if(i == data["UserID"] as! String){
                                self.s = 1
                                break
                            }
                            else{
                                self.s = 0
                            }
                        }
                        if (self.s == 0){
                            idArray.append(doc.documentID)
                            titleArray.append(data["title"] as! String)
                            detailArray.append(data["detail"] as! String)
                            genreArray.append(data["Genre"] as! String)
                            nameidArray.append(data["UserID"] as! String)
                            nameArray.append(data["Name"] as! String)
                            likenumArray.append(data["LikeNum"] as! Int)
                            reportnumArray.append(data["ReportNum"] as! Int)
                            timeArray.append(data["updatedAt"] as! String)
                            //let createtime = data["createdAt"] as! Timestamp
                            //let dateVal = createtime.dateValue()
                            //print(createtime)
                            //timeArray.append("\(dateVal)")
                        }
                        
                    }
                    self.IdeaIdArray = idArray
                    self.IdeaTitleArray = titleArray
                    self.IdeaDetailArray = detailArray
                    self.IdeaGenreArray = genreArray
                    self.NameIDArray = nameidArray
                    self.NameArray = nameArray
                    self.LikeNumArray = likenumArray
                    self.TimeArray = timeArray
                    self.ReportNumArray = reportnumArray
                    self.tableView.reloadData()
                    print("aoaoaoaoao")
                } else if let error = error {
                    print("取得失敗: ccc" + error.localizedDescription)
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
            if(sc == 0){
                /*let newstr = TimeArray[indexPath.row].filter("0123456789".contains)//202205171630
                let year = newstr.prefix(4)//20220517
                let yearno = newstr.dropFirst(4)
                var month = yearno.prefix(2)
                let monthno = yearno.dropFirst(2)
                var day = Int(monthno.prefix(2))
                let dayno = monthno.dropFirst(2)
                var hour = Int(dayno.prefix(2))
                
                if(hour! > 15){
                    day = day! + 1
                }*/
                
                cell.detailTextLabel?.text = "作成日：\(TimeArray[indexPath.row])" + NameArray[indexPath.row]
            }else{
                cell.detailTextLabel?.text = "欲しい数：\(LikeNumArray[indexPath.row])　" + NameArray[indexPath.row]
            }
            
        
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
        next.LikeNumArray = LikeNumArray[indexPath.row]
        next.ReportNumArray = ReportNumArray[indexPath.row]
        
        self.k = 0
        for i in self.LikeIdArray{
            if(i == self.IdeaIdArray[indexPath.row]){
                self.tem = 1
                next.UserLikeId = UserLikeIdArray[k]
                next.tem = self.tem
                break
            }else {
                self.tem = 0
                next.tem = self.tem
                k += 1
            }
        }
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
            if(sc == 0){
                getIdeaDataForFirestore()
            }else{
                getIdeaDataForFirestoreNum()
            }
            
        case 1:
            Genre = "日用品"
            if(sc == 0){
                getIdeaDataForFirestore()
            }else{
                getIdeaDataForFirestoreNum()
            }
        case 2:
            Genre = "生活"
            if(sc == 0){
                getIdeaDataForFirestore()
            }else{
                getIdeaDataForFirestoreNum()
            }
        case 3:
            Genre = "エンタメ"
            if(sc == 0){
                getIdeaDataForFirestore()
            }else{
                getIdeaDataForFirestoreNum()
            }
        case 4:
            Genre = "その他"
            if(sc == 0){
                getIdeaDataForFirestore()
            }else{
                getIdeaDataForFirestoreNum()
            }
        default:
            Genre = "アプリ"
            if(sc == 0){
                getIdeaDataForFirestore()
            }else{
                getIdeaDataForFirestoreNum()
            }
        }
    }
    
    @IBAction func changeOrderControl(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            getIdeaDataForFirestore()
            sc = 0
        case 1:
            getIdeaDataForFirestoreNum()
            sc = 1
        default:
            getIdeaDataForFirestore()
            sc = 0
        }
        
    }
    
    // FirestoreからTodoを取得する処理
    func getIdeaDataForFirestore() {
        
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document("\(user.uid)").collection("likeidea").addSnapshotListener({(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var LikeideaArray:[String] = []
                    var UserlikeideaArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        UserlikeideaArray.append(doc.documentID)
                        LikeideaArray.append(data["Likeidea"] as! String)
                    }
                    self.LikeIdArray = LikeideaArray
                    self.UserLikeIdArray = UserlikeideaArray
                } else if let error = error {
                    print("取得失敗: ddd" + error.localizedDescription)
                    
                }
            })
        }
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document("\(user.uid)").collection("blockuser").addSnapshotListener({(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var blockuserArray:[String] = []
                    var blockuseridArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        blockuseridArray.append(doc.documentID)
                        blockuserArray.append(data["blockuser"] as! String)
                    }
                    self.BlockUserArray = blockuserArray
                    self.BlockUserIdArray = blockuseridArray
                    
                } else if let error = error {
                    print("取得失敗: ddd" + error.localizedDescription)
                    
                }
            })
        }
        
        
        
        Firestore.firestore().collection("\(Genre)のideas").order(by: "createdAt",descending: true).addSnapshotListener/*.getDocuments*/(/*completion: */{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                var idArray:[String] = []
                var titleArray:[String] = []
                var detailArray:[String] = []
                var genreArray:[String] = []
                var nameidArray:[String] = []
                var nameArray:[String] = []
                var likenumArray:[Int] = []
                var timeArray:[String] = []
                var reportnumArray:[Int] = []
                for doc in querySnapshot.documents {
                    let data = doc.data()
                    
                    for i in self.BlockUserArray{
                        if(i == data["UserID"] as! String){
                            self.s = 1
                            break
                        }
                        else{
                            self.s = 0
                        }
                    }
                    if (self.s == 0){
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        likenumArray.append(data["LikeNum"] as! Int)
                        timeArray.append(data["updatedAt"] as! String)
                        reportnumArray.append(data["ReportNum"] as! Int)
                    }
                    
                }
                self.IdeaIdArray = idArray
                self.IdeaTitleArray = titleArray
                self.IdeaDetailArray = detailArray
                self.IdeaGenreArray = genreArray
                self.NameIDArray = nameidArray
                self.NameArray = nameArray
                self.LikeNumArray = likenumArray
                self.TimeArray = timeArray
                self.ReportNumArray = reportnumArray
                print(self.IdeaTitleArray)
                self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
        
        
        
        
    }
    
    func getIdeaDataForFirestoreNum() {
        
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document("\(user.uid)").collection("likeidea").addSnapshotListener({(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var LikeideaArray:[String] = []
                    var UserlikeideaArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        UserlikeideaArray.append(doc.documentID)
                        LikeideaArray.append(data["Likeidea"] as! String)
                    }
                    self.LikeIdArray = LikeideaArray
                    self.UserLikeIdArray = UserlikeideaArray
                } else if let error = error {
                    print("取得失敗: ddd" + error.localizedDescription)
                    
                }
            })
        }
        
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document("\(user.uid)").collection("blockuser").addSnapshotListener({(querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var blockuserArray:[String] = []
                    var blockuseridArray:[String] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        blockuseridArray.append(doc.documentID)
                        blockuserArray.append(data["blockuser"] as! String)
                    }
                    self.BlockUserArray = blockuserArray
                    self.BlockUserIdArray = blockuseridArray
                    
                } else if let error = error {
                    print("取得失敗: ddd" + error.localizedDescription)
                    
                }
            })
        }
        
        
        
        Firestore.firestore().collection("\(Genre)のideas").order(by: "LikeNum",descending: true).addSnapshotListener/*.getDocuments*/(/*completion: */{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                var idArray:[String] = []
                var titleArray:[String] = []
                var detailArray:[String] = []
                var genreArray:[String] = []
                var nameidArray:[String] = []
                var nameArray:[String] = []
                var likenumArray:[Int] = []
                var timeArray:[String] = []
                var reportnumArray:[Int] = []
                for doc in querySnapshot.documents {
                    let data = doc.data()
                    
                    for i in self.BlockUserArray{
                        if(i == data["UserID"] as! String){
                            
                        }
                        else{
                            idArray.append(doc.documentID)
                            titleArray.append(data["title"] as! String)
                            detailArray.append(data["detail"] as! String)
                            genreArray.append(data["Genre"] as! String)
                            nameidArray.append(data["UserID"] as! String)
                            nameArray.append(data["Name"] as! String)
                            likenumArray.append(data["LikeNum"] as! Int)
                            timeArray.append(data["updatedAt"] as! String)
                            reportnumArray.append(data["ReportNum"] as! Int)
                        }
                    }
                    
                }
                self.IdeaIdArray = idArray
                self.IdeaTitleArray = titleArray
                self.IdeaDetailArray = detailArray
                self.IdeaGenreArray = genreArray
                self.NameIDArray = nameidArray
                self.NameArray = nameArray
                self.LikeNumArray = likenumArray
                self.TimeArray = timeArray
                self.ReportNumArray = reportnumArray
                print(self.IdeaTitleArray)
                self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
        
        
        
        
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
