//
//  CFMSentRequestView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class CFMSentRequestView;

@protocol CFMSentRequestViewDelegate <NSObject>

- (void)sentRequestView:(CFMSentRequestView*)sentRequestView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface CFMSentRequestView : UIView < GMSMapViewDelegate, UITableViewDelegate >

// Delegates
@property (nonatomic, assign) id < CFMSentRequestViewDelegate > delegate;

// Views
@property (nonatomic) GMSMapView* mapView;
@property (nonatomic) UITableView* friendsTable;

// Attributes
@property (nonatomic) GMSMarker* destinationMarker;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) NSMutableArray* markers;
@property (nonatomic) GMSCameraPosition* camera;

// Instance Methods
- (void)setCameraCoordinates:(CLLocationCoordinate2D)coordinates;
- (void)turnOffMarker:(GMSMarker*)marker;
- (void)turnOnMarker:(GMSMarker*)marker;
- (void)layoutMarkers;
@end
