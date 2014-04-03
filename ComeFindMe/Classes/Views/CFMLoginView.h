//
//  CFMLoginView.h
//  ComeFindMe
//
//  Created by travis elnicky on 4/3/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface CFMLoginView : UIView < FBLoginViewDelegate >
@property (nonatomic) UILabel* nameLabel;
@property (nonatomic) FBLoginView* loginView;
@end
