//
//  CFMLoginView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/3/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class CFMLoginView;

@protocol CFMLoginViewDelegate <NSObject>

- (void) loginView:(CFMLoginView*)loginView loggedInUser:(id< FBGraphUser >)user;

@end

@interface CFMLoginView : UIView < FBLoginViewDelegate >
@property (nonatomic, assign) id< CFMLoginViewDelegate > delegate;
@property (nonatomic) UILabel* nameLabel;
@property (nonatomic) FBLoginView* loginView;
@property (nonatomic) UIActivityIndicatorView* spinner;
@property (nonatomic) bool loggedIn;
- (void)hideLoginView;
@end
