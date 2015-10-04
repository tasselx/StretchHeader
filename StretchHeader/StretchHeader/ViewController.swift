//
//  ViewController.swift
//  StretchHeader
//
//  Created by Tassel on 15/10/4.
//  Copyright © 2015年 Tassel. All rights reserved.
//

import UIKit
import ObjectiveC

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var myTableView:UITableView?
    var topImageView:UIImageView?
    let topViewHeight:CGFloat = 200
    
    override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
     self.title = "Home"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: nil)
      setupSubViews()

    }

    func setupSubViews() {
    
        self.myTableView = {
            
            let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.rowHeight = 44
            tableView.showsVerticalScrollIndicator = false
            return tableView
            }()
        
        self.myTableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.myTableView?.contentInset = UIEdgeInsetsMake(topViewHeight, 0, 0, 0)
        self.view.addSubview(self.myTableView!)
        
        
        let topView = UIImageView(frame: CGRectMake(0, -topViewHeight, (self.myTableView?.frame.size.width)!, topViewHeight))
        topView.image = UIImage(named: "bg.png")
        self.myTableView?.addSubview(topView)
        self.topImageView = topView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 20;
    }
    
  
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        let xOffset = (CGFloat(yOffset) + topViewHeight) / 2
  
        if (yOffset < -topViewHeight) {
        
            var rect = self.topImageView?.frame
            rect?.origin.y = yOffset
            rect?.size.height = -yOffset
            rect?.origin.x = xOffset
            rect?.size.width = scrollView.frame.size.width + fabs(xOffset)*2
            
            self.topImageView?.frame = rect!
        }
      
        
        if (self.edgesForExtendedLayout == UIRectEdge.All || self.edgesForExtendedLayout == UIRectEdge.Top) {
           
            let alpha = (yOffset + 64 + topViewHeight) / topViewHeight
            let color = UIColor(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1).colorWithAlphaComponent(alpha)
            self.navigationController?.navigationBar.setBackgroudColor(color)
        }
        
    }
    

}

// MARK:
var AssociatedObjectHandle: UInt8 = 0

extension UINavigationBar {

    var overlay:UIView? {
    
        get {
            return objc_getAssociatedObject(self,&AssociatedObjectHandle) as? UIView
        }
        set {
          objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setBackgroudColor(color:UIColor) {

        if self.overlay == nil {
        
            self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            self.overlay = UIView(frame: CGRectMake(0, -20, UIScreen.mainScreen().bounds.size.width, self.bounds.height + 20))
            self.overlay?.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
            self.insertSubview(self.overlay!, atIndex: 0)
        }
       
        self.shadowImage = UIImage()
        self.overlay?.backgroundColor = color
    }
}
