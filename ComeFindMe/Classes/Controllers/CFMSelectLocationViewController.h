//
//  CFMSelectLocationViewController.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFMSelectLocationView.h"
#import "CFMMessagesButton.h"

@class CFMSelectLocationViewController;

@protocol CFMSelectLocationViewControllerDelegate <NSObject>

- (void)selectFriendsPressedFromSelectLocationViewController:(CFMSelectLocationViewController*)selectLocationViewController;

@end

@interface CFMSelectLocationViewController : UIViewController< CFMSelectLocationViewDelegate >
@property (nonatomic, assign) id< CFMSelectLocationViewControllerDelegate > delegate;
@property (nonatomic) CFMSelectLocationView* selectLocationView;
@property (nonatomic) CFMMessagesButton* messagesButton;
@end
