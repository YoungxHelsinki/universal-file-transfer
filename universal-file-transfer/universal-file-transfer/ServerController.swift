//
//  ServerController.swift
//  universal-file-transfer
//
//  Created by YOUNG on 2/20/16.
//  Copyright © 2016 Mobile Mob. All rights reserved.
//

import Foundation
import GCDWebServer
import Alamofire

public class ServerController {
    
    let webServer = GCDWebServer()
    var imageDictionary = [String:UIImage]()
    var downloadablePaths = [DownloadableItem]()
    /*
        Starts, listens, uploads, downloads, stops
    */
    
    func stop() {
        
    }
    
    func upload() {
        
    }
    
    
    public func startGivingImage(image:UIImage) -> String{
        /*
           Upload image to a path localhost/image_key
*/
        let index:String = String(self.imageDictionary.count) + ".png"
        self.imageDictionary[index] = image
        return index
//        self.runServer()
    }
    
    private func getImageAsNSData(index: String) throws -> NSData {
        let data = try GeneralHelper.getData(self.imageDictionary, key: index)

        return UIImagePNGRepresentation(data)!
    }
    
    // ex). removeSlashFromPath('/123') => '123'
    private func removeSlashFromPath (path: String) -> String {
        /*
            http://stackoverflow.com/a/26270721
        */
        let pathWithoutSlash = path.characters.split{$0 == "/"}.map(String.init)
        if(!pathWithoutSlash.isEmpty){
        return pathWithoutSlash[0]
        }
        else {
            return ""

        }
    }
    
    
    private func respondToRequest(request: GCDWebServerRequest, completionBlock: GCDWebServerCompletionBlock) {
        let fileKey = removeSlashFromPath(request.path)
        let response: GCDWebServerResponse?
        let imageData: NSData?
        do {
            imageData = try getImageAsNSData(fileKey)
            response = GCDWebServerDataResponse(data: imageData, contentType: "image/png")
        } catch  {
            response = GCDWebServerErrorResponse(HTML: "The index doesn't exist")
//            GCDWebServerErrorResponse.init
//            response = GCDWebServerErrorResponse.init(statusCode: 404)
            response?.statusCode = 404
        }
        
//        let filePath = NSBundle.mainBundle().pathForResource("cat", ofType: "jpg")
//        let response = GCDWebServerFileResponse(file: filePath)
//        print(response.description)
        print("path: ", request.path)
        print("method: ",request.method)
        print("URL: ", request.URL)
        print("headers: ",request.headers)
        print("query: ",request.query)
//        print(request.contentType)
//        print(request.)
        
        
        
        completionBlock(response)
    }
    
    init() {
        self.runServer()
    }
    
    func runServer() {
        
//        self.webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self, processBlock: {request in
//            return GCDWebServerDataResponse(HTML:"<html><body><p>Hello World</p></body></html>")
//            
//        })
        
        self.webServer.addDefaultHandlerForMethod("GET", requestClass: GCDWebServerRequest.self) { (let request, let completionBlock) -> Void in
            self.respondToRequest(request, completionBlock: completionBlock)
        }
        
        self.webServer.addDefaultHandlerForMethod("PUT", requestClass: GCDWebServerRequest.self) { (let request, let completionBlock) -> Void in
            NSLog(request.path)
            NSLog(request.remoteAddressString)
            let path = request.path
            let requestUrl = request.remoteAddressString
            let url = requestUrl.componentsSeparatedByString(":").first! + ":8080"

            let item = DownloadableItem(url: url, path: path)
            GeneralHelperInstance.addNewItem(item)
            
            completionBlock(GCDWebServerDataResponse(HTML: "Received PUT"))
        }
        
        self.webServer.startWithPort(8080, bonjourName: "GCD Web Server")
        
        print("Visit \(self.webServer.serverURL) in your web browser")
    }

    
}