//
//  OTLPoseTeachViewController.m
//  Robochan
//
//  Created by 小倉 崇 on 5/2/09.
//  Copyright 2009 OTL. All rights reserved.
//

#import "OTLPoseTeachViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
//#define DOCUMENTS_FOLDER [@"/var/root/" stringByAppendingPathComponent:@"Documents"]

@implementation OTLPoseTeachViewController

@synthesize ri;

- (void) scanPoseFiles
{
  fileList = (NSMutableArray *)[[[[NSFileManager defaultManager] directoryContentsAtPath: DOCUMENTS_FOLDER]
                                   pathsMatchingExtensions:[NSArray arrayWithObjects:@"rp", @"csv",nil]] retain];
}

- (void) reloadData
{
  [self.tableView reloadData];
  self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", [fileList count]];
}

- (id)init
{
  if (self = [super initWithNibName:nil bundle:nil])
  {
    //self.view.backgroundColor = [UIColor lightGrayColor];		
    self.title = @"姿勢作成";
    self.tabBarItem.image = [UIImage imageNamed:@"teachTabIcon_32.png"]; 

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

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
   // 全軸フリーにする
  NSLog(@"PoseTeach ri = %d\n", ri);
  [ri setJointServoOffAll];
}

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

#include "stdio.h"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  double angles[RCB3J_MAX_DOF];
      
  // ファイル名を取得
  NSString *fname = [fileList objectAtIndex:[indexPath row]];
  NSString *path = [DOCUMENTS_FOLDER stringByAppendingPathComponent:fname];
  // ファイルからdouble angles[24]を取得
  const char *cpath = [path UTF8String];
  FILE *fd = fopen(cpath,"r");
  fscanf(fd, "%lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf",
                   &angles[0], &angles[1],  &angles[2],  &angles[3], &angles[4], &angles[5], &angles[6], &angles[7], &angles[8], &angles[9],
                   &angles[10],&angles[11],&angles[12],&angles[13],&angles[14],&angles[15],&angles[16],&angles[17],&angles[18],&angles[19],
                   &angles[20],&angles[21],&angles[22],&angles[23]);
  fclose(fd);
  // KHRに姿勢を送る
  [ri setJointAngles:angles time: 500];
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
    if ( fname != nil)
    {
      [[NSFileManager defaultManager] removeItemAtPath:[DOCUMENTS_FOLDER stringByAppendingPathComponent:fname]
                                                 error:&error];
      // テーブルからの削除
      [fileList removeObject:fname];
      // 再描画
      [self reloadData];
    }
  }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      // messageにファイル名をのせて後で削除してもらっている
      UIAlertView *delAllert = [[[UIAlertView alloc] initWithTitle:@"ファイルを削除します" message:[fileList objectAtIndex:[indexPath row]]                                                                                                                 
                                                         delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"削除", nil] autorelease];
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

- (void)showAlertWithMessage:(NSString *)str
{
  UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"msg" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
  [errorAlert show];
  [errorAlert release];
}

- (void)memorizeRobotPose
{
  // 姿勢をゲット
  double angles[RCB3J_MAX_DOF];
  BOOL successWrite = YES;
  
  // 全軸フリーにする
  [ri setJointServoOffAll];
  // 角度取得
  [ri getJointAngles:angles];

  // ファイルに書き込み
	NSError *error;
  // ありえねー。 NSData? NSCoder?

	NSString *str = [NSString stringWithFormat: @"%lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf",
                   angles[0], angles[1],  angles[2],  angles[3], angles[4], angles[5], angles[6], angles[7], angles[8], angles[9],
                   angles[10],angles[11],angles[12],angles[13],angles[14],angles[15],angles[16],angles[17],angles[18],angles[19],
                   angles[20],angles[21],angles[22],angles[23]];
  
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
  successWrite = [str writeToFile: fullpath atomically:YES encoding:NSUTF8StringEncoding error:&error];
  if ( !successWrite )
  {
    [self showAlertWithMessage:@"fail to write file"];
  }
  
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
								    action:@selector(memorizeRobotPose)]
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
 
  NSLog(@"Documents folder is %s \n", [DOCUMENTS_FOLDER UTF8String]);
	self.tableView.autoresizesSubviews = YES;
	self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
}

- (void)dealloc {
  [ri release];
	[fileList release];
  [super dealloc];
}


@end

