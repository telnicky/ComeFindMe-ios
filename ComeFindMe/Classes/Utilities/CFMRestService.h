//
//  CFMRestService.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/7/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFMRestService : NSObject < NSURLConnectionDataDelegate >
@property (nonatomic) NSString* baseUrl;

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
     completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;

- (void)destroyResource:(NSString*)resource
                   guid:(NSString*)guid
      completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))handler;
@end
