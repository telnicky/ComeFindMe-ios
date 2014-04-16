//
//  CFMSelectLocationViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSelectLocationViewController.h"

@interface CFMSelectLocationViewController ()

@end

@implementation CFMSelectLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectLocationView = [[CFMSelectLocationView alloc] init];
        [self setTitle:@"Come Find Me"];
        [self.selectLocationView setDelegate:self];
        
        self.messagesButton = [[CFMMessagesButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.messagesButton.badge setCount:22];
        UIBarButtonItem* messages = [[UIBarButtonItem alloc] initWithCustomView:self.messagesButton];

        [self.navigationItem setRightBarButtonItems: @[ messages ]];
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
    [self setView:self.selectLocationView];
}

#pragma mark CFMSelectLocationViewController
- (void)selectFriendsPressedFromSelectLocationView:(CFMSelectLocationView *)selectLocation
{
    [self.delegate selectFriendsPressedFromSelectLocationViewController:self];
}

@end
