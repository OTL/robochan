//
//  OTLPoseTeachViewController.m
//  Robochan
//
//  Created by 小倉 崇 on 5/2/09.
//  Copyright 2009 OTL. All rights reserved.
//

#import "OTLPoseTeachViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation OTLPoseTeachViewController


- (void) scanPoseFiles
{
    fileList = (NSMutableArray *)[[[[NSFileManager defaultManager]
				     directoryContentsAtPath:DOCUMENTS_FOLDER]
				    pathsMatchingExtensions:[NSArray arrayWithObjects:@"rp", @"csv",nil]] retain];
}


- (void) reloadData
{
  [self.tableView reloadData];
  self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [fileList count]];
}

- (id)initWithRobotInterface:(OTLKHRInterface *)ari
{
  if (self = [super initWithNibName:nil bundle:nil])
  {
    //self.view.backgroundColor = [UIColor lightGrayColor];		
    self.title = @"姿勢作成";
    self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 

    // ロボットインタフェースの初期化
     ri = ari;
    NSLog(@"ri = %d\n", ri);
    [ri retain];

    //
	[self scanPoseFiles];
  [self reloadData];
  
  }

  return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [fileList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.text = [fileList objectAtIndex:[indexPath row]];

    // Set up the cell...
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // KHRに姿勢を送る
  
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  // buttonIndex == 0 がキャンセルらしい
  if (buttonIndex != 0){
    // delete file
    // ファイルの削除
    NSError *error;
    NSString *fname = alertView.message;
    [[NSFileManager defaultManager] removeItemAtPath:[DOCUMENTS_FOLDER stringByAppendingPathComponent:fname]
                                             error:&error];
    // テーブルからの削除
    [fileList removeObject:fname];
    // 再描画
    [self reloadData];
  }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      // messageにファイル名をのせて後で削除してもらっている
      UIAlertView *delAllert = [[UIAlertView alloc] initWithTitle:@"ファイルを削除します" message:[fileList objectAtIndex:[indexPath row]]                                                                                                                 
                                                         delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"削除", nil];
      [delAllert show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  NSString *title = [fileList objectAtIndex:[fromIndexPath row]];
  [fileList removeObjectAtIndex:[fromIndexPath row]];
  [fileList insertObject:title atIndex:[toIndexPath row]];
}




// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)memorizePose
{
  // 姿勢をゲット
  
  // ファイルに書き込み
	NSError *error;
	NSMutableString *str = @"hoge";
  
  // 存在しない名前で姿勢を保存
  NSString *fname;
  NSString *fullpath;
  int fCount = [fileList count];
  do{
    fname = [NSString stringWithFormat: @"Pose%07d.rp", fCount];
    fullpath = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fname];
    fCount++;
  }while([[NSFileManager defaultManager] fileExistsAtPath: fullpath]);

  // 書き込み
  [str writeToFile: fullpath atomically:YES encoding:NSUTF8StringEncoding error:&error];
		
  // テーブルを更新
  [fileList addObject:fname];
  [self reloadData];
}

- (void)enterEditMode
{
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"完了"
                                            style:UIBarButtonItemStylePlain
                                            target:self action:@selector(leaveEditMode)]
                                            autorelease];
  [self.tableView setEditing:YES animated:YES];
  [self.tableView beginUpdates];
}

- (void)setNavigationRightButton
{
  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"並べ替え"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(enterEditMode)]
                                            autorelease];
}

- (void)setNavigationLeftButton
{
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"覚える"
								    style:UIBarButtonItemStylePlain
								    target:self
								    action:@selector(memorizePose)]
                                             autorelease];
}


- (void)leaveEditMode
{
  [self setNavigationRightButton];
  [self.tableView endUpdates];
  [self.tableView setEditing:NO animated:YES];
}

- (void)loadView
{
  [super loadView];

  [self setNavigationLeftButton];
  [self setNavigationRightButton];
 
  printf("Documents folder is %s \n", [DOCUMENTS_FOLDER UTF8String]);
	self.tableView.autoresizesSubviews = YES;
	self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
}

- (void)dealloc {
  [ri release];
	[fileList release];
  [super dealloc];
}


@end

