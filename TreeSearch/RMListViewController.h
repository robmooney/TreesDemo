//
//  RMListViewController.h
//  TreeSearch
//
//  Created by Robert Mooney on 10/07/2012.
//  Copyright (c) 2012 Robert Mooney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *trees;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
