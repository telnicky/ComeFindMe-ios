//
//  CFMRestService.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/7/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMRestService.h"

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
        self.baseUrl = @"http://localhost:3000";
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

    NSLog(@"Request: %@", [request allHTTPHeaderFields]);
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
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];

    return true;
}

- (void)setDefaultHeaders
{
    NSString* accessToken = [[[FBSession activeSession] accessTokenData] accessToken];

    [self.headers addEntriesFromDictionary:@{
        @"facebook_access_token": accessToken,
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
    
    NSLog(@"Request: %@", [request allHTTPHeaderFields]);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
    return false;
}

- (void)destroyResource:(NSString*)resource
                   guid:(NSString*)guid
      completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([self.baseUrl isEqualToString:@""]) {
        return;
    }
}



@end
