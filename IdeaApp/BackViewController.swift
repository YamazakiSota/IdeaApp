//
//  BackViewController.swift
//  IdeaApp
//
//  Created by 山崎颯汰 on 2022/06/23.
//

import UIKit

class BackViewController: UIViewController {

    @IBOutlet weak var BackButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }

    @IBAction func BackToList(){
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
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
