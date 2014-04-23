//
//  CFMMessage.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/22/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFMLocation.h"

@class CFMMessage;
@class CFMUser;

@protocol CFMMessageDelegate <NSObject>

- (void)saveSuccessfulForMessage:(CFMMessage*)message;
- (void)savefailedForMessage:(CFMMessage*)message;

@end

@interface CFMMessage : NSObject
// relationships
@property (nonatomic) CFMUser* user;
@property (nonatomic) CFMUser* sender;
@property (nonatomic) CFMLocation* location;
@property (nonatomic) NSMutableArray* receivers;

// Attributes
@property (nonatomic) NSString* id;
@property (nonatomic) NSNumber* senderId;
@property (nonatomic) NSNumber* locationId;
@property (nonatomic) NSNumber* userId;
@property (nonatomic) NSString* createdAt;
@property (nonatomic) NSString* facebookId;
@property (nonatomic) bool read;

@property (nonatomic) id < CFMMessageDelegate > delegate;

// Instance Methods
- (void)fromJson:(NSDictionary*)json;
- (NSString*)toJson;
- (void)save;
@end
