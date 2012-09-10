//
//  CateViewController.h
//  top100
//
//  Created by Dai Cloud on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"

@interface CateViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *cates;
@property (strong, nonatomic) IBOutlet UIFolderTableView *tableView;

@end
