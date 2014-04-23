//
//  CFMLocation.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#import "CFMRestService.h"

@class CFMLocation;

@protocol CFMLocationDelegate <NSObject>

- (void)saveSuccessfulForLocation:(CFMLocation*)location;

@end

@interface CFMLocation : NSObject

// Attributes
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) NSString* description;
@property (nonatomic) NSNumber* userId;
@property (nonatomic) NSNumber* id;

// Delegates
@property (nonatomic) id < CFMLocationDelegate > delegate;

// Instance Methods
- (void)fromJson:(NSDictionary*)json;
- (NSString*)toJson;
- (void)save;

@end
