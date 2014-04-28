//
//  CFMSentRequestViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>

#import "CFMColors.h"
#import "CFMSentRequestView.h"
#import "CFMUser.h"
#import "CFMMarkersDataSource.h"

@interface CFMSentRequestViewController : UIViewController < CFMLocationBroadcastsDelegate, CFMSentRequestViewDelegate >

// Attributes
@property (nonatomic) CFMMessage* message;
@property (nonatomic) NSMutableDictionary* markerDictionary;
@property (nonatomic) CFMMarkersDataSource* markersDataSource;
@property (nonatomic) CFMUser* user;

// Views
@property (nonatomic) CFMSentRequestView* sentRequestView;

@end
