//
//  CFMRestService.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/7/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMRestService.h"

#import "CFMBroadcast.h"
#import "CFMUser.h"
#import "CFMMessage.h"

@implementation CFMRestService
{
    NSURLConnection* _connection;
}

static CFMRestService* instance;
static BOOL initialized = false;

+ (void)initialize
{
    if (!initialized) {
        initialized = true;
        instance = [[CFMRestService alloc] init];
    }
}

+ (CFMRestService*)instance
{
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
//        self.baseUrl = @"http://192.168.0.12:3000";
        self.baseUrl = @"https://www.elnicky.com";
        self.headers = [[NSMutableDictionary alloc] init];
        [self setDefaultHeaders];
    }

    return self;
}


- (BOOL)createResource:(NSString*)resource
                  body:(NSData*)body
     completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([self.baseUrl isEqualToString:@""]) {
        return false;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/%@", self.baseUrl, resource];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    [self setDefaultHeadersForRequest:request];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
    
    return true;
}

- (BOOL)readResource:(NSString*)resource
   completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([self.baseUrl isEqualToString:@""]) {
        return false;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/%@", self.baseUrl, resource];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [self setDefaultHeadersForRequest:request];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
    
    return true;
}

- (BOOL)readResource:(NSString*)resource
                guid:(NSString*)guid
   completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([self.baseUrl isEqualToString:@""]) {
        return false;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/%@", self.baseUrl, resource, guid];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [self setDefaultHeadersForRequest:request];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];

    return true;
}

- (void)setDefaultHeaders
{
    NSString* accessToken = [[[FBSession activeSession] accessTokenData] accessToken];

    [self.headers addEntriesFromDictionary:@{
        @"AUTHORIZATION": accessToken,
        @"Accept": @"application/json",
        @"Content-Type": @"application/json"
     }];
}

- (void)setDefaultHeadersForRequest:(NSMutableURLRequest*)request
{
    for (id key in self.headers) {
        [request setValue:[self.headers objectForKey:key] forHTTPHeaderField:key];
    }
}

- (BOOL)updateResource:(NSString*)resource
                  guid:(NSString*)guid
                  body:(NSData*)body
     completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([self.baseUrl isEqualToString:@""]) {
        return false;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/%@", self.baseUrl, resource, guid];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    [self setDefaultHeadersForRequest:request];
    
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
    return true;
}

- (void)destroyResource:(NSString*)resource
                   guid:(NSString*)guid
      completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([self.baseUrl isEqualToString:@""]) {
        return;
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/%@/%@", self.baseUrl, resource, guid];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [NSMutableURLRequest
                                    requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [self setDefaultHeadersForRequest:request];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];

}

- (BOOL)parseObject:(id< CFMBaseProtocol >)object
           response:(NSURLResponse*)response
               data:(NSData*)data
           loadData:(BOOL)loadData
              error:(NSError*)error

{
    if (error) {
        NSLog(@"FATAL: CFMRestService#parseResponse - Load Data Failed");
        object.error = @"unable to connect to Come Find Me";
        return false;
    }
    
    id json = [NSJSONSerialization
               JSONObjectWithData:data
               options:NSJSONReadingMutableContainers
               error:&error];
    
    if (error) {
        NSLog(@"FATAL: CFMRestService#parseResponse - Parse Data Failed");
        object.error = @"unable to connect to Come Find Me";
        return false;
    }
    
    // handle bad responses from server
    if ([json isKindOfClass:[NSMutableArray class]] ||
        [json objectForKey:@"error"])
    {
        NSLog(@"FATAL: CFMRestService#parseResponse - Server Error");
        object.error = [json objectForKey:@"error"];
        return false;
    }
    
    if (loadData) {
        [object fromJson:json];
    }

    return true;
}

- (BOOL)parseCollection:(NSMutableArray*)objects
                 object:(id< CFMBaseProtocol >)object
              className:(NSString*)className
               response:(NSURLResponse*)response
                   data:(NSData*)data
                  error:(NSError*)error

{
    
    if (error) {
        NSLog(@"FATAL: CFMRestService#parseResponse - Load Data Failed");
        [object setError:@"unable to connect to Come Find Me"];
        return false;
    }
    
    id json = [NSJSONSerialization
               JSONObjectWithData:data
               options:NSJSONReadingMutableContainers
               error:&error];
    
    if (error) {
        NSLog(@"FATAL: CFMRestService#parseResponse - Parse Data Failed");
        object.error = @"unable to connect to Come Find Me";
        return false;
    }
    
    // handle bad responses from server
    if ([json isKindOfClass:[NSMutableDictionary class]]) {
        NSLog(@"FATAL: CFMRestService#parseResponse - Server Error");
        object.error = [json objectForKey:@"error"];
        return false;
    }
    
    // TODO: optimize syncing with server
    [objects removeAllObjects];
    for (NSMutableDictionary* objectJson in json)
    {
        id < CFMBaseProtocol > model;
        if ([className isEqualToString:@"Broadcast"])
        {
            model = [[CFMBroadcast alloc] init];
        }
        else if ([className isEqualToString:@"Message"])
        {
            model = [[CFMMessage alloc] init];
        }
        else if ([className isEqualToString:@"User"])
        {
            model = [[CFMUser alloc] init];
        }
        
        [model fromJson:objectJson];
        [objects addObject:model];
    }
    
    return true;
}



@end
