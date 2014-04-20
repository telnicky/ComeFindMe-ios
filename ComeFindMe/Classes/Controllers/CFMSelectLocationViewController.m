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
        [self setTitle:@"Come Find Me"];
        
        [self initLocationView];
        [self initNavButtons];
    }
    return self;
}

- (void)initLocationView
{
    self.selectLocationView = [[CFMSelectLocationView alloc] init];
    [self.selectLocationView setDelegate:self];
}

- (void)initNavButtons
{
    [[CFMMessages instance] setDelegate:self];
    [[CFMMessages instance] loadData];
    self.messagesButton = [[CFMMessagesButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.messagesButton addTarget:self action:@selector(messagesButtonPressed) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem* messages = [[UIBarButtonItem alloc] initWithCustomView:self.messagesButton];
    
    [self.navigationItem setRightBarButtonItems: @[ messages ]];
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

- (void)messagesButtonPressed
{
    [self.delegate messagesPressedFromSelectLocationViewController:self];
}

#pragma mark CFMSelectLocationViewDelegate
- (void)selectFriendsPressedFromSelectLocationView:(CFMSelectLocationView *)selectLocation
{
    [self.delegate selectFriendsPressedFromSelectLocationViewController:self];
}

#pragma mark CFMMessagesDelegate
- (void)messagesDidLoad:(CFMMessages *)messages
{
    NSLog(@"count: %d", messages.count);
    [self.messagesButton.badge setCount:messages.count];

    // TODO: ask Matt about this not refreshing...
    [self.messagesButton setNeedsDisplay];
}

@end
