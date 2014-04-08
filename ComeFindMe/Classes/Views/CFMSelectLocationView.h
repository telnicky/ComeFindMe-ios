//
//  CFMSelectLocationView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/4/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CFMSelectLocationView : UIView< CLLocationManagerDelegate, GMSMapViewDelegate, UITextViewDelegate >
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) GMSMapView* mapView;
@property (nonatomic) UITextView* descriptionView;
@property (nonatomic) UIButton* selectFriendsButton;
@end