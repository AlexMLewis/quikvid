//
//  GroupViewController.swift
//  quikvid
//
//  Created by Gordon Moore on 1/4/18.
//  Copyright © 2018 Alexander Lewis. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var posts = [Post]()
    var postCount = 0
    var memberCount = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // receives group name from upload photo view controller
    var group:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = group
        
        UserService.groupInfo(groupName: group) { (groupcount, posts) in
            self.posts = posts
            self.postCount = posts.count
            self.memberCount = groupcount
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension GroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupThumbnailCell", for: indexPath) as! GroupThumbnailCell
        
        let post = posts[indexPath.row]
        let imageURL = URL(string: post.imageURL)
        cell.imageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GroupHeaderView", for: indexPath) as! GroupHeaderView
        
        headerView.postCountLabel.text = "\(postCount)"
        headerView.membersCountLabel.text = "\(memberCount)"
        
        return headerView
    }
}

extension GroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.5
    }
}
































