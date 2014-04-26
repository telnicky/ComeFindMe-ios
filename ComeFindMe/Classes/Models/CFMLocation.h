//
//  CFMLocation.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "CFMBase.h"
#import "CFMRestService.h"

@class CFMLocation;

@protocol CFMLocationDelegate <NSObject>

- (void)saveSuccessfulForLocation:(CFMLocation*)location;
- (void)saveFailedForLocation:(CFMLocation*)location;

@end

@interface CFMLocation : NSObject < CFMBaseProtocol >

// Attributes
@property (nonatomic) NSNumber* id;
@property (nonatomic) NSString* error;

@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) NSString* description;
@property (nonatomic) NSNumber* userId;

// Delegates
@property (nonatomic) id < CFMLocationDelegate > delegate;

// Instance Methods
- (void)fromJson:(NSDictionary*)json;
- (NSString*)toJson;
- (void)save;

@end
