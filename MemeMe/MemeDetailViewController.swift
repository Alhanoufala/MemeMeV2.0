//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Alhanouf Alawwad on 09/11/1442 AH.
//

import Foundation
import UIKit
class MemeDetailViewController :UIViewController {
    var meme: Meme!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = meme.memedImage
        hideTabBar(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideTabBar(false)
        
    }
    // Hide Tab Bar
    func hideTabBar(_ status: Bool){
        self.tabBarController?.tabBar.isHidden = status
    }
    
}
