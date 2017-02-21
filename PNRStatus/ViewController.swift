//
//  ViewController.swift
//  PNRStatus
//
//  Created by mohanesh-1609 on 16/02/17.
//  Copyright © 2017 PSM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var PNRTextField: UITextField!
    //@IBOutlet weak var responseTextView: UITextView!
    
    @IBOutlet weak var PNRResponseTextView: UITextView!
    var passengerList = [Any](){
        didSet{
            updatePNRList()
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        let textVal = PNRTextField.text!
        let apiKey: String = "prhvu3wk"
        let urlString: String = "http://api.railwayapi.com/pnr_status/pnr/\(textVal)/apikey/\(apiKey)/"
        let postURL = URL(string: urlString)
        print(apiKey, urlString)
        let urlRequest = URLRequest(url: postURL!)
        let session = URLSession.shared
        //button.removeFromSuperview()
        PNRTextField.resignFirstResponder()
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else{ return }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let temp = json["passengers"]
                self.passengerList = [temp!];
            }catch let error as NSError{
                print(error)
            }
            
        })
        task.resume()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updatePNRList(){
        let temp = passengerList;
        var text = "";
        for i in temp[0] as! [AnyObject]{
            let obj = i as! NSDictionary
            for (key, value) in obj {
                text += "\(key) vs \(value) \n"
            }
            print(text)
           // responseTextView.text = "Some new text";
        }
        
        DispatchQueue.main.async {
            self.PNRResponseTextView.text = text;
        }

    }
    
}

