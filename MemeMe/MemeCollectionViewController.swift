//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Alhanouf Alawwad on 08/11/1442 AH.
//

import Foundation
import UIKit

class MemeCollectionViewController :UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //Access the shared model from the Application Delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Update the collection view with new data when view will appear
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        
        //Set flow layout
        let space:CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).item]
        //Set image
        cell.collectionImageView?.image =  meme.memedImage
        return cell
    }
    
    override  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Grab detail view controller from storyboard
        let detailViewController = self.storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailViewController.meme = memes [(indexPath as NSIndexPath).row]
        
        //Present the view controller using navigation
        navigationController?.pushViewController(detailViewController, animated: true)
        
        
    }
    
}
