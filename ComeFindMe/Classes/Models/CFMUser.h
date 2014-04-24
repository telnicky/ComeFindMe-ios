//
//  CFMUser.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#import "CFMLocation.h"
#import "CFMMessage.h"
#import "CFMBroadcast.h"
#import "CFMRestService.h"

@class CFMUser;

@protocol CFMUserBroadcastsDelegate <NSObject>

- (void)successfullyLoadedBroadcastsForUser:(CFMUser*)user;
- (void)failedToLoadBroadcastsForUser:(CFMUser*)user;

@end

@protocol CFMUserMessagesDelegate <NSObject>

- (void)successfullyLoadedMessagesForUser:(CFMUser*)user;
- (void)failedToLoadMessagesForUser:(CFMUser*)user;

@end

@protocol CFMUserFriendsDelegate <NSObject>

- (void)successfullyLoadedFriendsForUser:(CFMUser*)user;
- (void)failedToLoadFriendsForUser:(CFMUser*)user;

@end

@protocol CFMUserDelegate <NSObject>

- (void)successfulLoginForUser:(CFMUser*)user;
- (void)failedLoginForUser:(CFMUser*)user;

- (void)successfulSyncForUser:(CFMUser*)user;
- (void)failedSyncForUser:(CFMUser*)user;

- (void)successfulSaveForUser:(CFMUser*)user;
- (void)failedSaveForUser:(CFMUser*)user;

@end

@interface CFMUser : NSObject < CFMMessageDelegate >

// Attributes
@property (nonatomic) NSNumber* id;
@property (nonatomic) NSString* firstName;
@property (nonatomic) NSString* lastName;
@property (nonatomic) NSString* facebookId;
@property (nonatomic) NSMutableDictionary* friendsDict;
@property (nonatomic) NSNumber* unreadMessagesCount;
@property (nonatomic) NSNumber* currentLocationId;

// Relationships
@property (nonatomic) NSMutableArray* friends;
@property (nonatomic) NSMutableArray* messages;
@property (nonatomic) NSMutableArray* broadcasts;
@property (nonatomic) CFMLocation* location;
@property (nonatomic) CFMLocation* currentLocation;

// Class Methods
+ (CFMUser*)currentUser;

// Instance Methods
- (void)fromFacebookJson:(NSDictionary<FBGraphUser>*)json;
- (void)fromJson:(NSDictionary*)json;
- (bool)isCurrentUser;
- (void)loadBroadcasts;
- (void)loadMessages;
- (void)loadFriends;
- (void)login;
- (void)save;
- (void)sync;
- (NSString*)toJson;

// Delegates
@property (nonatomic) id < CFMUserDelegate > delegate;
@property (nonatomic) id < CFMUserBroadcastsDelegate > broadcastsDelegate;
@property (nonatomic) id < CFMUserMessagesDelegate > messagesDelegate;
@property (nonatomic) id < CFMUserFriendsDelegate > friendsDelegate;

@end
