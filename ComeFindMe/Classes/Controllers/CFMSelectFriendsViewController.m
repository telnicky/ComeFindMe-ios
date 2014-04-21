//
//  CFMSelectFriendsViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSelectFriendsViewController.h"

@interface CFMSelectFriendsViewController ()

@end

@implementation CFMSelectFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Select Friends"];
        self.selectFriendsView = [[CFMSelectFriendsView alloc] init];
        [self.selectFriendsView.friendsTable setDataSource:[[CFMUser instance] friends]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [self setView:self.selectFriendsView];
}

#pragma mark CFMFriendsDelegate
- (void)friendsDidLoad:(CFMFriends *)friends
{
    [self.selectFriendsView setNeedsDisplay];
}

@end
