//
//  CFMMessagesButton.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/14/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessagesButton.h"

@implementation CFMMessagesButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"103-map"] forState:UIControlStateNormal];
        
        self.badge = [[CFMBadgeView alloc] init];
        [self addSubview:self.badge];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect badgeFrame = CGRectMake(0, 0, 15, 15);
    [self.badge setFrame:badgeFrame];

}

@end
