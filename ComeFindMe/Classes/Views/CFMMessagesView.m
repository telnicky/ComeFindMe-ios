//
//  CFMMessagesView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessagesView.h"

@implementation CFMMessagesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMessagesTable];
    }
    return self;
}

- (void)initMessagesTable
{
    self.messagesTable = [[UITableView alloc] init];
    [self.messagesTable setDelegate:self];
    [self addSubview:self.messagesTable];
}

- (void)layoutSubviews
{
    [self.messagesTable setFrame:self.bounds];
}

@end
