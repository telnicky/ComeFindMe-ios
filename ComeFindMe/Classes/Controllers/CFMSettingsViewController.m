//
//  CFMSettingsViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSettingsViewController.h"

@interface CFMSettingsViewController ()

@end

@implementation CFMSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.settingsView = [[CFMSettingsView alloc] init];
        [self.settingsView setDelegate:self];
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
    [self setView:self.settingsView];
}

#pragma mark CFMSettingsViewDelegate
- (void)loggedOutUserFromSettingsView:(CFMSettingsView *)settingsView
{
    [self.delegate loggedOutUserFromSettingsViewController:self];
}

@end
