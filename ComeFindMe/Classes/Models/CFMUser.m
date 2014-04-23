//
//  CFMUser.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMUser.h"

@implementation CFMUser

static CFMUser* currentUser;
static BOOL initialized = false;

+ (CFMUser*)currentUser
{
    if (!initialized) {
        initialized = true;
        currentUser = [[CFMUser alloc] init];
    }
    return currentUser;
}

- (void)fromFacebookJson:(NSDictionary<FBGraphUser>*)json
{
    [self setFacebookId:json.id];
    [self setFirstName:json.first_name];
    [self setLastName:json.last_name];
}

- (void)fromJson:(NSDictionary *)json
{
    // Set Attributes
    [self setId:[json objectForKey:@"id"]];
    [self setFacebookId:[json objectForKey:@"facebook_id"]];
    [self setUnreadMessagesCount:[json objectForKey:@"unread_messages_count"]];

    if ([json objectForKey:@"first_name"]) {
        [self setFirstName:[json objectForKey:@"first_name"]];
    }
    
    if ([json objectForKey:@"last_name"]) {
        [self setLastName:[json objectForKey:@"last_name"]];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.friends = [[NSMutableArray alloc] init];
        self.friendsDict = [[NSMutableDictionary alloc] init];
        self.messages = [[NSMutableArray alloc] init];
        self.location = [[CFMLocation alloc] init];
    }
    
    return self;
}

- (bool)isCurrentUser
{
    return currentUser.id && currentUser.id == self.id;
}

- (void)loadFriends
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary* result,
       NSError *error)
     {
         if (error) {
             NSLog(@"FATAL: User#loadFriends - Load Data Failed");
             [self.friendsDelegate failedToLoadFriendsForUser:self];
             return;
         }
         
         NSArray* friends = [result objectForKey:@"data"];
         // TODO: optimize syncing friends
         [self.friends removeAllObjects];
         for (NSDictionary<FBGraphUser>* friendJson in friends) {
             CFMUser* friend = [[CFMUser alloc] init];
             [friend fromFacebookJson:friendJson];
             [self.friends addObject:friend];
             [self.friendsDict setValue:friend forKeyPath:friend.facebookId];
         }
         
         [self.friendsDelegate successfullyLoadedFriendsForUser:self];
     }];
}

- (void)login
{

    NSString* requestBody = [self sessionCreateBody];
    [[CFMRestService instance]
     createResource:@"sessions"
     body:[requestBody dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [self loginFinishedWithResponse:response data:data error:error];
     }];
}

- (void)loginFinishedWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error
{
    if (error) {
        NSLog(@"FATAL: User#loginFinishedWithResponse - Load Data Failed");
        [self.delegate failedLoginForUser:self];
        return;
    }
    
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:NSJSONReadingMutableContainers
                          error:&error];
    
    if (error) {
        NSLog(@"FATAL: User#loginFinishedWithResponse - Parse Data Failed");
        [self.delegate failedLoginForUser:self];
        return;
    }
    
    // handle bad responses from server
    if ([json objectForKey:@"error"]) {
        NSLog(@"FATAL: User#loginFinishedWithResponse - Server Error");
        [self.delegate failedLoginForUser:self];
        return;
    }
    
    [self fromJson:json];
    [self.delegate successfulLoginForUser:self];
}

- (void)loadMessages
{
    [[CFMRestService instance] readResource:@"messages" completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        [self loadMessagesFinishedWithResponse:response data:data error:error];
    }];
}

- (void)loadMessagesFinishedWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error
{
    if (error) {
        NSLog(@"FATAL: User#loadMessagesFinishedWithResponse - Load Data Failed");
        [self.messagesDelegate failedToLoadMessagesForUser:self];
        return;
    }
    
    id messagesJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"FATAL: User#loadMessagesFinishedWithResponse - Parse Data Failed");
        [self.messagesDelegate failedToLoadMessagesForUser:self];
        return;
    }
    
    // handle bad responses from server
    if ([messagesJson isKindOfClass:[NSMutableDictionary class]] && [messagesJson objectForKey:@"error"]) {
        NSLog(@"FATAL: User#loadMessagesFinishedWithResponse - Server Error");
        [self.messagesDelegate failedToLoadMessagesForUser:self];
        return;
    }
    
    // TODO: optimize syncing with server
    [self.messages removeAllObjects];
    for (NSMutableDictionary* messageJson in messagesJson)
    {
        CFMMessage* message = [[CFMMessage alloc] init];
        [message fromJson:messageJson];
        [message setDelegate:self];
        [self.messages addObject:message];
    }
    
    [self.messagesDelegate successfullyLoadedMessagesForUser:self];
}

- (NSString*)sessionCreateBody
{
    NSString* accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString* requestBody = [NSString stringWithFormat:@"{\"facebook_id\": \"%@\", \"facebook_access_token\": \"%@\"}\n", self.facebookId, accessToken];

    return requestBody;
}

- (void)sync
{
    [[CFMRestService instance]
     readResource:@"users"
     guid:[self.id stringValue]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error) {
         if (error) {
             NSLog(@"FATAL: User#sync - Load Data Failed");
             [self.delegate failedSyncForUser:self];
             return;
         }
         
         id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         
         if (error) {
             NSLog(@"FATAL: User#sync - Parse Data Failed");
             [self.delegate failedSyncForUser:self];
             return;
         }
         
         // handle bad responses from server
         if ([json isKindOfClass:[NSMutableDictionary class]] &&
             [json objectForKey:@"error"])
         {
             NSLog(@"FATAL: User#sync - Server Error");
             [self.delegate failedSyncForUser:self];
             return;
         }
         
         [self fromJson:json];
         
         [self.delegate successfulSyncForUser:self];
    }];
}

- (NSString*)toJson
{
    // TODO: implement
    return @"foo";
}

#pragma mark CFMMessageDelegate
- (void)saveSuccessfulForMessage:(CFMMessage *)message
{
    
}

- (void)savefailedForMessage:(CFMMessage *)message
{
    
}

@end
