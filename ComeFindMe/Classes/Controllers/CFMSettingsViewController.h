//
//  CFMSettingsViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CFMSettingsView.h"

@class CFMSettingsViewController;

@protocol CFMSettingsViewControllerDelegate <NSObject>

- (void)loggedOutUserFromSettingsViewController:(CFMSettingsViewController*)settingsViewController;

@end

@interface CFMSettingsViewController : UIViewController < CFMSettingsViewDelegate >
@property (nonatomic) id < CFMSettingsViewControllerDelegate > delegate;
@property (nonatomic) CFMSettingsView* settingsView;
@end
