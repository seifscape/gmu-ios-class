//
//  CurrentPath.h
//  SportsManagement
//
//  Created by Seif Kobrosly on 12/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrentPath : NSObject {

	NSNumber *leagueID;
	NSNumber *seasonID;
	
}

@property (nonatomic, retain) NSNumber *leagueID;
@property (nonatomic, retain) NSNumber *seasonID;


@end
