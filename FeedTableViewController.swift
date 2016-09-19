//
//  FeedTableViewController.swift
//  InClass07
//
//  Created by student on 7/26/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//

import UIKit
import SDWebImage

class FeedTableViewController: UITableViewController, NSXMLParserDelegate {
    
    var parser = NSXMLParser()
    
    var category = NSString()
    var artist = NSString()
    var name = NSString()
    var squareImage = NSString()
    var otherImage = NSString()
    var releaseDate = NSString()
    var summary = NSString()
    var price = NSString()

    var element = NSString()
    var dataFeedObjects:[App]?
    var sections:[String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
    }
    
    func fetchData() {
        dataFeedObjects = []
        sections = []
        parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://dev.theappsdr.com/apis/summer_2016_ios/api.xml"))!)!
        parser.delegate = self
        parser.parse()
        
        tableView.reloadData()
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
   
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if dataFeedObjects?.count == nil {
            return 0
        } else {
            let searchText = self.sections![section]
            let feedRows:[App] = (dataFeedObjects?.filter({ $0.category == searchText}))!
            return feedRows.count
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let searchText = self.sections![indexPath.section]
        let feedRows:[App] = (dataFeedObjects?.filter({ $0.category == searchText}))!
        let app = feedRows[indexPath.row]
        
        var cell:UITableViewCell?
        
        if app.otherImage! == "" && app.summary! == "" {
            cell = tableView.dequeueReusableCellWithIdentifier("appCellDefault", forIndexPath: indexPath)
            //print("1 -- \(app.name!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))")
        } else if app.otherImage! != "" {
            cell = tableView.dequeueReusableCellWithIdentifier("appCellImage", forIndexPath: indexPath)
            let otherurl = NSURL(string: app.otherImage!)
            (cell!.viewWithTag(6) as? UIImageView)?.sd_setImageWithURL(otherurl)
            (cell!.viewWithTag(6) as? UIImageView)?.layer.cornerRadius = 8.0
            (cell!.viewWithTag(6) as? UIImageView)?.clipsToBounds = true
            //print("2 -- \(app.name!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))")
            //print(app.otherImage!)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("appCellSummary", forIndexPath: indexPath)
            (cell!.viewWithTag(7) as? UILabel)?.text = app.summary!
            //print("3 -- \(app.name!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))")
            //print(app.summary!)
        }
        
        (cell!.viewWithTag(2) as? UILabel)?.text =  app.name!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        (cell!.viewWithTag(3) as? UILabel)?.text = app.artist
        (cell!.viewWithTag(4) as? UILabel)?.text = app.releaseDate
        (cell!.viewWithTag(5) as? UILabel)?.text = "$" + app.price!
        
        let url = NSURL(string: app.squareImage!)
        (cell!.viewWithTag(1) as? UIImageView)?.sd_setImageWithURL(url)
        (cell!.viewWithTag(1) as? UIImageView)?.layer.cornerRadius = 8.0
        (cell!.viewWithTag(1) as? UIImageView)?.clipsToBounds = true
        /*imageView.layer.cornerRadius = 8.0
         imageView.clipsToBounds = true*/
        
        return cell!
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections![section]
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("feed")
        {
            category = attributeDict["category"]!
            price = attributeDict["price"]!
            otherImage = ""
            summary = ""
        } else if (elementName as NSString).isEqualToString("artist") {
            artist = ""
        } else if (elementName as NSString).isEqualToString("name") {
            name = ""
        } else if (elementName as NSString).isEqualToString("squareImage") {
            squareImage = attributeDict["url"]!
        } else if (elementName as NSString).isEqualToString("releaseDate") {
            releaseDate = ""
        } else if (elementName as NSString).isEqualToString("otherImage") {
            otherImage = attributeDict["url"]!
        } else if (elementName as NSString).isEqualToString("summary") {
            summary = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if element.isEqualToString("artist") {
            artist = (artist as String) + string
        } else if element.isEqualToString("name") {
            name = (name as String) + string
        }  else if element.isEqualToString("releaseDate") {
            releaseDate = (releaseDate as String) + string
        }  else if element.isEqualToString("summary") {
            summary = (summary as String) + string
        }
    }
    
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
       if (elementName as NSString).isEqualToString("feed") {
            let app = App(category: category as String, artist: artist as String, name: name as String, squareImage: squareImage as String, otherImage: otherImage as String, releaseDate: releaseDate as String, summary: summary as String, price: price as String)
            dataFeedObjects?.append(app)
            if !(sections!.contains(category as String)) {
                sections?.append(category as String)
            }
        }
    }
    

}
