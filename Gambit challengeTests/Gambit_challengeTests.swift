//
//  Gambit_challengeTests.swift
//  Gambit challengeTests
//
//  Created by Hassan on 7.10.2020.
//

import XCTest
@testable import Gambit_challenge

class Gambit_challengeTests: XCTestCase {

    func testGetTextFile()
    {
        let expectedResult = readData(fileName: "feed")
        let expectatio = expectation(description: "GET \(Constants.BaseURL)\(GambitChallengeEndpoints.getTextFile.rawValue)")
        
        //Load texttfile from the server
        ServerManager.getTextFile { (status, data) in
            
            XCTAssertEqual(data, expectedResult)
            expectatio.fulfill()
            
        }
        self.waitForExpectations(timeout: 5) { (error) in
            print ("\(String(describing: error?.localizedDescription))")
        }
    }
    
    //Reading text File response
    func readData(fileName: String) -> String? {
        
        let path = Bundle.main.path(forResource: fileName, ofType: "txt")
        do {
            let textFile = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            return textFile
        }
        catch{
              print ("error in reading file")
        }
        return nil
    }

}
