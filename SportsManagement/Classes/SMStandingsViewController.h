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
	NSArray *results;
	IBOutlet UIBarButtonItem *leagueButton;
	CurrentPath *curSelection;
	NSMutableArray *standingsArray;
	NSMutableArray *standingsDetailArray;
	
}

@property (nonatomic, retain) NSMutableArray *standingsDetailArray;
@property (nonatomic, retain) NSMutableArray *standingsArray;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) CurrentPath *curSelection;

-(IBAction)leagueButton;


@end
