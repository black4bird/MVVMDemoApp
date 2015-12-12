//
//  CreatePostInfoViewController.swift
//  ConsumeREST
//
//  Created by LNKN on 05/12/15.
//  Copyright © 2015 LNKN. All rights reserved.
//

import Foundation
import UIKit
import Bond

class CreatePostInfoViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UITextViewDelegate{
    
    let identifier = "tagCell"
    let model = CreatePostModel()
    var tagArray = NSArray()
    var selectedTag = NSMutableArray()
    var postImage = UIImage()
    let imageView = UIImageView()
    let descriptionTextView = UITextView()
    var tagCollectionView : UICollectionView
    let tagViewLabel = UILabel()
    let doneButton = UIButton()
    var image = UIImage()
    init(image: UIImage){
        self.image = image
        let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(90, 60)
        flowLayout.scrollDirection = .Horizontal
        
        tagCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        self.postImage = image
        super.init(nibName: nil, bundle: nil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
        let backImageView = UIImageView(frame: CGRectMake(0,0,25,25))
        backImageView.image = UIImage(named: "back-icon")
        backImageView.contentMode = .ScaleAspectFit
        backImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "goBack")
        backImageView.addGestureRecognizer(tapGesture)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backImageView)

    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        view.addSubview(imageView)
        view.addSubview(descriptionTextView)
        view.addSubview(tagViewLabel)
        view.addSubview(tagCollectionView)
        view.addSubview(doneButton)
        var posY :CGFloat = 0;

        imageView.frame=CGRectMake(0, 0, AppConstant.appWidth, AppConstant.appWidth*3/4)
        imageView.image = postImage
        imageView.contentMode = .ScaleToFill
        posY = imageView.frame.height
        
        let heightOfRest = AppConstant.appHeight - posY - 64;
        descriptionTextView.frame = CGRectMake(0, posY, AppConstant.appWidth, heightOfRest/3)
        descriptionTextView.font = UIFont.appRegularFont(16)
        descriptionTextView.text = "Write your description"
        descriptionTextView.textColor = UIColor.whiteColor()
        descriptionTextView.backgroundColor = UIColor.lightGrayColor()
        descriptionTextView.delegate = self
        posY += descriptionTextView.frame.height
        
        tagViewLabel.frame = CGRectMake(0,posY,AppConstant.appWidth,heightOfRest/6)
        tagViewLabel.text = "       Choose your tags"
        tagViewLabel.font = UIFont.appRegularFont(16)
        posY += tagViewLabel.frame.height
        
        tagCollectionView.frame = CGRectMake(0, posY, AppConstant.appWidth, heightOfRest/3)
        tagCollectionView.backgroundColor = UIColor.lightGrayColor()
        tagCollectionView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5)
        posY += tagCollectionView.frame.height
        
        doneButton.frame = CGRectMake(0,posY,AppConstant.appWidth,heightOfRest/6)
        doneButton.backgroundColor = UIColor.appColor()
        doneButton.setTitle("DONE", forState: .Normal)
        doneButton.contentHorizontalAlignment = .Center
        doneButton.contentVerticalAlignment = .Center
        //doneButton.titleLabel?.textAlignment = .Center
        doneButton.titleLabel!.font = UIFont.appRegularFont(25)
        doneButton.bnd_tap.observe {
            let descriptionText = (self.descriptionTextView.textColor == UIColor.whiteColor()) ? "" :self.descriptionTextView.text
            WebService.sharedInstance.queryForCreateImage(self.image, description: descriptionText, tagArray: self.selectedTag)
            let vc = HomeViewController()
            self.navigationController?.pushViewController(vc, animated:false)
            
        }
        
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.allowsMultipleSelection = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        imageView.addGestureRecognizer(tapGesture)
        imageView.userInteractionEnabled = true
        bindModel({})
    }
    
    func bindModel(completionHandler:()->Void){
        model.refreshTagArray()
        model.tagsObserve.observe { (feeds) -> Void in
            self.tagArray = feeds
            self.tagCollectionView.reloadData()
            completionHandler()
        }
    }

    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: Text view delegate
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.whiteColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        
        return textView.text.characters.count + (text.characters.count - range.length) <= 100;
    }
    
    //MARK: COllection view delegate and data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return tagArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        let text = (tagArray.objectAtIndex(indexPath.row) as! TagObject).getName()
        let label = UILabel(frame: CGRectMake(0,0,cell.frame.width,cell.frame.height))
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        label.text = text
        label.font = UIFont.appRegularFont(12)
        label.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIView()
        cell.backgroundView?.addSubview(label)
        cell.backgroundColor = !cell.selected ? UIColor.whiteColor() : UIColor.grayColor()
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.blackColor().CGColor
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = tagCollectionView.cellForItemAtIndexPath(indexPath)
        let text = (tagArray.objectAtIndex(indexPath.row) as! TagObject).getName()
        selectedTag.addObject(text)
        cell?.backgroundColor = UIColor.grayColor()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = tagCollectionView.cellForItemAtIndexPath(indexPath)
        let text = (tagArray.objectAtIndex(indexPath.row) as! TagObject).getName()
        selectedTag.removeObject(text)
        cell?.backgroundColor = UIColor.whiteColor()
    }
}