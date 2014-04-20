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
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [self setDefaultHeadersForRequest:request];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];
    
    return true;
}

- (void)loginUser:(NSDictionary<FBGraphUser>*)user
{
    self.user = user;
    if (!self.user) {
        return;
    }
    
    NSString* accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString* requestBody = [NSString stringWithFormat:@"{\"facebook_id\": %@, \"facebook_access_token\": \"%@\"}\n", self.user.id, accessToken];
    
    [self createResource:@"sessions"
                    body:[requestBody dataUsingEncoding:NSUTF8StringEncoding]
       completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         if (error) {
             return;
         }
         
         id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         NSString* facebookId = [[jsonObject objectForKey:@"user"] objectForKey:@"facebook_id"];
         if ([facebookId isEqualToString:self.user.id])
         {
             [self.delegate restService:self successfullyLoggedInUser:self.user];
         }
         else
         {
             [self.delegate restService:self failedLoginWithError:error];
         }
     }];
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
    NSMutableURLRequest* request = [NSURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:handler];

    return true;
}

- (void)setDefaultHeaders
{
    NSString* accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSString* accessTokenCookie = [NSString stringWithFormat:@"facebook_access_token=%@; secure", accessToken];

    [self.headers addEntriesFromDictionary:@{
        @"Cookie": accessTokenCookie,
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
     completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler
{
    if ([self.baseUrl isEqualToString:@""]) {
        return false;
    }
    
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
