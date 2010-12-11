//
//  SMStandingsViewController.h
//  SportsManagement
//
//  Created by Jason Harwig on 11/2/10.
//  Copyright 2010 Near Infinity Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CurrentPath;

@interface SMStandingsViewController : UITableViewController {
	NSMutableData *receivedData;
	NSMutableDictionary *receivedDataDictionary;
	NSMutableArray *results;
	IBOutlet UIBarButtonItem *leagueButton;
	CurrentPath *curSelection;
}

@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) CurrentPath *curSelection;

-(IBAction)leagueButton;


@end
