//
//  CMSeasonViewController.h
//  SportsManagement
//
//  Created by Seif Kobrosly on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyLeague;

@interface CMSeasonViewController : UITableViewController {
	NSMutableData *receivedData;
	NSMutableDictionary *receivedDataDictionary;
	NSMutableArray *results;
	MyLeague *curLeague;
	
	
}
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) MyLeague *curLeague;


@end
