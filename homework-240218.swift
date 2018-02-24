//
//  ViewController.swift
//  emaxx_wiki
//
//  Created by admin on 22.02.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var resContent = "<html>"
    
    @IBOutlet weak var webView0: UIWebView!
    
    @IBAction func fetchWikiAPI(_ sender: Any) {
        let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&titles=Main%20Page&prop=revisions&rvprop=content&format=json&formatversion=2")
        
        let session = URLSession.shared
        let task = session.dataTask(with: url!) {
            (data,response,error) in
            guard error == nil else { return }
            //одно и то же
            //if error !=nil {return}
            //    dump(resp)
            let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
            
            self.enumerateThroughtDict(dict!)
        }
        task.resume() //запускает выполнение запроса task
    }
    
    func enumerateThroughtDict(_ dict: Any) -> [String : Any]{
        //print("-------------------------------------------------------------")
        var result: [String:Any] = [:]
        
        guard let transformerDict = dict as? [String: Any] else {return [:]}
        
        for key in transformerDict.keys {
            
            if let newDict = transformerDict[key] as? [String: Any] {
                let nestedDict = enumerateThroughtDict(newDict)
                for nestedKey in nestedDict.keys {
                    result[nestedKey] = nestedDict[nestedKey]
                }
            }
                
            else if let newArr = transformerDict[key] as? Array<Any>, !newArr.isEmpty {
                for item in newArr {
                    enumerateThroughtDict(item)
                }
            }
                
            else
            {
                //print("\n\n\nfor key: \(key) ", transformerDict[key])
                result[key] = transformerDict[key]
                if(key=="content") {
                resContent += "\(result[key]) </html>"
                }
                
            }
        }
        //print("\n----------------------------------\n\n\n\n\n\n\n",resContent)
        webView0.loadHTMLString(resContent, baseURL: nil)
        return result
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let myHTMLString:String! = "<h1>Hello Pizza!</h1>"
        //webView0.loadHTMLString(myHTMLString, baseURL: nil)
        // Do any additional setup after loading the view, typically from a nib.
        webView0.isUserInteractionEnabled=true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

