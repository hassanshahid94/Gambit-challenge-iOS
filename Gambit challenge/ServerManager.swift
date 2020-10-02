//
//  ServerManager.swift
//  Gambit challenge
//
//  Created by Hassan on 1.10.2020.
//

import Foundation

import Alamofire

class ServerManager {
    
    public static func getTextFile(completion: @escaping (String,String?) -> Void)
        {
        let url = "\(Constants.BaseURL)\(GambitChallengeEndpoints.getTextFile.rawValue)"

            Alamofire.request(url, method: .get, parameters: nil)
                .responseJSON { response in
                    //to get status code
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 200: //success
                            if let result = response.data {
                                let textFile = String(data: result, encoding: .utf8)
                                completion("success", textFile)
                            }
                            
                        case 404:
                            completion("Page not found.", nil)
                            
                        case -1009:
                            
                             completion("The Internet connection appears to be offline.", nil)
                            
                        default:
                            completion("Something went wrong. Please try again.",nil)
                        }
                    } else {
                        completion((response.error?.localizedDescription)!, nil)
                    }
            }
        }
}

enum GambitChallengeEndpoints: String
{
    case getTextFile             = "feed.txt"
}
