//
//  CFMReceiveRequestViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CFMReceiveRequestView.h"
#import "CFMUser.h"

@interface CFMReceiveRequestViewController : UIViewController <
CFMReceiveRequestViewDelegate >
@property (nonatomic) NSDictionary* message;
@property (nonatomic) CFMReceiveRequestView* receiveRequestView;
@end
