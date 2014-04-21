//
//  CFMSentRequestView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface CFMSentRequestView : UIView < GMSMapViewDelegate >
@property (nonatomic) UIButton* friendsButton;
@property (nonatomic) GMSMapView* mapView;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) UITableView* friendsTable;
@end
