//
//  SMStandingsViewController.m
//  SportsManagement
//
//  Created by Jason Harwig on 11/2/10.
//  Copyright 2010 Near Infinity Corporation. All rights reserved.
//

#import "SMStandingsViewController.h"
#import "CMLeagueViewController.h"
#import "SMLoginViewController.h"
#import <YAJLIOS/YAJLIOS.h>
#import "CurrentPath.h"
@implementation SMStandingsViewController
@synthesize results, curSelection, standingsArray, standingsDetailArray;

// predefined network alias
#define NETWORK_ON [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#define NETWORK_OFF [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];	

	curSelection = [[CurrentPath alloc] init];
	
	if (curSelection.leagueID == nil || curSelection.seasonID == nil){
		
		CMLeagueViewController *vc = [[CMLeagueViewController alloc] init];
		vc.curSelection= self.curSelection;
		[[self navigationController] pushViewController:vc animated:YES];
		
		
		
	}
	
	// Creating MutableData Object 
	receivedData = [[NSMutableData alloc] init];
	
	// Creating a Mutable Array
	self.results = [NSArray array];
	self.standingsArray = [NSMutableArray array];
	self.standingsDetailArray = [NSMutableArray array];
}

-(IBAction)leagueButton {	
	CMLeagueViewController *vc = [[CMLeagueViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
	vc.curSelection = self.curSelection;
	[vc release];	
	
}

-(void)popNavControllerToSelf{
	[self.navigationController popToViewController:self animated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 
	 NSString *urlOne = [NSString stringWithFormat:@"http://nicsports.railsplayground.net/leagues/%@/seasons/%@.json",
						 curSelection.leagueID, curSelection.seasonID];
	 
	 NSURL *urlStr = [NSURL URLWithString:urlOne];	
	 
	 // URLRequest
	 NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
	 [NSURLConnection connectionWithRequest:request delegate:self];
 
	 if (standingsArray != nil){
		 [standingsArray removeAllObjects];
	 }
	 
	 if (standingsDetailArray != nil){
		 [standingsDetailArray removeAllObjects];
	 }
	 
 }
 
#pragma mark NSURLConnection Delegate

 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
 NETWORK_ON
 SMLoginViewController *vc = [[SMLoginViewController alloc] initWithChallenge:challenge];
 [self presentModalViewController:vc animated:YES];
 [vc release];
 
 }
 

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	NETWORK_ON;
    [receivedData appendData:data];
	
	
	return ;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NETWORK_ON;
	
	[receivedData setLength:0];
	
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NETWORK_OFF;
	
	self.results = [receivedData yajl_JSON];
    //NSLog(@"%@", self.results);
	
	NSDictionary *feed = [receivedData yajl_JSON];

	NSDictionary *seasonTeams = [[NSDictionary alloc] init];
	seasonTeams = [feed valueForKey:@"seasons_teams"];
	
	NSDictionary *teamStandings = [[NSDictionary alloc] init];
	teamStandings = [feed valueForKey:@"standings"];
	
	
	// Create an Array of objects with the key value of "id"
	NSArray *IDs = [seasonTeams valueForKey: @"team_id"];
	
	for (NSNumber *teamID in teamStandings){
		teamID =  [[teamID valueForKey:@"id"] retain];
		NSUInteger index = [IDs indexOfObject:teamID];
		NSDictionary *thisTeam = [seasonTeams objectAtIndex:index];
		
		NSString *temp = [NSString stringWithFormat:@"Wins:%@ - Losses:%@",
							[thisTeam valueForKey:@"wins"], [thisTeam valueForKey:@"losses"]];
		
		[standingsDetailArray addObject:temp];
		
	}
	
	for(NSString *teamName in teamStandings){
		teamName = [[teamName valueForKey:@"name"]retain];
		[standingsArray addObject:teamName];

	}
	
	
	[self.tableView reloadData];
    
}



- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NETWORK_ON
    NSLog(@"Response failed. Reason: %@", error);
	NETWORK_OFF
}




#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.	
    return [standingsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
    // Configure the cell...
	
	
	NSMutableArray* reversedName = [[standingsArray reverseObjectEnumerator] allObjects];
	
	NSMutableArray* reversedWinLoss = [[standingsDetailArray reverseObjectEnumerator] allObjects];

	
	cell.textLabel.text = [reversedName objectAtIndex:indexPath.row];
	cell.detailTextLabel.text = [reversedWinLoss objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

