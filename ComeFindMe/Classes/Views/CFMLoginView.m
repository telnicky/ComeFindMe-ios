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
        [self setBackgroundColor:UIColorFromRGB(MainColor1)];
        self.loggedIn = false;

        [self setLoginView:[[FBLoginView alloc] init]];
        [self.loginView setDelegate:self];
        [self addSubview:self.loginView];
        
        self.topNameLabel = [[UILabel alloc] init];
        [self.topNameLabel setText:@"Come Find\nMe"];
        [self.topNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.topNameLabel setNumberOfLines:0];
        [self.topNameLabel setAdjustsFontSizeToFitWidth:true];
        [self.topNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.topNameLabel setFont:[UIFont boldSystemFontOfSize:48]];
        [self addSubview:self.topNameLabel];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.spinner setColor:[UIColor darkGrayColor]];
        [self addSubview:self.spinner];

    }
    return self;
}

- (void)layoutSubviews
{
    CGRect frame = [self bounds];
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    CGRect loginFrame = self.loginView.frame;
    CGRect topNameLabelFrame = CGRectZero;
    CGRect spinnerFrame = CGRectZero;
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 2 * frame.size.height / 3.0f, CGRectMinYEdge);
    CGRectDivide(upperFrame, &topNameLabelFrame, &spinnerFrame, 2 * frame.size.height / 3.0f, CGRectMinYEdge);

    // login frame
    loginFrame.origin.x = CGRectGetMidX(frame) - loginFrame.size.width * 0.5f;
    loginFrame.origin.y = CGRectGetMidY(frame) + loginFrame.size.height;
    
    [self.loginView setFrame:loginFrame];
    [self.topNameLabel setFrame:topNameLabelFrame];
    [self.spinner setFrame:spinnerFrame];
}

- (void)hideLoginView
{
    [self.loginView setFrame:CGRectMake(0, 0, 0, 0)];
    [self setNeedsDisplay];
}

- (void)handleAuthError:(NSError *)error
{
    NSString *alertText;
    NSString *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error] == true){
        // Error requires people using you app to make an action outside your app to recover
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
        [self showMessage:alertText withTitle:alertTitle];
        
    } else {
        // You need to find more information to handle the error within your app
        if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            //The user refused to log in into your app, either ignore or...
            alertTitle = @"Login cancelled";
            alertText = @"You need to login to access this part of the app";
            [self showMessage:alertText withTitle:alertTitle];
            
        } else {
            // All other errors that can happen need retries
            // Show the user a generic error message
            alertTitle = @"Something went wrong";
            alertText = @"Please retry";
            [self showMessage:alertText withTitle:alertTitle];
        }
    }
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

#pragma mark FBLoginViewDelegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    if (!self.loggedIn) {
        self.loggedIn = true;
        [self.delegate loginView:self loggedInUser:user];
    }

}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error
{
    [self handleAuthError:error];
}

@end
