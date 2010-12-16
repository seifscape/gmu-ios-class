//
//  CMLeagueViewController.m
//  SportsManagement
//
//  Created by Jason Harwig on 11/2/10.
//  Copyright 2010 Near Infinity Corporation. All rights reserved.
//

#import "CMLeagueViewController.h"
#import <YAJLIOS/YAJLIOS.h>
#import "CMSeasonViewController.h"
#import "SMLoginViewController.h"
#import "CurrentPath.h"

@implementation CMLeagueViewController
@synthesize results, curSelection;

// predefined network alias
#define NETWORK_ON [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#define NETWORK_OFF [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	NETWORK_ON
	//NSString *urlStr = [NSString stringWithFormat:@"http://www.djakeed.com/JSON/leagues.json"]; 
	//NSURL *url = [NSURL URLWithString:urlStr];
	
	NSURL *urlStr = [NSURL URLWithString:@"http://nicsports.railsplayground.net/leagues.json"];	
	
	// URLRequest
	NSURLRequest *request = [NSURLRequest requestWithURL:urlStr];
	[NSURLConnection connectionWithRequest:request delegate:self];
	
	
	// Creating MutableData Object 
	receivedData = [[NSMutableData alloc] init];
	
	// Creating a Mutable Array
	self.results = [NSMutableArray array];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setImageView:(UIImage *)newImageView{
	[imageView release];
	imageView = [newImageView retain];
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
	return;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NETWORK_ON;
	
	[receivedData setLength:0];
	

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	self.results = [receivedData yajl_JSON];
	
    NETWORK_OFF;
	// display the error using an alertview.
    if (self.results == nil || [self.results isKindOfClass:[NSDictionary class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[(NSDictionary *)self.results objectForKey:@"error"] delegate:self
                                              cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
        return;
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
    
	return [results count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	
	if(section == 0) {
		sectionHeader = @"Leagues";
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
	
	
	[self setImageView:[UIImage imageNamed:@"basketball.png"]];
	
	cell.imageView.image = imageView;
	cell.textLabel.text = [feed valueForKey:@"sport"];
	cell.detailTextLabel.text = [feed valueForKey:@"name"];

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    
	 NSDictionary *feed = [results objectAtIndex:indexPath.row];
	 CMSeasonViewController *seasonVC = [[CMSeasonViewController alloc] init];
	
	[curSelection setLeagueID:[feed valueForKey:@"id"]];
	  NSLog(@"League ID value :%@", [curSelection leagueID]);
	 seasonVC.curSelection = self.curSelection;
	 [self.navigationController pushViewController:seasonVC animated:YES];
	 [seasonVC release];
	
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
	[imageView release];

}


@end

