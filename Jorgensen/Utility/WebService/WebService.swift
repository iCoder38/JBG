//
//  WebService.swift
//  Jorgensen
//
//  Created by Shyam on 06/10/20.
//  Copyright © 2020 EVS. All rights reserved.
//

import Foundation
import UIKit

// Webservice delegate (Protocal)
protocol WebServiceDelegate:class{
    func getDataFormWebService(jsonResult:NSDictionary, methodName:NSString)
    func webServiceFail(error:NSError)
    func webServiceFailWithApplicationServerMSG(msg:String)
}

class WebService: NSObject {
    
    weak var delegate : WebServiceDelegate?
    var msg:String? = nil
    
    // MARK:- SERVICE USING POST METHOD
    
    func servicePOSTMethod(postStr:NSString, urlStr:NSString, methodName:NSString){
        print("urlStr post String:\(urlStr)")
        print("postStr post URL:\(postStr)")
        print("postStr post method name:\(methodName)")
        let postData:NSData! = postStr.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)! as NSData
        let postLength:NSString = String( postData.length ) as NSString
        let url:NSURL! = NSURL(string:urlStr as String)
        //print(url);
        let request:NSMutableURLRequest! = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue(postLength as String, forHTTPHeaderField:"Content-Length")
        request.setValue("text/plain", forHTTPHeaderField:"Content-Type")
        request.httpBody = postData! as Data
        request.timeoutInterval = 30.0
        let session = URLSession( configuration: URLSessionConfiguration.ephemeral);
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if (error == nil && (data?.count)!>0){
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as? NSDictionary {
                        print(jsonResult)
                        let status:NSString = (jsonResult.value(forKey: "status") as! NSString).lowercased as NSString
                        if status.isEqual(to: "success"){
                            DispatchQueue.main.async(){
                                self.delegate?.getDataFormWebService(jsonResult: jsonResult, methodName: methodName)
                            }
                        }else{
                            DispatchQueue.main.async(){
                                self.msg = jsonResult.value(forKey: "msg") as? String
                                if self.msg == nil{
                                    self.msg = jsonResult.value(forKey: "message") as? String
                                    if self.msg == nil{
                                        self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                                    }else{
                                        self.delegate?.webServiceFailWithApplicationServerMSG(msg: self.msg!)
                                    }
                                }else{
                                    self.delegate?.webServiceFailWithApplicationServerMSG(msg: self.msg!)
                                }
                            }}
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    DispatchQueue.main.async(){
                        self.delegate?.webServiceFail(error: error);
                    }
                }
            }else if (error == nil && data?.count==0){
                DispatchQueue.main.async(){
                    //let msg:NSString =
                    self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                }
            }else if (error != nil){
                DispatchQueue.main.async() {
                    self.delegate?.webServiceFail(error: error! as NSError);
                }
            }
        })
        task.resume()
    }
    
    // MARK:- SERVICE USING GET METHOD
    
    func serviceGETMethod(urlStr:NSString,methodName:NSString){
        let urlEncode : String! = urlStr.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url:URL! = URL(string:(urlEncode)!)
        let request:NSMutableURLRequest! = NSMutableURLRequest(url: url as URL)
        request.timeoutInterval = 30.0
        let session = URLSession( configuration: URLSessionConfiguration.ephemeral);
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            if (error == nil && (data?.count)!>0){
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        print(jsonResult)
                        self.delegate?.getDataFormWebService(jsonResult: jsonResult, methodName:methodName)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }else if (error == nil && data?.count==0){
                DispatchQueue.main.async(){
                    self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                }
            }else if (error != nil){
                DispatchQueue.main.async() {
                    self.delegate?.webServiceFail(error: error! as NSError);
                }
            }
        })
        task.resume()
    }
    
    // MARK:- SERVICE USING POST METHOD
    func serviceUploadImagePOSTMethod(urlStr:NSString, methodName:NSString,parameter:NSMutableDictionary,filePathKey:String,image:UIImage){
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
        concurrentQueue.sync {
            let url:NSURL! = NSURL(string:urlStr as String)
            //print(url);
            let request:NSMutableURLRequest! = NSMutableURLRequest(url: url as URL)
            // request cache policy
            request.cachePolicy =  NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            // Handle Cookies
            request.httpShouldHandleCookies = false
            // Method Type
            request.httpMethod = "POST"
            // request Body
            request.httpBody = Alert.createRequestBodyWith(parameters: parameter as! [String : NSObject], filePathKey: filePathKey, boundary: Alert.generateBoundaryString(), fileName: "image", image: image) as Data
            // Request Time out
            request.timeoutInterval = 30.0
            let session = URLSession( configuration: URLSessionConfiguration.ephemeral);
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if (error == nil && (data?.count)!>0){
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            print(jsonResult)
                            let status:NSString = jsonResult.value(forKey: "status") as! NSString
                            if status.isEqual(to: "success"){
                                DispatchQueue.main.async(){
                                    self.delegate?.getDataFormWebService(jsonResult: jsonResult, methodName: methodName)
                                }
                            }else{
                                DispatchQueue.main.async(){
                                    self.msg = jsonResult.value(forKey: "msg") as? String
                                    if self.msg == nil{
                                        self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                                    }else{
                                        self.delegate?.webServiceFailWithApplicationServerMSG(msg: self.msg!)
                                    }
                                }
                            }
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        DispatchQueue.main.async(){
                            self.delegate?.webServiceFail(error: error);
                        }
                    }
                }else if (error == nil && data?.count==0){
                    DispatchQueue.main.async(){
                        self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                    }
                }else if (error != nil){
                    DispatchQueue.main.async() {
                        self.delegate?.webServiceFail(error: error! as NSError);
                    }
                }
            })
            task.resume()
        }
    }
}

