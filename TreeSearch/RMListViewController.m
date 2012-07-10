//
//  RMListViewController.m
//  TreeSearch
//
//  Created by Robert Mooney on 10/07/2012.
//  Copyright (c) 2012 Robert Mooney. All rights reserved.
//

#import "RMListViewController.h"
#import "RMTree.h"

@interface RMListViewController () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *data;

@end

@implementation RMListViewController

@synthesize trees = _trees;
@synthesize tableView = _tableView;

@synthesize connection = _connection;
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.trees) {
        self.trees = [NSMutableArray array];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/"]];
    request.HTTPShouldUsePipelining = YES;
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (self.connection) {
        self.data = [NSMutableData data];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.trees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RMTree *tree = [self.trees objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tree.title;
    cell.detailTextLabel.text = tree.subtitle;
    
    return cell;
}

#pragma mark - URL connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.data.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:NULL];
    
    NSArray *treeDictionaries = [results objectForKey:@"results"];
    
    for (NSDictionary *treeDictionary in treeDictionaries) {
        RMTree *tree = [[RMTree alloc] init];
        tree.title = [treeDictionary objectForKey:@"commonname"];
        tree.subtitle = [treeDictionary objectForKey:@"species"];
        [self.trees addObject:tree];
    }
    
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
