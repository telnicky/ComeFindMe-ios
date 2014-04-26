//
//  CFMMarkersDataSource.m
//  ComeFindMe
//
//  Created by travis elnicky on 4/24/14.
//  Copyright (c) 2014 Travis Elnicky. All rights reserved.
//

#import "CFMMarkersDataSource.h"

@implementation CFMMarkersDataSource

- (id)init
{
    self = [super init];
    if (self) {
        self.markers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)turnOnMarker:(GMSMarker*)marker
{
    [marker.userData setValue:@"true" forKey:@"isVisible"];
}

- (void)turnOffMarker:(GMSMarker*)marker
{
    [marker.userData setValue:@"false" forKey:@"isVisible"];
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.markers.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GMSMarker* marker = [self.markers objectAtIndex:[indexPath row]];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CFMMarkersDataSource class])];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:NSStringFromClass([CFMMarkersDataSource class])];
    }
    
    // image
    [cell.imageView setFrame:CGRectMake(0, 0, 20, 20)];
    
    // name
    NSString* title = [NSString stringWithFormat:@"%@", marker.title];
    [[cell textLabel] setText:title];
    NSLog(@"UserData: %@", marker.userData);
    if ([[marker.userData objectForKey:@"isVisible"] isEqualToString:@"true"] && CLLocationCoordinate2DIsValid(marker.position))
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setUserInteractionEnabled:true];
        [cell.textLabel setEnabled:true];
        [cell.imageView setImage:marker.icon];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setUserInteractionEnabled:false];
        [cell.textLabel setEnabled:false];
        [cell.imageView setImage:[GMSMarker markerImageWithColor:[UIColor lightGrayColor]]];
    }
    

    return cell;
}

@end
