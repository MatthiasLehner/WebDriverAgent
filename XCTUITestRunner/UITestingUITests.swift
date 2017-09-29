//
//  UITestingUITestsSwift.swift
//  WebDriverAgentRunner
//
//  Created by Matthias Lehner on 28.09.17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import XCTest

class UITestingUITests: FBFailureProofTestCase {
  
  	static var swizzledOutIdle = false
  
		@objc func replace() { return }
        
    override func setUp() {
      
      if !UITestingUITests.swizzledOutIdle {
        let original = class_getInstanceMethod(objc_getClass("XCUIApplicationProcess") as? AnyClass, Selector(("waitForQuiescenceIncludingAnimationsIdle:")))
        let replaced = class_getInstanceMethod(type(of: self), #selector(UITestingUITests.replace))
        method_exchangeImplementations(original!, replaced!)
        UITestingUITests.swizzledOutIdle = true
      }
      
      super.setUp()
      
      continueAfterFailure = false
      
      UIApplication.shared.keyWindow?.layer.speed = 100
      
      //let app = XCUIApplication()
      //app.launchEnvironment = ["UITEST_DISABLE_ANIMATIONS" : "YES"]
      //app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRunner() {
			let webServer = FBWebServer()
      webServer.delegate = self
      webServer.startServing()
    }
    
}

extension UITestingUITests: FBWebServerDelegate {
  func webServerDidRequestShutdown(_ webServer: FBWebServer) {
    webServer.stopServing()
  }
}
