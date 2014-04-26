//
//  CFMBase.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/26/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CFMBaseProtocol <NSObject>

// Attributes
@property (nonatomic) NSNumber* id;
@property (nonatomic) NSString* error;

// Instance Methods
- (void)fromJson:(NSDictionary*)json;
- (void)save;
- (NSString*)toJson;

@end

