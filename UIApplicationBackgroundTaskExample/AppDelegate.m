//
//  AppDelegate.m
//  UIApplicationBackgroundTaskExample
//
//  Created by Bob Dugan on 11/3/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
     self.bgTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
         // Clean up any unfinished task business by marking where you
         // stopped or ending the task outright.
         [BackgroundTimeRemainingUtility NSLog];
         
         [application endBackgroundTask:self.bgTask];
         self.bgTask = UIBackgroundTaskInvalid;
         NSLog(@"%s: background task is expiring.", __PRETTY_FUNCTION__);
         fflush(stderr);
         
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%s: background task is starting.", __PRETTY_FUNCTION__);
        [BackgroundTimeRemainingUtility NSLog];
        
        // This is a basic computational task that runs forever deliberately to trigger execution of the expiration handler.
        [self sievePrimes];
        
        NSLog(@"%s: background task is ending.", __PRETTY_FUNCTION__);
        [BackgroundTimeRemainingUtility NSLog];
        [application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
// Delegate for UIApplicationDelegate
//
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
    // Called when application moves from foreground to background and we are downloading a resource
    completionHandler:(void (^)()) completionHandler {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [BackgroundTimeRemainingUtility NSLog];
}


// Maximum number to process for primes
// Current value does not generate memory warning on iOS 8.4
const int MAX_NUMBER=130000000;
typedef enum {UNINITIALIZED=0, PRIME, NONPRIME} PrimeClassification;

//
// Objective-C friendly and cleaned up version of prime number calculator using the
// Sieve of Eratosthenes from:
// http://forum.codecall.net/topic/64845-finding-primes-faster-sieve-of-eratosthenes
//
// Returns an array of enums, where array[i] indicates that the number i is NONPRIME or
// PRIME
//
// This is a basic sieve implementation, some easy algorithmic improvements would be:
// - using bit per number
// - ignoring even numbers
// however these would reduce clarity.
//
-(PrimeClassification *) sievePrimes
{
    // Create numbers array, default value will be UNINITIALIZED (or zero)
    PrimeClassification *numbers = calloc(MAX_NUMBER, sizeof(PrimeClassification));
    
    while (true) {
    // Special cases
    numbers[0]=NONPRIME;
    numbers[1]=NONPRIME;
    
    // Iterate through numbers array identifying PRIMEs
    for (int i=2; i<MAX_NUMBER; i++)
    {
        // Encountering UNITIALIZED here means that the number must be PRIME.
        if (numbers[i] == UNINITIALIZED) numbers[i] = PRIME;
     
        // Mark multiples of current number NONPRIME
        int nextMultiple=2;
        int multipleOfPrimeCandidate = i * nextMultiple;
        while (multipleOfPrimeCandidate < MAX_NUMBER)
        {
            numbers[multipleOfPrimeCandidate] = NONPRIME;
            nextMultiple++;
            multipleOfPrimeCandidate = i*nextMultiple;
        }
        
        // Feedback during processing... it's fun to watch this accelerate during algorithm
        if ((i%10000)==0) printf(".");
    }}
    
    return numbers;
}
@end