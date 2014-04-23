//
//  CFMSettingsView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class CFMSettingsView;

@protocol CFMSettingsViewDelegate <NSObject>

- (void) loggedOutUserFromSettingsView:(CFMSettingsView*)settingsView;

@end

@interface CFMSettingsView : UIView < FBLoginViewDelegate >
@property (nonatomic, assign) id< CFMSettingsViewDelegate > delegate;
@property (nonatomic) FBLoginView* logoutView;
@end
