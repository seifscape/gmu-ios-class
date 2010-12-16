//
//  CMSeasonViewController.m
//  SportsManagement
//
//  Created by Seif Kobrosly on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CMSeasonViewController.h"
#import "CMLeagueViewController.h"
#import "CurrentPath.h"
#import "SMStandingsViewController.h"
#import "SMLoginViewController.h"

@implementation CMSeasonViewController
@synthesize results, curSelection;

// predefined network alias
#define NETWORK_ON [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#define NETWORK_OFF [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	
	NSString *urlOne = [NSString stringWithFormat:@"http://nicsports.railsplayground.net/leagues/%@/seasons.json",
						curSelection.leagueID];
		
	NSURL *urlStr = [NSURL URLWithString:urlOne];	

	NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	receivedData = [[NSMutableData alloc] init];
	
	self.results = [NSMutableArray array];
		
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
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
    return [results count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Season";
	}
	
	return sectionHeader;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSDictionary *feed = [results objectAtIndex:indexPath.row];

	
	if (curSelection.leagueID == [feed valueForKey:@"league_id"]) {
	// Start Date
	NSDateFormatter *startDateFormat = [[NSDateFormatter alloc]init];
	[startDateFormat setDateFormat:@"yyyy-MM-dd"];
	NSDate *dateStart = [startDateFormat dateFromString:[feed valueForKey:@"start_date"]];
	
	NSDateFormatter *newStartDate = [[NSDateFormatter alloc]init];
	[newStartDate setDateFormat:@"MMMM YYYY"];
	NSString *startDateString = [newStartDate stringFromDate:dateStart];
	
		
	// End Year
	NSDateFormatter *endDateFormat = [[NSDateFormatter alloc]init];
	[endDateFormat setDateFormat:@"yyyy-MM-dd"];
	NSDate *dateEnd = [endDateFormat dateFromString:[feed valueForKey:@"end_date"]];
	
	NSDateFormatter *newEndDate = [[NSDateFormatter alloc]init];
	[newEndDate setDateFormat:@"MMMM YYYY"];
	NSString *endDateString = [newEndDate stringFromDate:dateEnd];	
		
	
	NSString *urlOne = [NSString stringWithFormat:@"%@ - %@",
						startDateString, endDateString];	
		
	cell.textLabel.text = urlOne;
	
	}
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *feed = [results objectAtIndex:indexPath.row];
	[curSelection setSeasonID:[feed valueForKey:@"id"]];
	NSLog(@"Season League ID value :%@", [curSelection seasonID]);
	[self.navigationController popToRootViewControllerAnimated:YES];
	
	

	
	//[self.navigationController popViewControllerAnimated:self animated:YES];
	
	
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
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

