//
//  CFMLoginViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/12/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFMLoginView.h"

@class CFMLoginViewController;

@protocol CFMLoginViewControllerDelegate <NSObject>

- (void)loginViewController:(CFMLoginViewController*)viewController loggedInUser:(NSDictionary<FBGraphUser>*)user;

@end

@interface CFMLoginViewController : UIViewController < CFMLoginViewDelegate >
@property (nonatomic, assign) id< CFMLoginViewControllerDelegate > delegate;
@property (nonatomic) CFMLoginView* loginView;
@end
