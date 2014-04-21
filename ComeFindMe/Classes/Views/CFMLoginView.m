//
//  CFMLoginView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/3/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMLoginView.h"

@implementation CFMLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor yellowColor]];
        self.loggedIn = false;

        [self setLoginView:[[FBLoginView alloc] init]];
        [self.loginView setDelegate:self];
        [self addSubview:self.loginView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setText:@"Come Find Me"];
        [self.nameLabel setAdjustsFontSizeToFitWidth:true];
        [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.nameLabel];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:self.spinner];

    }
    return self;
}

- (void)layoutSubviews
{
    CGRect frame = [self bounds];
    [self.spinner setFrame:frame];
    
    CGRect loginFrame = self.loginView.frame;
    loginFrame.origin.x = CGRectGetMidX(frame) - loginFrame.size.width * 0.5f;
    loginFrame.origin.y = CGRectGetMidY(frame) + loginFrame.size.height;
    
    [self.loginView setFrame:loginFrame];
    
    CGRect nameLabelFrame = CGRectMake(frame.origin.x + 50,
                                       frame.origin.y + 100,
                                       frame.size.width,
                                       30);
    [self.nameLabel setFrame:nameLabelFrame];
}

- (void)hideLoginView
{
    [self.loginView setFrame:CGRectMake(0, 0, 0, 0)];
    [self setNeedsDisplay];
}

#pragma mark FBLoginViewDelegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    if (!self.loggedIn) {
        self.loggedIn = true;
        [self.delegate loginView:self loggedInUser:user];
    }

}

@end
