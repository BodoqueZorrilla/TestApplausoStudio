//
//  ViewController.swift
//  Test Applaudo Sergio Zorrilla
//
//  Created by Sergio Eduardo Zorrilla Arellano on 18/08/17.
//  Copyright © 2017 Bodoque Inc. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,  UITextFieldDelegate {
    
    @IBOutlet weak var tfSearch: UITextField!
    var search:String=""
    @IBOutlet weak var cvSeries: UICollectionView!
    var TableData: Array<String> = Array<String>()
    var TableSearchTitle : Array<String> = Array<String>()
    
    var isSearch : Bool!
    
    let url = "https://api.myjson.com/bins/pizm1"
    var success = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentReachabilityStatus != .notReachable{
            let request = NSMutableURLRequest(url: URL(string: url)!)
            request.httpMethod = "GET"
            
            let postString = ""
            
            request.httpBody = postString.data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if(error == nil && data != nil){
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                        
                        print("JSON->\(json)")
                        
                        if let success = json["success"] as? Int{
                            print("hola\(success)")
                            self.success = success
                        }
                        
                        if let series = json["series"] as? [[String: AnyObject]]{
                            
                            for serie in series{
                                if let id = serie["id"] as? String{
                                    if let title = serie["title"] as? String{
                                        if let image = serie["image"] as? String{
                                            if let video = serie["video"] as? String{
                                                if let synopsis = serie["synopsis"] as? String{
                                                    DispatchQueue.main.sync(execute: {
                                                        self.TableData.append(id+"|||" + title+"|||"+image+"|||"+video+"|||"+synopsis)
                                                        
                                                        self.TableSearchTitle = self.TableData
                                                    })
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if ( self.success == 1){
                             self.do_talbe_refresh()
                        }else{
                            
                            let alert = UIAlertController(title: "Alert:", message: "Without results", preferredStyle: UIAlertControllerStyle.alert)
                            
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        
                    }catch{
                        print("Error?\(error)")
                    }
                    
                    return
                }else{
                    print("error=\(error)")
                }
            }
            
            task.resume()
            
        }else{
            let alert = UIAlertController(title: "Alert:", message: "Please, check you network connection", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    
        
        cvSeries.delegate = self
        cvSeries.dataSource = self
        tfSearch.delegate = self
        tfSearch.tag = 0
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if string.isEmpty {
            search = String(search.characters.dropLast())
        }
        else {
            search=textField.text!+string
        }
        
        print(search)
        let predicate=NSPredicate(format: "SELF CONTAINS[cd] %@", search)
        let arr=(TableData as NSArray).filtered(using: predicate)
        
        if arr.count > 0
        {
            TableSearchTitle.removeAll(keepingCapacity: true)
            TableSearchTitle=arr as! Array<String>
        }
        else
        {
            TableSearchTitle=TableData
            
        }
        
        if(textField.text == ""){
            tfSearch.resignFirstResponder()
        }
        
        
        self.cvSeries.reloadData()
        return true

    }
    
    
    func do_talbe_refresh()
    {
        DispatchQueue.main.async {
            self.cvSeries.reloadData()
            return
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SeriesCell
        
        let array = self.TableData[indexPath.row].components(separatedBy: "|||")
        cell.ivImage.sd_setImage(with: URL(string: array[2]))
        cell.lblName.text = array[1]
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let array = self.TableData[indexPath.row].components(separatedBy: "|||")
        
        UserDefaults.standard.set(array[1], forKey: "title")
        UserDefaults.standard.set(array[3], forKey: "video")
        UserDefaults.standard.set(array[4], forKey: "synopsis")
        
        var storyboard: UIStoryboard! = nil
        
        tfSearch.resignFirstResponder()
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyboard.instantiateViewController(withIdentifier: "SeeAnime") as! SeeAnime
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }  else {
            // Not found, so remove keyboard.
            tfSearch.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
 


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

