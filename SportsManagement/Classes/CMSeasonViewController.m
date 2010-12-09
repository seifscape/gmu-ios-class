//
//  CMSeasonViewController.m
//  SportsManagement
//
//  Created by Seif Kobrosly on 12/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CMSeasonViewController.h"
#import "CMLeagueViewController.h"
#import "MyLeague.h"

@implementation CMSeasonViewController
@synthesize results, curLeague;

// predefined network alias
#define NETWORK_ON [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#define NETWORK_OFF [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

//MyAppDelegate *appDelegate = (MyAppDelegate *)[[UIApplication sharedApplication] delegate];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	NSURL *urlStr = [NSURL URLWithString:@"http://www.djakeed.com/JSON/seasons.json"];	
	
	NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	receivedData = [[NSMutableData alloc] init];
	
	self.results = [NSMutableArray array];
	
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark NSURLConnection Delegate
/*
 - (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
 NETWORK_ON
 SMLoginViewController *vc = [[SMLoginViewController alloc] initWithChallenge:challenge];
 [self presentModalViewController:vc animated:YES];
 [vc release];
 
 }
 */

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
	NSArray *seasonArray = [[NSArray alloc]
							initWithObjects:[feed valueForKey:@"start_date"], [feed valueForKey:@"end_date"], nil];
	NSLog(@"Season: %@", seasonArray);

	
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

	
	if (curLeague.leagueID == [feed valueForKey:@"league_id"]) {
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	NSDate *date = [dateFormat dateFromString:[feed valueForKey:@"start_date"]];
	
	NSDateFormatter *newDate = [[NSDateFormatter alloc]init];
	[newDate setDateFormat:@"MMMM-YYYY"];
	NSString *newString = [newDate stringFromDate:date];
	
	cell.textLabel.text = newString;
	
	}
	//NSArray *array = [self.myArray objectAtIndex:indexPath.row];
	//cell.textLabel.text = [array objectAtIndex:indexPath.row];
	
	
	//NSString *startDateString = ];
	//NSString *endtDateString = [dateFormatter stringFromDate:[feed valueForKey:@"end_date"]];

								 
	
	//cell.detailTextLabel.text = endtDateString;
    
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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

