//
//  CFMSelectFriendsView.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/13/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMSelectFriendsView.h"

@implementation CFMSelectFriendsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initFriendsTable];
        [self initSendButton];
    }
    return self;
}

- (void)initFriendsTable
{
    self.friendsTable = [[UITableView alloc] init];
    [self.friendsTable setAllowsMultipleSelection:true];
    [self.friendsTable setDelegate:self];
    [self addSubview:self.friendsTable];
}

- (void)initSendButton
{
    self.sendButton = [[UIButton alloc] init];
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    self.sendButton.titleLabel.textColor = [UIColor blackColor];
    self.sendButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.sendButton.layer.borderWidth = 2.0f;
    self.sendButton.backgroundColor = [UIColor yellowColor];
    [self.sendButton addTarget:self action:@selector(onSendPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.sendButton];
}

- (void)layoutSubviews
{
    CGRect frame = self.bounds;
    CGRect upperFrame = CGRectZero;
    CGRect lowerFrame = CGRectZero;
    CGRect friendsTableFrame = CGRectZero;
    CGRect sendButtonFrame = CGRectZero;
    
    CGRectDivide(frame, &upperFrame, &lowerFrame, 2 * frame.size.height / 3.0f, CGRectMinYEdge);
    CGRectDivide(lowerFrame, &lowerFrame, &sendButtonFrame, lowerFrame.size.height * 0.5f, CGRectMinYEdge);
    
    friendsTableFrame = upperFrame;
    sendButtonFrame = CGRectInset(sendButtonFrame, sendButtonFrame.size.width / 5.0f, 10.0f);
    
    [self.friendsTable setFrame:upperFrame];
    [self.sendButton setFrame:sendButtonFrame];
}

- (void) onSendPressed
{
    NSLog(@"Send!!");
    [self.delegate sendButtonPressedOnSelecFriendsView:self];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}


@end
