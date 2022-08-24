//
//  ListViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/05/18.
//

import UIKit
import Firebase
import GoogleMobileAds

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ListSegmentedControl: UISegmentedControl!
    @IBOutlet weak var OrderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var NameButton: UIButton!
    
    var hoshiibuttons = Array<UIButton>()
    var bannerView: GADBannerView!
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
    var currentTitles:[String] = []
    var currentTime:[String] = []
    var currentLikeNum:[Int] = []
    var currentName:[String] = []
    
    var tem: Int = 0
    var temp: Int = 0
    var k: Int = 0
    var s: Int = 0
    var sc: Int = 0
    var namestr: String = ""
    var mynum: Int = 0
    var Genre: String = "アプリ"
    var name: String = "aa"
    
    var iine = UIColor(red: 234.0/255.0, green: 170.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    var my = UIColor(red: 226.0/255.0, green: 225.0/255.0, blue: 82.0/255.0, alpha: 1.0)
    
    var addBarButtonItem: UIBarButtonItem!      // +ボタン
    var editBarButtonItem: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.barTintColor = UIColor(red: 242/255, green: 244/255, blue: 232/255, alpha: 1)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NameTextSet()
        ImageSet()
        BackbuttonSet()
        
        //BannerSet()
        self.tableView.reloadData()
        
        //AddButtonDesine()
        
        //左スワイプ
        let leftSwipeGesture = UISwipeGestureRecognizer(
                target: self,
        action: #selector(ListViewController.getSwipe(_:))
        )
        leftSwipeGesture.direction = .left
        self.view.addGestureRecognizer(leftSwipeGesture)
                
        //右スワイプ
        let rightSwipeGesture = UISwipeGestureRecognizer(
                target: self,
                action: #selector(ListViewController.getSwipe(_:))
        )
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
        
        
 
        addBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down")!, style: .plain, target: self, action: #selector(addBarButtonTapped(_:)))
        editBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill")!, style: .plain, target: self, action: #selector(editBarButtonTapped(_:)))
                // ③バーボタンアイテムの追加
        self.navigationItem.rightBarButtonItems = [editBarButtonItem, addBarButtonItem]
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        

    }
    
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let alert: UIAlertController = UIAlertController(title: nil, message:nil, preferredStyle:  UIAlertController.Style.actionSheet)
        

        let defaultAction_1: UIAlertAction = UIAlertAction(title: "新着順", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            if(self.mynum == 0){
                self.GetIdeaDataForFirestoreNew()
                self.sc = 0
            }else{
                self.ChangeMyNew()
                self.sc = 0
            }
            
        })
        
        let defaultAction_2: UIAlertAction = UIAlertAction(title: "欲しい数順", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            if(self.mynum == 0){
                self.GetIdeaDataForFirestoreWant()
                self.sc = 1
            }else{
                self.ChangeMyWant()
                self.sc = 1
            }
            
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })


         alert.addAction(cancelAction)
         alert.addAction(defaultAction_1)
        alert.addAction(defaultAction_2)

        present(alert, animated: true, completion: nil)
    }
    // "設定"ボタンが押された時の処理
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:nil, message:  "オプション", preferredStyle: .alert)
        let delete = UIAlertAction(title: "ログアウトする", style: .destructive, handler: { (action) -> Void in
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    self.present(next, animated: true, completion: nil)
                } catch let error as NSError {
                    let dialog = UIAlertController(title: "ログアウト失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        })
        let defaultAction: UIAlertAction = UIAlertAction(title: "利用規約を読む", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            let url = URL(string: "https://termsandpolicy-sota-inc.netlify.app/")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
        })
        
        alert.addAction(defaultAction)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //スワイプ時に実行されるメソッド
    @objc func getSwipe(_ sender: UISwipeGestureRecognizer) {
        
        hoshiibuttons.removeAll()

        //スワイプ方向による実行処理をcase文で指定
        switch sender.direction {
        case .right:
            //右スワイプ時に実行したい処理
            if Genre == "アプリ"{
                break
            }
            else if Genre == "日用品"{
                self.ListSegmentedControl.selectedSegmentIndex = 0
                Genre = "アプリ"
                if(sc == 0){
                    GetIdeaDataForFirestoreNew()
                }else{
                    GetIdeaDataForFirestoreWant()
                }
                mynum = 0
            }
            else if Genre == "その他"{
                self.ListSegmentedControl.selectedSegmentIndex = 1
                Genre = "日用品"
                if(sc == 0){
                    GetIdeaDataForFirestoreNew()
                }else{
                    GetIdeaDataForFirestoreWant()
                }
                mynum = 0
            }
            else {
                self.ListSegmentedControl.selectedSegmentIndex = 2
                Genre = "その他"
                if(sc == 0){
                    GetIdeaDataForFirestoreNew()
                }else{
                    GetIdeaDataForFirestoreWant()
                }
                mynum = 0
            }
        case .left:
            //左スワイプ時に実行したい処理
            if Genre == "アプリ"{
                self.ListSegmentedControl.selectedSegmentIndex = 1
                Genre = "日用品"
                if(sc == 0){
                    GetIdeaDataForFirestoreNew()
                }else{
                    GetIdeaDataForFirestoreWant()
                }
                mynum = 0
            }
            else if Genre == "日用品"{
                self.ListSegmentedControl.selectedSegmentIndex = 2
                Genre = "その他"
                if(sc == 0){
                    GetIdeaDataForFirestoreNew()
                }else{
                    GetIdeaDataForFirestoreWant()
                }
                mynum = 0
            }
            else if Genre == "その他"{
                self.ListSegmentedControl.selectedSegmentIndex = 3
                Genre = "MyApp"
                if(sc == 0){
                    ChangeMyNew()
                }else{
                    ChangeMyWant()
                }
                mynum = 1
            }
            else {
                break
            }
            
        default:
            break
        }
    }
    
    
    
    func AddButtonDesine(){
        
        // 角丸で親しみやすく
        self.AddButton.layer.cornerRadius = self.AddButton.bounds.midY
        // 押せそうにみえる影
        self.AddButton.layer.shadowColor = UIColor.systemGray.cgColor
        self.AddButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.AddButton.layer.shadowOpacity = 0.7
        self.AddButton.layer.shadowRadius = 10
        // グラデーションで強めのアピール (リサイズ非対応！）
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.AddButton.bounds
        gradientLayer.cornerRadius = self.AddButton.bounds.midY
        gradientLayer.colors = [UIColor.systemGray, UIColor.systemGray]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        self.AddButton.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    //NavigationBarのログアウトボタンにユーザ名をセット
    func NameTextSet(){
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                if let snap = snapshot {
                    if let data = snap.data() {
                        self.name = data["name"] as! String
                    }
                }else{
                }
                
                self.namestr = String(self.name.prefix(4))
                self.LogoutButton.setTitle(self.namestr, for: .normal)
                self.LogoutButton.titleLabel?.font = UIFont(name: "Arial", size: 20)
                //self.LogoutButton.contentHorizontalAlignment = .center
                
            })
            
        }
    }
    
    //NavigationBarにimage「attaraiina」をセット
    func ImageSet(){
        if let navigationBar = self.navigationController?.navigationBar {
            let imageFrame = CGRect(x: (self.view.frame.size.width / 2) - 40, y: 3, width: 80, height: 33)
            let image = UIImageView(frame: imageFrame)
            image.image = UIImage(named: "attaraiina")
            navigationBar.addSubview(image)
        }
    }
    
    //NavigationBarのbackbuttonのテキストを変更
    func BackbuttonSet(){
        let backItem  = UIBarButtonItem(title: "戻る", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        //backItem.tintColor = .black
    }
    
    //bannerの各種設定
    func BannerSet(){
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = "ca-app-pub-5041739959288046/6354834758"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
    }
    
    //ここまでViewDidLoad内の関数
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        GetWantIdea()
        GetBlockUser()
        GetReportIdea()
        

        
        if(mynum == 0){
            if(sc == 0){
                ChangeListNew()
            }else{
                ChangeListWant()
            }
        }else{
            if(sc == 0){
                ChangeMyNew()
            }else{
                ChangeMyWant()
            }
            
        }
        
        
        self.hoshiibuttons.removeAll()
        self.tableView.reloadData()
    }
    
    //ここからViewWillApper内の関数
    
    //欲しいアイデア情報の取得
    func GetWantIdea(){
        
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
                } else{
                }
            })
        }
    }
    
    //ブロックユーザの情報取得
    func GetBlockUser(){
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
                } else{
                }
            })
        }
    }
    
    //報告アイデア情報の取得
    func GetReportIdea(){
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
                } else{
                }
            })
        }
    }
    
    //新着順に並び替える
    func ChangeListNew(){
        Firestore.firestore().collection("\(Genre)のideas").order(by: "createdAt",descending: true).addSnapshotListener({(querySnapshot, error) in
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
    }
    
    
    //欲しい数順に並び替える
    func ChangeListWant(){
        Firestore.firestore().collection("\(Genre)のideas").order(by: "LikeNum",descending: true).addSnapshotListener({(querySnapshot, error) in
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
            } else{
            }
        })
    }
    
    //ここまでViewWillApper内の関数
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hoshiibuttons.removeAll()
        return IdeaTitleArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = IdeaTitleArray[indexPath.row]
        
        for i in self.LikeIdArray{
            if(i == self.IdeaIdArray[indexPath.row]){
                self.temp = 1
                break
            }else {
                self.temp = 0
            }
        }
        
        if(self.temp == 1){
            
            if(sc == 0){
                if(mynum == 1){
                    cell.detailTextLabel?.text = "\(TimeArray[indexPath.row])　\(IdeaGenreArray[indexPath.row])"
                    cell.accessoryView = nil
                }else{
                    cell.detailTextLabel?.text = "\(TimeArray[indexPath.row])　" + NameArray[indexPath.row]
                    
                    //let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 32))
                    //imgView.image = UIImage(named: "hoshii1")!
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 25))
                    let image = UIImage(systemName: "flag.fill")
                    let configuration =
                    UIImage.SymbolConfiguration(hierarchicalColor: .init(cgColor: iine.cgColor))
                    imgView.preferredSymbolConfiguration = configuration
                    imgView.image = image
                    
                    cell.accessoryView = imgView
                    
                    
                }
            }else{
                if(mynum == 1){
                    cell.detailTextLabel?.text = "欲しい数：\(LikeNumArray[indexPath.row])　\(IdeaGenreArray[indexPath.row])"
                    cell.accessoryView = nil
                }else{
                    cell.detailTextLabel?.text = "欲しい数：\(LikeNumArray[indexPath.row])　" + NameArray[indexPath.row]
                    
                    //let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 32))
                    //imgView.image = UIImage(named: "hoshii1")!
                    
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 25))
                    let image = UIImage(systemName: "flag.fill")
                    let configuration =
                    UIImage.SymbolConfiguration(hierarchicalColor: .init(cgColor: iine.cgColor))
                    imgView.preferredSymbolConfiguration = configuration
                    imgView.image = image
                    
                    cell.accessoryView = imgView
                    
                }
            }
            
        }else{
            
            if(sc == 0){
                if(mynum == 1){
                    cell.detailTextLabel?.text = "\(TimeArray[indexPath.row])　\(IdeaGenreArray[indexPath.row])"
                    //let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 32))
                    //imgView.image = UIImage(named: "hoshii3")!
                    
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 25))
                    let image = UIImage(systemName: "flag.fill")
                    let configuration =
                    UIImage.SymbolConfiguration(hierarchicalColor: .init(cgColor: my.cgColor))
                    imgView.preferredSymbolConfiguration = configuration
                    imgView.image = image
                    
                    cell.accessoryView = imgView
                }else{
                    cell.detailTextLabel?.text = "\(TimeArray[indexPath.row])　" + NameArray[indexPath.row]
                    
                    if(Auth.auth().currentUser?.uid ?? "test" == NameIDArray[indexPath.row]){
                        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 25))
                        let image = UIImage(systemName: "flag.fill")
                        let configuration =
                        UIImage.SymbolConfiguration(hierarchicalColor: .init(cgColor: my.cgColor))
                        imgView.preferredSymbolConfiguration = configuration
                        imgView.image = image
                        cell.accessoryView = imgView
                    }else{
                        
                        cell.accessoryView = nil
                    }
                    
                }
            }else{
                if(mynum == 1){
                    cell.detailTextLabel?.text = "欲しい数：\(LikeNumArray[indexPath.row])　\(IdeaGenreArray[indexPath.row])"
                    //let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 23, height: 32))
                    //imgView.image = UIImage(named: "hoshii3")!
                    let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 25))
                    let image = UIImage(systemName: "flag.fill")
                    let configuration =
                    UIImage.SymbolConfiguration(hierarchicalColor: .init(cgColor: my.cgColor))
                    imgView.preferredSymbolConfiguration = configuration
                    imgView.image = image
                    
                    cell.accessoryView = imgView
                }else{
                    cell.detailTextLabel?.text = "欲しい数：\(LikeNumArray[indexPath.row])　" + NameArray[indexPath.row]
                    
                    if(Auth.auth().currentUser?.uid ?? "test" == NameIDArray[indexPath.row]){
                        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 25))
                        let image = UIImage(systemName: "flag.fill")
                        let configuration =
                        UIImage.SymbolConfiguration(hierarchicalColor: .init(cgColor: my.cgColor))
                        imgView.preferredSymbolConfiguration = configuration
                        imgView.image = image
                        cell.accessoryView = imgView
                    }else{
                        
                        cell.accessoryView = nil
                    }
                }
            }
            
        }
        
        
        
        cell.textLabel?.font = UIFont(name: "Arial", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 13)
        cell.detailTextLabel?.textColor = UIColor.lightGray
        self.temp = 0
        
        /*
        // UIButton
        let addbutton = UIButton()
        addbutton.tag = indexPath.row
        // 押下時動作
        addbutton.frame = CGRect(x:self.view.frame.size.width-50, y:20, width:40, height: 40)
        addbutton.setImage(nil, for: .normal)
        addbutton.setImage(UIImage(systemName: "lightbulb.fill"), for: .normal)
        hoshiibuttons.append(addbutton)
        cell.addSubview(addbutton)
        addbutton.addTarget(nil, action: #selector(buttonEvent), for: .touchUpInside)
        return cell
        */
    
        return cell
    }
    
    @objc func buttonEvent(_ sender: UIButton) {
        let row = sender.tag
        print(row)
        hoshiibuttons[row].setImage(nil, for: .normal)
        hoshiibuttons[row].setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toEditViewController", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditViewController" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let next = segue.destination as? EditViewController else {
                    fatalError("Failed to prepare DetailViewController.")
                }
                
                next.IdeaId = IdeaIdArray[indexPath.row]
                next.IdeaTitle = IdeaTitleArray[indexPath.row]
                next.IdeaDetail = IdeaDetailArray[indexPath.row]
                next.IdeaGenre = IdeaGenreArray[indexPath.row]
                next.NameIDArray = NameIDArray[indexPath.row]
                next.NameArray = NameArray[indexPath.row]
                next.LikeNumArray = LikeNumArray[indexPath.row]
                next.ReportNumArray = ReportNumArray[indexPath.row]
                next.TimeArray = TimeArray[indexPath.row]
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
            }
        }
    }
    
    
    
    /* @IBAction func tapAddButton(_ sender: Any){
     let storyboard: UIStoryboard = self.storyboard!
     let next = storyboard.instantiateViewController(withIdentifier: "NaviViewController")
     self.present(next, animated: true, completion: nil)
     }*/
    
    
    @IBAction func tapLogoutButton(_ sender: Any) {
        let alert = UIAlertController(title:nil, message:  "オプション", preferredStyle: .alert)
        let delete = UIAlertAction(title: "ログアウトする", style: .destructive, handler: { (action) -> Void in
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    let storyboard: UIStoryboard = self.storyboard!
                    let next = storyboard.instantiateViewController(withIdentifier: "ViewController")
                    self.present(next, animated: true, completion: nil)
                } catch let error as NSError {
                    let dialog = UIAlertController(title: "ログアウト失敗", message: error.localizedDescription, preferredStyle: .alert)
                    dialog.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        })
        let defaultAction: UIAlertAction = UIAlertAction(title: "利用規約を読む", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            let url = URL(string: "https://termsandpolicy-sota-inc.netlify.app/")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
        })
        
        alert.addAction(defaultAction)
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func ChageList(){

        let alert: UIAlertController = UIAlertController(title: nil, message:nil, preferredStyle:  UIAlertController.Style.actionSheet)
        

        let defaultAction_1: UIAlertAction = UIAlertAction(title: "新着順", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            if(self.mynum == 0){
                self.GetIdeaDataForFirestoreNew()
                self.sc = 0
            }else{
                self.ChangeMyNew()
                self.sc = 0
            }
            
        })
        
        let defaultAction_2: UIAlertAction = UIAlertAction(title: "欲しい数順", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            if(self.mynum == 0){
                self.GetIdeaDataForFirestoreWant()
                self.sc = 1
            }else{
                self.ChangeMyWant()
                self.sc = 1
            }
            
        })

        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })


         alert.addAction(cancelAction)
         alert.addAction(defaultAction_1)
        alert.addAction(defaultAction_2)

        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func ChangeListControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            Genre = "アプリ"
            if(sc == 0){
                GetIdeaDataForFirestoreNew()
            }else{
                GetIdeaDataForFirestoreWant()
            }
            mynum = 0
        case 1:
            Genre = "日用品"
            if(sc == 0){
                GetIdeaDataForFirestoreNew()
            }else{
                GetIdeaDataForFirestoreWant()
            }
            mynum = 0
        case 2:
            Genre = "その他"
            if(sc == 0){
                GetIdeaDataForFirestoreNew()
            }else{
                GetIdeaDataForFirestoreWant()
            }
            mynum = 0
        case 3:
            Genre = "MyApp"
            if(sc == 0){
                ChangeMyNew()
            }else{
                ChangeMyWant()
            }
            mynum = 1
        default:
            Genre = "アプリ"
            if(sc == 0){
                GetIdeaDataForFirestoreNew()
            }else{
                GetIdeaDataForFirestoreWant()
            }
            mynum = 0
        }
    }
    
    
    /*
    @IBAction func changeOrderControl(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            if(mynum == 0){
                GetIdeaDataForFirestoreNew()
                sc = 0
            }else{
                ChangeMyNew()
                sc = 0
            }
        case 1:
            if(mynum == 0){
                GetIdeaDataForFirestoreWant()
                sc = 1
            }else{
                ChangeMyWant()
                sc = 1
            }
        default:
            if(mynum == 0){
                GetIdeaDataForFirestoreNew()
                sc = 0
            }else{
                ChangeMyNew()
                sc = 0
            }
        }
        
    }
    */
    
    
    func GetIdeaDataForFirestoreNew() {
        
        GetWantIdea()
        GetBlockUser()
        ChangeListNew()
        
    }
    
    
    func GetIdeaDataForFirestoreWant() {
        
        GetWantIdea()
        GetBlockUser()
        ChangeListWant()
        
    }
    
    func ChangeMyNew(){
        ChangeListMyAppsNew()
        ChangeListMyGoodsNew()
        ChangeListMyOthersNew()
    }
    
    func ChangeMyWant(){
        ChangeListMyAppsWant()
        ChangeListMyGoodsWant()
        ChangeListMyOthersWant()
    }
    
    //MyAppsを新着順に並び替える
    func ChangeListMyAppsNew(){
        Firestore.firestore().collection("アプリのideas").order(by: "createdAt",descending: true).addSnapshotListener({(querySnapshot, error) in
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
                    
                    if(Auth.auth().currentUser?.uid == data["UserID"] as? String){
                        self.s = 1
                    }
                    else{
                        self.s = 0
                    }
                    
                    if (self.s == 1){
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        likenumArray.append(data["LikeNum"] as! Int)
                        reportnumArray.append(data["ReportNum"] as! Int)
                        timeArray.append(data["updatedAt"] as! String)
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
                //self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
    }
    
    //MyGoodsを新着順に並び替える
    func ChangeListMyGoodsNew(){
        Firestore.firestore().collection("日用品のideas").order(by: "createdAt",descending: true).addSnapshotListener({(querySnapshot, error) in
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
                    
                    
                    if(Auth.auth().currentUser?.uid == data["UserID"] as? String){
                        self.s = 1
                    }
                    else{
                        self.s = 0
                    }
                    
                    if (self.s == 1){
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        likenumArray.append(data["LikeNum"] as! Int)
                        reportnumArray.append(data["ReportNum"] as! Int)
                        timeArray.append(data["updatedAt"] as! String)
                    }
                    
                }
                self.IdeaIdArray += idArray
                self.IdeaTitleArray += titleArray
                self.IdeaDetailArray += detailArray
                self.IdeaGenreArray += genreArray
                self.NameIDArray += nameidArray
                self.NameArray += nameArray
                self.LikeNumArray += likenumArray
                self.TimeArray += timeArray
                self.ReportNumArray += reportnumArray
                //self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
    }
    
    //MyOthersを新着順に並び替える
    func ChangeListMyOthersNew(){
        Firestore.firestore().collection("その他のideas").order(by: "createdAt",descending: true).addSnapshotListener({(querySnapshot, error) in
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
                    
                    if(Auth.auth().currentUser?.uid == data["UserID"] as? String){
                        self.s = 1
                    }
                    else{
                        self.s = 0
                    }
                    
                    if (self.s == 1){
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        likenumArray.append(data["LikeNum"] as! Int)
                        reportnumArray.append(data["ReportNum"] as! Int)
                        timeArray.append(data["updatedAt"] as! String)
                    }
                    
                }
                self.IdeaIdArray += idArray
                self.IdeaTitleArray += titleArray
                self.IdeaDetailArray += detailArray
                self.IdeaGenreArray += genreArray
                self.NameIDArray += nameidArray
                self.NameArray += nameArray
                self.LikeNumArray += likenumArray
                self.TimeArray += timeArray
                self.ReportNumArray += reportnumArray
                self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
    }
    
    
    //MyAppsを欲しい数順に並び替える
    func ChangeListMyAppsWant(){
        Firestore.firestore().collection("アプリのideas").order(by: "LikeNum",descending: true).addSnapshotListener({(querySnapshot, error) in
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
                    
                    if(Auth.auth().currentUser?.uid == data["UserID"] as? String){
                        self.s = 1
                    }
                    else{
                        self.s = 0
                    }
                    
                    if (self.s == 1){
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        likenumArray.append(data["LikeNum"] as! Int)
                        reportnumArray.append(data["ReportNum"] as! Int)
                        timeArray.append(data["updatedAt"] as! String)
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
                //self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
    }
    
    //MyGoodsを欲しい数順に並び替える
    func ChangeListMyGoodsWant(){
        Firestore.firestore().collection("日用品のideas").order(by: "LikeNum",descending: true).addSnapshotListener({(querySnapshot, error) in
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
                    
                    
                    if(Auth.auth().currentUser?.uid == data["UserID"] as? String){
                        self.s = 1
                    }
                    else{
                        self.s = 0
                    }
                    
                    if (self.s == 1){
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        likenumArray.append(data["LikeNum"] as! Int)
                        reportnumArray.append(data["ReportNum"] as! Int)
                        timeArray.append(data["updatedAt"] as! String)
                    }
                    
                }
                self.IdeaIdArray += idArray
                self.IdeaTitleArray += titleArray
                self.IdeaDetailArray += detailArray
                self.IdeaGenreArray += genreArray
                self.NameIDArray += nameidArray
                self.NameArray += nameArray
                self.LikeNumArray += likenumArray
                self.TimeArray += timeArray
                self.ReportNumArray += reportnumArray
                //self.tableView.reloadData()
            } else if let error = error {
                print("取得失敗: ccc" + error.localizedDescription)
            }
        })
    }
    
    //MyOthersを欲しい数順に並び替える
    func ChangeListMyOthersWant(){
        Firestore.firestore().collection("その他のideas").order(by: "LikeNum",descending: true).addSnapshotListener({(querySnapshot, error) in
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
                    
                    if(Auth.auth().currentUser?.uid == data["UserID"] as? String){
                        self.s = 1
                    }
                    else{
                        self.s = 0
                    }
                    
                    if (self.s == 1){
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        genreArray.append(data["Genre"] as! String)
                        nameidArray.append(data["UserID"] as! String)
                        nameArray.append(data["Name"] as! String)
                        likenumArray.append(data["LikeNum"] as! Int)
                        reportnumArray.append(data["ReportNum"] as! Int)
                        timeArray.append(data["updatedAt"] as! String)
                    }
                    
                }
                self.IdeaIdArray += idArray
                self.IdeaTitleArray += titleArray
                self.IdeaDetailArray += detailArray
                self.IdeaGenreArray += genreArray
                self.NameIDArray += nameidArray
                self.NameArray += nameArray
                self.LikeNumArray += likenumArray
                self.TimeArray += timeArray
                self.ReportNumArray += reportnumArray
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
    
    
    
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0) ,
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
}
