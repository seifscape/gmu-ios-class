//
//  SMTeam.h
//  SportsManagement
//
//  Created by Seif Kobrosly on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


// NSObject that Describes a Team
#import <Foundation/Foundation.h>


@interface SMTeam : NSObject {
	// iVars of Team
	NSString *Name;
	NSString *Color;
	NSString *Coach;
	NSInteger *numOfWins;
	NSInteger *numOfLoss;
	NSInteger *numOfTies;
	NSArray  *Roster;
	UIImage  *Logo;

}

@end
