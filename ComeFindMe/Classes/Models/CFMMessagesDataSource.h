//
//  CFMMessagesDataSource.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CFMMessage.h"

@class CFMMessagesDataSource;

@protocol CFMMessagesDataSourceDelegate <NSObject>

@end

@interface CFMMessagesDataSource : NSObject < UITableViewDataSource >

// Attributes
@property (nonatomic) NSMutableArray* messages;

@property (nonatomic, assign) id < CFMMessagesDataSourceDelegate > delegate;


@end