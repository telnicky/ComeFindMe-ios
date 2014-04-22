//
//  CFMReceiveRequestView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/6/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@class CFMReceiveRequestView;

@protocol CFMReceiveRequestViewDelegate <NSObject>

- (void)didTapMapViewOnReceiveRequestView:(CFMReceiveRequestView*)receiveRequestView;

@end

@interface CFMReceiveRequestView : UIView< CLLocationManagerDelegate, GMSMapViewDelegate, UITextViewDelegate >
@property (nonatomic, assign) id < CFMReceiveRequestViewDelegate     > delegate;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString* description;
@property (nonatomic) GMSMapView* mapView;
@property (nonatomic) UITextView* descriptionView;
@property (nonatomic) UIButton* onMayWayButton;
@end
