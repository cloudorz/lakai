//
//  CateViewController.m
//  top100
//
//  Created by Dai Cloud on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CateViewController.h"
#import "SubCateViewController.h"
#import "CateTableCell.h"

@interface CateViewController () <UIFolderTableViewDelegate>

@property (strong, nonatomic) SubCateViewController *subVc;
@property (strong, nonatomic) NSDictionary *currentCate;


@end

@implementation CateViewController

@synthesize cates=_cates;
@synthesize subVc=_subVc;
@synthesize currentCate=_currentCate;
@synthesize tableView=_tableView;

- (void)dealloc
{
    [_cates release];
    [_subVc release];
    [_currentCate release];
    [_tableView release];
    [super dealloc];
}

-(NSArray *)cates
{
    if (_cates == nil){
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Category" withExtension:@"plist"];
        _cates = [[NSArray arrayWithContentsOfURL:url] retain];
        
    }
    
    return _cates;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tmall_bg_furley.png"]];
//    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"类目导航";

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.cates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";

    CateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[CateTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                      reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    }
    
    NSDictionary *cate = [self.cates objectAtIndex:indexPath.row];
    cell.logo.image = [UIImage imageNamed:[[cate objectForKey:@"imageName"] stringByAppendingString:@".png"]];
    cell.title.text = [cate objectForKey:@"name"];
    
    NSMutableArray *subTitles = [[NSMutableArray alloc] init];
    NSArray *subClass = [cate objectForKey:@"subClass"];
    for (int i=0; i < MIN(4,  subClass.count); i++) {
        [subTitles addObject:[[subClass objectAtIndex:i] objectForKey:@"name"]];
    }
    cell.subTtile.text = [subTitles componentsJoinedByString:@"/"];
    [subTitles release];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SubCateViewController *subVc = [[[SubCateViewController alloc] 
                  initWithNibName:NSStringFromClass([SubCateViewController class]) 
                  bundle:nil] autorelease];
    NSDictionary *cate = [self.cates objectAtIndex:indexPath.row];
    subVc.subCates = [cate objectForKey:@"subClass"];
    self.currentCate = cate;
    subVc.cateVC = self;
    
    self.tableView.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view 
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                 } 
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                } 
                           completionBlock:^{
                               // completed actions
                               self.tableView.scrollEnabled = YES;
                           }];
    
}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)subCateBtnAction:(UIButton *)btn
{

    NSDictionary *subCate = [[self.currentCate objectForKey:@"subClass"] objectAtIndex:btn.tag];
    NSString *name = [subCate objectForKey:@"name"];
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"子类信息"
                                                         message:[NSString stringWithFormat:@"名称:%@, ID: %@", name, [subCate objectForKey:@"classID"]]
                                                        delegate:nil
                                               cancelButtonTitle:@"确认"
                                               otherButtonTitles:nil];
    [Notpermitted show];
    [Notpermitted release];
}

@end
