//
//  CFMRestService.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/7/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "CFMBase.h"

@class CFMRestService;

@protocol CFMRestServiceDelegate <NSObject>

- (void)restService:(CFMRestService*)service successfullyLoggedInUser:(NSDictionary<FBGraphUser>*)user;
- (void)restService:(CFMRestService*)service failedLoginWithError:(NSError*)error;

@end

@interface CFMRestService : NSObject
@property (nonatomic, assign) id < CFMRestServiceDelegate > delegate;
@property (nonatomic) NSString* baseUrl;
@property (nonatomic) NSMutableDictionary* headers;

+ (CFMRestService*)instance;
- (id)init;

- (BOOL)createResource:(NSString*)resource
                  body:(NSData*)body
     completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

- (BOOL)readResource:(NSString*)resource
   completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

- (BOOL)readResource:(NSString*)resource
                guid:(NSString*)guid
   completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

- (BOOL)updateResource:(NSString*)resource
                  guid:(NSString*)guid
                  body:(NSData*)body
     completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

- (void)destroyResource:(NSString*)resource
                   guid:(NSString*)guid
      completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

- (BOOL)parseObject:(id< CFMBaseProtocol >)object
           response:(NSURLResponse*)response
               data:(NSData*)data
              error:(NSError*)error;

- (BOOL)parseCollection:(NSMutableArray*)objects
                 object:(id< CFMBaseProtocol >)object
              className:(NSString*)className
               response:(NSURLResponse*)response
                   data:(NSData*)data
                  error:(NSError*)error;

@end
