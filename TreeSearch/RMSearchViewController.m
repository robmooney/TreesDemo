//
//  RMSearchViewController.m
//  TreeSearch
//
//  Created by Robert Mooney on 05/07/2012.
//  Copyright (c) 2012 Robert Mooney. All rights reserved.
//

#import "RMSearchViewController.h"
#import "RMTree.h"

@interface RMSearchViewController () <NSURLConnectionDataDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *data;

@end

@implementation RMSearchViewController

@synthesize searchBar = _searchBar;
@synthesize mapView = _mapView;
@synthesize trees = _trees;

@synthesize connection = _connection;
@synthesize data = _data;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.region = MKCoordinateRegionMake((CLLocationCoordinate2D){53.408, -6.267}, MKCoordinateSpanMake(0.05, 0.05));
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGestureRecognizer.delegate = self;
    
    [self.mapView addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Search bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.mapView removeAnnotations:self.trees];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSString *URLString = [NSString stringWithFormat:@"http://localhost:3000/search?tree=%@&lat=%f&lon=%f&latspan=%f&lonspan=%f", [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.mapView.region.center.latitude, self.mapView.region.center.longitude, self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta];
    
    NSLog(@"%@", URLString);
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPShouldUsePipelining = YES;
    
    self.data = [NSMutableData data];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - Actions

- (IBAction)hideKeyboard:(id)sender
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.searchBar.isFirstResponder;
}

#pragma mark - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString *PinIdentifer = @"Pin";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:PinIdentifer];
    if (pinView == nil) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PinIdentifer];
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
    }
    
    pinView.annotation = annotation;
    
    return pinView;
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
    NSError *error;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    NSMutableArray *trees = [NSMutableArray array];
    
    for (NSDictionary *dictionary in [result objectForKey:@"results"]) {
        RMTree *tree = [[RMTree alloc] init];
        tree.title = [dictionary objectForKey:@"commonname"];
        tree.subtitle = [dictionary objectForKey:@"sitename"];
        tree.coordinate = (CLLocationCoordinate2D) {[[dictionary objectForKey:@"latitude"] floatValue], [[dictionary objectForKey:@"longitude"] floatValue]};
        [trees addObject:tree];
    }
    
    self.trees = trees;
    
    [self.mapView addAnnotations:self.trees];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);    
}

@end
