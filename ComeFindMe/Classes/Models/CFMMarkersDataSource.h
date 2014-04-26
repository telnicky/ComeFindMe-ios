//
//  CFMMarkersDataSource.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/24/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

#import "CFMColors.h"

@protocol CFMMarkersDataSourceDelegate <NSObject>

@end

@interface CFMMarkersDataSource : NSObject < UITableViewDataSource >

// Attributes
@property (nonatomic) NSMutableArray* markers;

// Delegates
@property (nonatomic, assign) id < CFMMarkersDataSourceDelegate > delegate;

// Instance Methods
- (void)turnOnMarker:(GMSMarker*)marker;
- (void)turnOffMarker:(GMSMarker*)marker;

@end
