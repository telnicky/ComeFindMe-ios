//
//  CFMLoginViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/12/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMLoginViewController.h"

@implementation CFMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.loginView = [[CFMLoginView alloc] init];
        [self.loginView setDelegate:self];
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
    [self setView:self.loginView];
}

#pragma mark CFMLoginViewDelegate
- (void)loginView:(CFMLoginView *)loginView loggedInUser:(id<FBGraphUser>)user
{
    [self.delegate loginViewController:self loggedInUser:user];
}

@end
