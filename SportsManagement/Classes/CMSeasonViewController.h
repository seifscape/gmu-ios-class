//
//  CMSeasonViewController.h
//  SportsManagement
//
//  Created by Seif Kobrosly on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CurrentPath;

@interface CMSeasonViewController : UITableViewController {
	NSMutableData *receivedData;
	NSMutableDictionary *receivedDataDictionary;
	NSMutableArray *results;
	CurrentPath *curSelection;
	
	
}
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) CurrentPath *curSelection;


@end
