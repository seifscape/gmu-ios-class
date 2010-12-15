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
@synthesize results, curSelection, standingsArray;

// predefined network alias
#define NETWORK_ON [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#define NETWORK_OFF [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;


#pragma mark -
#pragma mark Initialization

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 self = [super initWithStyle:style];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


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


 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];    
	 if (curSelection.leagueID == nil || curSelection.seasonID == nil){
		 NSLog(@"Current Path is NULL");
	 }
	 else {
		 NSLog(@"League ID:%@ Season ID:%@", curSelection.leagueID, curSelection.seasonID);
	 }

 
 
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
	 
 }
 
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
	
	//NSDictionary *teamDictinary = [[NSDictionary alloc] initWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
	//[teamDictinary setValue:standingsArray forKey:@"key1"];

	
	// Create an Array of objects with the key value of "id"
	NSArray *IDs = [teamStandings valueForKey: @"id"];
	
	for (NSNumber *teamID in seasonTeams){
		teamID =  [[teamID valueForKey:@"team_id"] retain];
		NSUInteger index = [IDs indexOfObject:teamID];
		//NSLog(@"%@", teamID);
		NSDictionary *thisTeam = [teamStandings objectAtIndex:index];
		//[standingsArray addObject:[thisTeam valueForKey:@"name"]];
		
		
		//NSLog([thisTeam valueForKey:@"name"]);
	
	}
	
	for(NSString *teamName in teamStandings){
		teamName = [[teamName valueForKey:@"name"]retain];
		[standingsArray addObject:teamName];
		NSLog(@"Name %s", teamName);
	}
	
	
		//NSLog([NSString stringWithFormat:@"s=%@", s]);

	
	
	//NSLog(@"Count of managedObjectContext: %d\n%@", [seasonTeams count], seasonTeams);
	//NSLog(@"Count of managedObjectContext: %d\n%@", [teamStandings count], teamStandings);
	//NSLog(@"Count of managedObjectContext: %d\n%@", [self.results count], self.results);

	//NSLog([standingsArray description]);

	
	//NSLog(@"seasonTeams: %@", seasonTeams);
	//NSLog(@"teamStanding: %@", teamStandings);
	
	
	
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
	
	
	NSMutableArray* reversed = [[standingsArray reverseObjectEnumerator] allObjects];
	
	cell.textLabel.text = [reversed objectAtIndex:indexPath.row];
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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

