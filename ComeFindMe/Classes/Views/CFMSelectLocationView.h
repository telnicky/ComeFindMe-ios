//
//  CFMSelectLocationView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/4/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CFMSelectLocationView : UIView< GMSMapViewDelegate >
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) GMSMapView* mapView;
@end
