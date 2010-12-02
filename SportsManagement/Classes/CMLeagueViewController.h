//
//  CMLeagueViewController.h
//  SportsManagement
//
//  Created by Jason Harwig on 11/2/10.
//  Copyright 2010 Near Infinity Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CMLeagueViewController : UITableViewController {
	NSMutableArray *leagueArray;
	NSMutableArray *seasonArray;
	
	NSMutableData *receivedData;
	NSMutableArray *results;
}

@property (nonatomic, retain) NSMutableArray *results;
@end
