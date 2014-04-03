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

        [self setLoginView:[[FBLoginView alloc] init]];
        
        CGRect loginFrame = self.loginView.frame;
        loginFrame.origin.x = CGRectGetMidX(frame) - loginFrame.size.width * 0.5f;
        loginFrame.origin.y = CGRectGetMidY(frame) + loginFrame.size.height;
        
        [self.loginView setFrame:loginFrame];
        [self.loginView setDelegate:self];
        [self addSubview:self.loginView];
        
        self.nameLabel = [[UILabel alloc] init];
        CGRect nameLabelFrame = CGRectMake(frame.origin.x + 50,
                                      frame.origin.y + 100,
                                      frame.size.width,
                                      30);
        [self.nameLabel setFrame:nameLabelFrame];
        [self.nameLabel setText:@"Not Yet.."];
        [self.nameLabel setAdjustsFontSizeToFitWidth:true];
        [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.nameLabel];
        

    }
    return self;
}

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    self.nameLabel.text = user.name;
}

@end
