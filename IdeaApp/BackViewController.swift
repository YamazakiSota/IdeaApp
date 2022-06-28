//
//  BackViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/06/23.
//

import UIKit
import GoogleMobileAds

class BackViewController: UIViewController {

    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var AppButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DetailLabel: UILabel!
    @IBOutlet weak var HaikeiImage: UIImageView!
    @IBOutlet weak var HaikeiImage2: UIImageView!
    @IBOutlet weak var IdeaTitleLabel: UILabel!
    
    
    var bannerView: GADBannerView!
    var Title: String = ""
    var Titlestr: String = ""
    var name: String = ""
    var randomInt: Int = 0
    var ImageName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*AppButton.isEnabled = false
        //AppButton.adjustsImageWhenDisabled = false
        AppButton.layer.cornerRadius = 20.0
        AppButton.setImage(UIImage(named: "Color"), for: .normal)
        AppButton.imageView?.contentMode = .scaleAspectFill
        AppButton.contentHorizontalAlignment = .fill
        AppButton.contentVerticalAlignment = .fill
        AppButton.layer.borderColor = UIColor.gray.cgColor  // 枠線の色
        AppButton.layer.borderWidth = 5.0 // 枠線の太さ*/
        self.Titlestr = String(self.Title.prefix(14))
        IdeaTitleLabel.text = "『\(self.Titlestr)』"
        
        
        self.randomInt = Int.random(in: 1..<5)
        if(self.randomInt == 1){
        TitleLabel.text = "アプリ『BainaryStop』"
        DetailLabel.text = "二進数のストップウォッチで遊ぼう!!\n『BainaryStop』をインストールしませんか?"
        self.ImageName = "Binary"
        
        }else if (self.randomInt == 2){
            TitleLabel.text = "アプリ『色彩クイズ』"
            DetailLabel.text = "色の名前を当てよう!(色彩検定対応)\n『色彩クイズ』をインストールしませんか?"
            self.ImageName = "Color"
            
        }else if (self.randomInt == 3){
            TitleLabel.text = "アプリ『長野県クイズ』"
            DetailLabel.text = "長野県にまつわるクイズに挑戦しよう!!\n『長野県クイズ』をインストールしませんか?"
            self.ImageName = "Nagano"
            
        }else if (self.randomInt == 4){
            TitleLabel.text = "アプリ『季語クイズ』"
            DetailLabel.text = "いろいろな季語を学んでみよう!!\n『季語クイズ』をインストールしませんか?"
            self.ImageName = "Kigo"
            
        }
            
            
        HaikeiImage.layer.cornerRadius = 20
        HaikeiImage2.layer.cornerRadius = 20
            
        // UIImage インスタンスの生成
         let image:UIImage = UIImage(named:"\(self.ImageName)")!
         // UIImageView 初期化
         let imageView = UIImageView(image:image)
         
         // 画面の横幅を取得
         let screenWidth:CGFloat = view.frame.size.width
         let screenHeight:CGFloat = view.frame.size.height
         
         // 画像の幅・高さの取得
         let imgWidth = image.size.width
         let imgHeight = image.size.height
         
         // 画像サイズをスクリーン幅に合わせる
         let scale = screenWidth / imgWidth * 0.2
         let rect:CGRect = CGRect(x:0, y:0,
                           width:imgWidth*scale, height:imgHeight*scale)
  
         // ImageView frame をCGRectで作った矩形に合わせる
         imageView.frame = rect;
         
         // 画像の中心を画面の中心に設定
         imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2-220)
  
         // 角丸にする
         imageView.layer.cornerRadius = imageView.frame.size.width * 0.1
         imageView.clipsToBounds = true
        
        //枠線
        imageView.layer.borderColor = UIColor.gray.cgColor  // 枠線の色
        imageView.layer.borderWidth = 5.0 // 枠線の太さ*/
         
         // UIImageViewのインスタンスをビューに追加
         self.view.addSubview(imageView)
        
        

            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            bannerView.adUnitID = "ca-app-pub-5041739959288046/6354834758"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            addBannerViewToView(bannerView)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }

    @IBAction func BackToList(){
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
    
    @IBAction func ShareAction(){
        let activityItems = ["私は『\(self.Title)』が欲しい！\n\nあなたも「あったらいいな」をシェアしよう！！\n(もしかしたら作ってもらえるかも...)\n\nダウンロードはこちら\n(iPhoneのみ)\nhttps://apps.apple.com/jp/app/%E3%81%82%E3%81%A3%E3%81%9F%E3%82%89%E3%81%84%E3%81%84%E3%81%AA/id1628333605"]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
        }
    
    @IBAction func AppCheck(_ sender: Any) {
        
            //Binary
        if(self.randomInt == 1){
            let url = URL(string: "https://apps.apple.com/jp/app/binarystop/id1624081592")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }else if(self.randomInt == 2){
            let url = URL(string: "https://apps.apple.com/jp/app/%E3%82%AF%E3%82%A4%E3%82%BA%E8%89%B2%E5%BD%A9/id1615005922")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            
        }else if(self.randomInt == 3){
            let url = URL(string: "https://apps.apple.com/jp/app/%E3%82%AF%E3%82%A4%E3%82%BA%E9%95%B7%E9%87%8E/id1615022653")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            
        }
        else if(self.randomInt == 4){
            let url = URL(string: "https://apps.apple.com/jp/app/%E3%82%AF%E3%82%A4%E3%82%BA%E5%AD%A3%E8%AA%9E/id1614868292")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
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
