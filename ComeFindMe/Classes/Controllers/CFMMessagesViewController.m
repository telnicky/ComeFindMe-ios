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
        self.messagesView = [[CFMMessagesView alloc] init];
        [self.messagesView.messagesTable setDelegate:self];
        [self.messagesView.messagesTable setDataSource:[[CFMUser instance] messages]];
        
        UIImage* settingsImage = [UIImage imageNamed:@"glyphicons_070_umbrella"];
        UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithImage:settingsImage style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonPressed)];
        [self.navigationItem setRightBarButtonItem:settingsButton];
    }
    return self;
}

- (void)settingsButtonPressed
{
    [self.delegate settingsButtonPressedForMessagesViewController:self];
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

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* messages = [[CFMUser instance] messages].messages;
    NSDictionary* message = [[messages objectAtIndex:[indexPath row]] objectForKey:@"message"];
    if ([[message objectForKey:@"didSend"] boolValue])
    {
        [self.delegate messagesViewController:self didSelectSentMessage:message];
    }
    else
    {
        [self.delegate messagesViewController:self didSelectReceivedMessage:message];
    }
    
}


@end
