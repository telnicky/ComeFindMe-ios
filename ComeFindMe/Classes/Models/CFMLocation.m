//
//  CFMLocation.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/21/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMLocation.h"

@implementation CFMLocation

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

- (void)create
{
    [[CFMRestService instance] createResource:@"locations" body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]  completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error) {
             // TODO: handle unsuccessful save
             return;
         }
         
         id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         
         if (error) {
             // TODO: handle unsuccessful save
             return;
         }
         
         [self setId:[jsonObject objectForKey:@"id"]];
         [self.delegate saveSuccessfulForLocation:self];
     }];
}

- (void)update
{
    [[CFMRestService instance]
     updateResource:@"locations"
     guid:self.id
     body:[[self toJson] dataUsingEncoding:NSUTF8StringEncoding]
     completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error) {
             // TODO: handle unsuccessful save
             return;
         }
         
         [self.delegate saveSuccessfulForLocation:self];
     }];
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
