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

- (id)init
{
    self = [super init];
    if (self) {
        self.baseUrl = @"https://www.elnicky.com";
    }

    return self;
}

+ (CFMRestService*)instance
{
    return instance;
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
    NSMutableURLRequest* request = [NSURLRequest requestWithURL:url];
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
    NSMutableURLRequest* request = [NSURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
    
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
