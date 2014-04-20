//
//  CFMMessagesViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/19/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMessagesViewController.h"

@interface CFMMessagesViewController ()

@end

// TODO:
// Paging idea
// request paginated messages
// return a list of url's that will return paginated records

// TODO:
// refresh the messages list on pull-down

@implementation CFMMessagesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Come Find Me"];
        self.messages = [CFMMessages instance];
        self.messagesView = [[CFMMessagesView alloc] init];
        [self.messagesView.messagesTable setDataSource:self.messages];
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
    [self setView:self.messagesView];
}


@end
