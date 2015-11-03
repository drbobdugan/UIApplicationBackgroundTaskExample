//
//  AppDelegate.h
//  UIApplicationBackgroundTaskExample
//
//  Created by Bob Dugan on 11/3/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundTimeRemainingUtility.h"
const int MAX_NUMBER=110000000;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UIBackgroundTaskIdentifier bgTask;
@property int *primes;

- (void) printPrimes;
- (void) sievePrimes;


@end

