/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import <WebDriverAgentLib/FBDebugLogDelegateDecorator.h>
#import <WebDriverAgentLib/FBConfiguration.h>
#import <WebDriverAgentLib/FBFailureProofTestCase.h>
#import <WebDriverAgentLib/FBWebServer.h>
#import <WebDriverAgentLib/XCTestCase.h>

#import <objc/runtime.h>

@interface UITestingUITests : FBFailureProofTestCase <FBWebServerDelegate>
@end

@implementation UITestingUITests

- (void) waitForQuiescenceIncludingAnimationsIdle { return; }
+ (void)setUp
{
  /*
  Class originalClass = objc_getClass("XCUIApplicationProcess");
  Class swizzledClass = [self class];
  
  SEL originalSelector = NSSelectorFromString(@"waitForQuiescenceIncludingAnimationsIdle");
  SEL swizzledSelector = NSSelectorFromString(@"waitForQuiescenceIncludingAnimationsIdle");
  
  Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
  
  BOOL didAddMethod =
  class_addMethod(originalClass,
                  originalSelector,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(originalClass,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
  
  [FBDebugLogDelegateDecorator decorateXCTestLogger];
  [FBConfiguration disableRemoteQueryEvaluation];
  [super setUp];
  
  //XCUIApplication *application = [[XCUIApplication alloc] init];
  //application.launchEnvironment = [NSDictionary dictionaryWithObjectsAndKeys: @"YES", @"UITEST_DISABLE_ANIMATIONS", nil];
  //[application launch];
   */
}

/*
- (void)setUp
{
  
  //static dispatch_once_t onceToken;
  
  //dispatch_once(&onceToken, ^{
  
  Class originalClass = objc_getClass("XCUIApplicationProcess");
  Class swizzledClass = [self class];
  
  SEL originalSelector = @selector(waitForQuiescenceIncludingAnimationsIdle);
  SEL swizzledSelector = @selector(waitForQuiescenceIncludingAnimationsIdle);
  
  Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
  Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
  
  BOOL didAddMethod =
  class_addMethod(originalClass,
                  originalSelector,
                  method_getImplementation(swizzledMethod),
                  method_getTypeEncoding(swizzledMethod));
  
  if (didAddMethod) {
    class_replaceMethod(originalClass,
                        swizzledSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
  } else {
    method_exchangeImplementations(originalMethod, swizzledMethod);
  }
  //});
  
  [super setUp];
  
  self.continueAfterFailure = YES;
  self.internalImplementation = (_XCTestCaseImplementation *)[FBXCTestCaseImplementationFailureHoldingProxy proxyWithXCTestCaseImplementation:self.internalImplementation];
  
  [UIView setAnimationsEnabled: false];
  
  //XCUIApplication *application = [[XCUIApplication alloc] init];
  //application.launchEnvironment = [NSDictionary dictionaryWithObjectsAndKeys: @"YES", @"UITEST_DISABLE_ANIMATIONS", nil];
  //[application launch];
}
*/


/**
 Never ending test used to start WebDriverAgent
 */
- (void)testRunner
{
  FBWebServer *webServer = [[FBWebServer alloc] init];
  webServer.delegate = self;
  [webServer startServing];
}

#pragma mark - FBWebServerDelegate

- (void)webServerDidRequestShutdown:(FBWebServer *)webServer
{
  [webServer stopServing];
}

@end
