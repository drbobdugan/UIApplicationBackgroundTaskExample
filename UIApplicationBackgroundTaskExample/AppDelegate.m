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
         [application endBackgroundTask:self.bgTask];
         self.bgTask = UIBackgroundTaskInvalid;
        
         NSLog(@"%s: background task is expiring.", __PRETTY_FUNCTION__);
         [BackgroundTimeRemainingUtility NSLog];
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"%s: background task is starting.", __PRETTY_FUNCTION__);
        [BackgroundTimeRemainingUtility NSLog];
        
        self.primes = calloc(MAX_NUMBER, sizeof(int));
        [self sievePrimes];
        [self printPrimes];
        
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
    
    //self.backgroundCompletionHandler = completionHandler;
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [BackgroundTimeRemainingUtility NSLog];
}

// Modified from: http://forum.codecall.net/topic/64845-finding-primes-faster-sieve-of-eratosthenes

-(void) sievePrimes
{
    for (int i=2; i<MAX_NUMBER; i++) // for all elements in array
    {
        if(self.primes[i] == 0) // it is not multiple of any other prime
            self.primes[i] = 1; // mark it as prime
        
        // mark all multiples of prime selected above as non primes
        int nextMultiple=2;
        int multipleOfPrimeCandidate = i * nextMultiple;
        while (multipleOfPrimeCandidate < MAX_NUMBER)
        {
            self.primes[multipleOfPrimeCandidate] = -1;
            nextMultiple++;
            multipleOfPrimeCandidate = i*nextMultiple;
        }
        
        if ((i%1000)==0)
        {
            printf("%.3fs ",BackgroundTimeRemainingUtility.backgroundTimeRemainingDouble);
        }
    }
    printf("\n");
}

- (void) printPrimes
{
    int nth = 0;
    for(int i=0; i<MAX_NUMBER; i++)
    {
        if(self.primes[i] == 1)
        {
            nth++;
            switch(nth){
                case 1:  printf("%i st",nth);  break;
                case 2:  printf("%i nd",nth);  break;
                case 3:  printf("%i rd",nth);  break;
                default: printf("%i nth",nth); break;
            }
            printf(" prime is %i\n",i);
        }
    }
}
@end