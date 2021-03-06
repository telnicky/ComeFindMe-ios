//
//  CFMLocation.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMLocation.h"
#import "CFMUser.h"

@implementation CFMLocation

- (id)init
{
    self = [super init];
    if (self) {
        self.broadcasts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)fromJson:(NSDictionary*)json
{
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(0, 0);
    coordinates.latitude = [[json objectForKey:@"latitude"] floatValue];
    coordinates.longitude = [[json objectForKey:@"longitude"] floatValue];

    [self setCoordinates:coordinates];
    [self setDescription:[json objectForKey:@"description"]];
    [self setUserId:[json objectForKey:@"user_id"]];
    [self setId:[json objectForKey:@"id"]];
}

- (void)create
{
    [[CFMRestService instance] createResource:@"locations" body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]  completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         BOOL isValid = [[CFMRestService instance] parseObject:self
                                                      response:response
                                                          data:data
                                                      loadData:true
                                                         error:error];
         if (isValid)
         {
             [self.delegate saveSuccessfulForLocation:self];
             return;
         }
         
         NSLog(@"FATAL: Location#create - %@", self.error);
         [self.delegate saveFailedForLocation:self];
     }];
}

- (void)loadBroadcasts
{
    NSString* resource = [NSString stringWithFormat:@"locations/%@/broadcasts", self.id];
    [[CFMRestService instance]
     readResource:resource
     completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
         [self loadBroadcastsFinishedWithResponse:response data:data error:error];
     }];
}

- (void)loadBroadcastsFinishedWithResponse:(NSURLResponse*)response data:(NSData*)data error:(NSError*)error
{
    BOOL isValid = [[CFMRestService instance]
                    parseCollection:self.broadcasts
                    object:self
                    className:@"Broadcast"
                    response:response
                    data:data
                    error:error];
    
    if (isValid)
    {
        [self.broadcastsDelegate successfullyLoadedBroadcastsForLocation:self];
        return;
    }
    
    NSLog(@"FATAL: User#loadBroadcastsFinishedWithResponse - %@", self.error);
    [self.broadcastsDelegate failedToLoadBroadcastsForLocation:self];
}

- (void)update
{
    [[CFMRestService instance]
     updateResource:@"locations"
     guid:[self.id stringValue]
     body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         BOOL isValid = [[CFMRestService instance] parseObject:self
                                                      response:response
                                                          data:data
                                                      loadData:false
                                                         error:error];
         if (isValid)
         {
             [self.delegate saveSuccessfulForLocation:self];
             return;
         }
         
         NSLog(@"FATAL: Location#update - %@", self.error);
         [self.delegate saveFailedForLocation:self];
     }];
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

- (NSString*)toJson
{
    NSString* body = @"{";

    if (self.description) {
        NSString* descriptionJson = [NSString stringWithFormat:@"\"description\": \"%@\",", self.description];
        body = [body stringByAppendingString:descriptionJson];
    }
    
    if (self.coordinates.latitude) {
        NSString* latitudeJson = [NSString stringWithFormat:@"\"latitude\": %f,", self.coordinates.latitude];
        body = [body stringByAppendingString:latitudeJson];
    }

    if (self.coordinates.longitude) {
        NSString* longitudeJson = [NSString stringWithFormat:@"\"longitude\": %f,", self.coordinates.longitude];
        body = [body stringByAppendingString:longitudeJson];
    }
    
    if (self.userId) {
        NSString* userIdJson = [NSString stringWithFormat:@"\"user_id\": %@,", self.userId];
        body = [body stringByAppendingString:userIdJson];
    }

    if (![body isEqualToString:@"{"]) {
        // remove extra comma
        body = [body substringToIndex:[body length] - 1];
    }

    body = [body stringByAppendingString:@"}"];
    
    return body;
}

@end
