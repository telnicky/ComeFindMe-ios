//
//  CFMReceiveRequestViewController.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/20/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMReceiveRequestViewController.h"

@interface CFMReceiveRequestViewController ()

@end

@implementation CFMReceiveRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initRequestView];
    }
    return self;
}

- (void)initRequestView
{
    self.receiveRequestView = [[CFMReceiveRequestView alloc] init];
}

- (void)loadView
{
    [self setView:self.receiveRequestView];
}

- (void)setMessage:(NSDictionary *)message
{
    _message = message;
    NSDictionary* location = [message objectForKey:@"location"];
    [self.receiveRequestView setLongitude:[[location objectForKey:@"longitude"] floatValue]];
    [self.receiveRequestView setLatitude:[[location objectForKey:@"latitude"] floatValue]];
    
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

@end
