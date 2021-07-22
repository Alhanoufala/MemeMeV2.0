//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Alhanouf Alawwad on 09/11/1442 AH.
//

import Foundation

import Foundation
import UIKit
class MemeTableViewController: UITableViewController {
    
    //Access the shared model from the Application Delegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Update the table view with new data when view will appear
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell" ,for:indexPath ) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        //Set image and label
        cell.label.text = meme.topText + " ... " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Grab detail view controller from storyboard
        let detailViewController = self.storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailViewController.meme = memes [(indexPath as NSIndexPath).row]
        
        //Present the view controller using navigation
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
}
