//
//  CFMReceiveRequestViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CFMColors.h"
#import "CFMReceiveRequestView.h"
#import "CFMUser.h"

@interface CFMReceiveRequestViewController : UIViewController <
CFMReceiveRequestViewDelegate,CFMMessageBroadcastsDelegate, CFMBroadcastDelegate >

// Attributes
@property (nonatomic) CFMMessage* message;
@property (nonatomic) CFMBroadcast* broadcast;

// Views
@property (nonatomic) CFMReceiveRequestView* receiveRequestView;

@end
