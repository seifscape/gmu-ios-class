//
//  CMLeagueViewController.h
//  SportsManagement
//
//  Created by Jason Harwig on 11/2/10.
//  Copyright 2010 Near Infinity Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyLeague;

@interface CMLeagueViewController : UITableViewController {

	NSMutableData *receivedData;
	NSArray *results;
	MyLeague *curLeague;

}
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) MyLeague *curLeague;
@end
