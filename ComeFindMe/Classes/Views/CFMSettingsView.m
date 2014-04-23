//
//  CFMSettingsView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSettingsView.h"

@implementation CFMSettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.logoutView = [[FBLoginView alloc] init];
        [self addSubview:self.logoutView];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.logoutView setFrame:self.bounds];
}

#pragma mark FBLoginViewDelegate
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self.delegate loggedOutUserFromSettingsView:self];
}

@end
