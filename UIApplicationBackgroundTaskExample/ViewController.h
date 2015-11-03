//
//  ViewController.h
//  UIApplicationBackgroundTaskExample
//
//  Created by Bob Dugan on 11/3/15.
//  Copyright © 2015 Bob Dugan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// State information
@property (nonatomic, weak) NSURLSession *session;
@property (nonatomic, strong) NSDate *startTime;

// Linked to UI components
@property (weak, nonatomic) IBOutlet UITextField *domainIP;
@property (weak, nonatomic) IBOutlet UILabel *completePercentage;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *time;
- (IBAction)buttonPressed:(id)sender;

@end

