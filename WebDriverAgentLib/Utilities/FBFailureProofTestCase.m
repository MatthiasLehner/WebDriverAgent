/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBFailureProofTestCase.h"

#import "FBExceptionHandler.h"
#import "FBLogger.h"
#import "FBXCTestCaseImplementationFailureHoldingProxy.h"

#import <objc/runtime.h>

@interface FBFailureProofTestCase ()
@property (nonatomic, assign) BOOL didRegisterAXTestFailure;
@end

@implementation FBFailureProofTestCase

- (void) waitForQuiescenceIncludingAnimationsIdle { return; }

- (void)setUp
{
  
  //static dispatch_once_t onceToken;
  
  //dispatch_once(&onceToken, ^{
    /*
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
  
  */
  
  [super setUp];
  
  self.continueAfterFailure = YES;
  self.internalImplementation = (_XCTestCaseImplementation *)[FBXCTestCaseImplementationFailureHoldingProxy proxyWithXCTestCaseImplementation:self.internalImplementation];
  
  [UIView setAnimationsEnabled: false];
  
  //XCUIApplication *application = [[XCUIApplication alloc] init];
  //application.launchEnvironment = [NSDictionary dictionaryWithObjectsAndKeys: @"YES", @"UITEST_DISABLE_ANIMATIONS", nil];
  //[application launch];
}

- (void)recordFailureWithDescription:(NSString *)description
                              inFile:(NSString *)filePath
                              atLine:(NSUInteger)lineNumber
                            expected:(BOOL)expected
{
  [self _enqueueFailureWithDescription:description inFile:filePath atLine:lineNumber expected:expected];
}

/**
 Private XCTestCase method used to block and tunnel failure messages
 */
- (void)_enqueueFailureWithDescription:(NSString *)description
                                inFile:(NSString *)filePath
                                atLine:(NSUInteger)lineNumber
                              expected:(BOOL)expected
{
  [FBLogger logFmt:@"Enqueue Failure: %@ %@ %lu %d", description, filePath, (unsigned long)lineNumber, expected];
  const BOOL isPossibleDeadlock = ([description rangeOfString:@"Failed to get refreshed snapshot"].location != NSNotFound);
  if (!isPossibleDeadlock) {
    self.didRegisterAXTestFailure = YES;
  }
  else if (self.didRegisterAXTestFailure) {
    self.didRegisterAXTestFailure = NO; // Reseting to NO to enable future deadlock detection
    [[NSException exceptionWithName:FBApplicationDeadlockDetectedException
                             reason:@"Can't communicate with deadlocked application"
                           userInfo:nil]
     raise];
  }
}

@end
