//
//  CFMReceiveRequestView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/6/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CFMColors.h"

@class CFMReceiveRequestView;

@protocol CFMReceiveRequestViewDelegate <NSObject>

- (void)didTapMapViewOnReceiveRequestView:(CFMReceiveRequestView*)receiveRequestView;

- (void)didSelectOnMyWayButtonForReceiveRequestView:(CFMReceiveRequestView*)receiverRequestView;

@end

@interface CFMReceiveRequestView : UIView< CLLocationManagerDelegate, GMSMapViewDelegate, UITextViewDelegate >

// Attributes
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString* description;
@property (nonatomic) bool isBroadcasting;

// Views
@property (nonatomic) GMSMapView* mapView;
@property (nonatomic) UITextView* descriptionView;
@property (nonatomic) UIButton* onMyWayButton;

// Delegates
@property (nonatomic, assign) id < CFMReceiveRequestViewDelegate > delegate;
@end
