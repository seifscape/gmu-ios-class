//
//  CMLeagueViewController.h
//  SportsManagement
//
//  Created by Jason Harwig on 11/2/10.
//  Copyright 2010 Near Infinity Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CurrentPath;

@interface CMLeagueViewController : UITableViewController {

	NSMutableData *receivedData;
	NSArray *results;
	CurrentPath *curSelection;

}
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) CurrentPath *curSelection;
@end
