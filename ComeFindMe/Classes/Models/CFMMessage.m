//
//  CFMMessage.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/22/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessage.h"
#import "CFMRestService.h"
#import "CFMUser.h"

@implementation CFMMessage

- (id)init
{
    self = [super init];
    if (self) {
        self.receivers = [[NSMutableArray alloc] init];
        self.broadcasts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)create
{
    [[CFMRestService instance]
     createResource:@"messages"
     body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error) {
             NSLog(@"FATAL: Message#create - Create Failed");
             [self.delegate savefailedForMessage:self];
             return;
         }
         
         NSDictionary* messageJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         
         if (error) {
             NSLog(@"FATAL: Message#create - Parse Data Failed");
             [self.delegate savefailedForMessage:self];
             return;
         }
         
         // handle bad responses from server
         if ([messageJson objectForKey:@"error"]) {
             NSLog(@"FATAL: Message#create - Server Error");
             [self.delegate savefailedForMessage:self];
             return;
         }
         
         [self fromJson:messageJson];
         [self.delegate saveSuccessfulForMessage:self];
     }];
}

- (void)fromJson:(NSDictionary*)json
{
    // Set Attributes
    [self setId:[json objectForKey:@"id"]];
    [self setLocationId:[json objectForKey:@"location_id"]];
    [self setSenderId:[json objectForKey:@"sender_id"]];
    [self setUserId:[json objectForKey:@"user_id"]];
    [self setCreatedAt:[json objectForKey:@"created_at"]];
    [self setRead:[[json objectForKey:@"read"] boolValue]];
    
    // Set Relationships
    CFMLocation* location = [[CFMLocation alloc] init];
    [location fromJson:[json objectForKey:@"location"]];
    [self setLocation:location];
    

    for (NSDictionary* userJson in [json objectForKey:@"receivers"])
    {
        CFMUser* user = [[CFMUser alloc] init];
        [user fromJson:userJson];
        [self.receivers addObject:user];
        
        if ([[userJson objectForKey:@"id"] isEqualToValue:[json objectForKey:@"user_id"]])
        {
            user = [[CFMUser alloc] init];
            [user fromJson:userJson];
            [self setUser:user];
        }
    }
    
    
    CFMUser* sender = [[CFMUser alloc] init];
    [sender fromJson:[json objectForKey:@"sender"]];
    [self setSender:sender];
}

- (void)loadBroadcasts
{
    NSString* resource = [NSString stringWithFormat:@"messages/%@/broadcasts", self.id];
    [[CFMRestService instance]
     readResource:resource
     completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        [self loadBroadcastsFinishedWithResponse:response data:data error:error];
    }];
}

- (void)loadBroadcastsFinishedWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error
{
    if (error) {
        NSLog(@"FATAL: Broadcasts#loadMessagesFinishedWithResponse - Load Data Failed");
        [self.broadcastsDelegate failedToLoadBroadcastsForMessage:self];
        return;
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error) {
        NSLog(@"FATAL: Broadcasts#loadMessagesFinishedWithResponse - Parse Data Failed");
        [self.broadcastsDelegate failedToLoadBroadcastsForMessage:self];
        return;
    }
    
    // handle bad responses from server
    if ([json isKindOfClass:[NSMutableDictionary class]] && [json objectForKey:@"error"]) {
        NSLog(@"FATAL: Broadcasts#loadMessagesFinishedWithResponse - Server Error");
        [self.broadcastsDelegate failedToLoadBroadcastsForMessage:self];
        return;
    }
    
    // TODO: optimize syncing with server
    [self.broadcasts removeAllObjects];
    for (NSMutableDictionary* broadcastJson in json)
    {
        CFMBroadcast* broadcast = [[CFMBroadcast alloc] init];
        [broadcast fromJson:broadcastJson];
        [broadcast setDelegate:self];
        [self.broadcasts addObject:broadcast];
    }
    
    [self.broadcastsDelegate successfullyLoadedBroadcastsForMessage:self];
}

- (NSString*)toJson
{
    NSString* body = @"{";
    
    if (self.senderId) {
        NSString* senderIdJson = [NSString stringWithFormat:@"\"sender_id\": %@,", self.senderId];
        body = [body stringByAppendingString:senderIdJson];
    }
    
    if (self.locationId) {
        NSString* locationIdJson = [NSString stringWithFormat:@"\"location_id\": %@,", self.locationId];
        body = [body stringByAppendingString:locationIdJson];
    }
    
    if (self.read) {
        NSString* locationIdJson = [NSString stringWithFormat:@"\"read\": %s,", self.read ? "true" : "false"];
        body = [body stringByAppendingString:locationIdJson];
    }
    
    if (self.userId) {
        NSString* userIdJson = [NSString stringWithFormat:@"\"user_id\": \"%@\",", self.userId];
        body = [body stringByAppendingString:userIdJson];
    }
    else if (self.facebookId) {
        NSString* facebookIdJson = [NSString stringWithFormat:@"\"facebook_id\": \"%@\",", self.facebookId];
        body = [body stringByAppendingString:facebookIdJson];
    }
    
    if (![body isEqualToString:@"{"]) {
        // remove extra comma
        body = [body substringToIndex:[body length] - 1];
    }
    
    body = [body stringByAppendingString:@"}"];
    
    return body;
}

- (void)save
{
    if (self.id)
    {
        [self update];
    }
    else
    {
        [self create];
    }
}

- (void)setUserId:(NSNumber *)userId
{
    _userId = userId;
    // TODO: set User
}

- (void)setSenderId:(NSNumber *)senderId
{
    _senderId = senderId;
    // TODO: set Sender
}

- (void)update
{
    [[CFMRestService instance]
     updateResource:@"messages"
     guid:[self.id stringValue]
     body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:
     ^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error) {
             NSLog(@"FATAL: Message#update - Create Failed");
             [self.delegate savefailedForMessage:self];
             return;
         }
         
         NSDictionary* messageJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         
         if (error) {
             NSLog(@"FATAL: Message#update - Parse Data Failed");
             [self.delegate savefailedForMessage:self];
             return;
         }
         
         // handle bad responses from server
         if ([messageJson objectForKey:@"error"]) {
             NSLog(@"FATAL: Message#update - Server Error");
             [self.delegate savefailedForMessage:self];
             return;
         }
         
         [self fromJson:messageJson];
         [self.delegate saveSuccessfulForMessage:self];
     }];
}

#pragma mark CFMBroadcastDelegat
- (void)saveSuccessfulForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO: implement
}

- (void)saveFailedForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO: implement
}

- (void)destroySuccessfulForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO:
}

- (void)destroyFailedForBroadcast:(CFMBroadcast *)broadcast
{
    // TODO:
}

@end
