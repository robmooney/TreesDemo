//
//  RMViewController.h
//  TreeSearch
//
//  Created by Robert Mooney on 05/07/2012.
//  Copyright (c) 2012 Robert Mooney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RMViewController : UIViewController <UISearchBarDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (copy, nonatomic) NSArray *trees;

@end
