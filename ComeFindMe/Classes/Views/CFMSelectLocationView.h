//
//  CFMSelectLocationView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/4/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class CFMSelectLocationView;

@protocol CFMSelectLocationViewDelegate <NSObject>
- (void)selectFriendsPressedFromSelectLocationView:(CFMSelectLocationView*)selectLocation;
@end

@interface CFMSelectLocationView : UIView< CLLocationManagerDelegate, GMSMapViewDelegate, UITextViewDelegate >

// Attributes
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

// Views
@property (nonatomic) GMSMapView* mapView;
@property (nonatomic) UITextView* descriptionView;
@property (nonatomic) UIButton* selectFriendsButton;
@property (nonatomic) UIImageView* marker;

// Delegates
@property (nonatomic, assign) id< CFMSelectLocationViewDelegate > delegate;

// Instance Methods
- (NSString*)locationDescription;
- (CLLocationCoordinate2D)markerPosition;
- (void)moveCameraToLocation:(CLLocation*)location;

@end
