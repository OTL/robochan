/**
 * @file world.m
 * @brief worldクラスのヘッダファイル
 *
 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

/* $Id:$ */

#import "world.h"
#import <stdio.h>

@implementation world

@synthesize viewPos;
@synthesize viewRot;
// @synthesize a;
// @synthesize b;
// @synthesize c;
// @synthesize d;
// @synthesize e;

- (void) addRandomRobot
{
  boxRobot *r = [boxRobot new];
  float x = 4 * (0.5 - (float)rand()/RAND_MAX);
  float y = 4 * (0.5 - (float)rand()/RAND_MAX);
  [r setPos:x:0.0:y];
  [self addObject:r];
}

- (id) init
{
  // 変数の初期化
  objNum = 0;

  // 視点の初期化
  viewPos = (float*)malloc(sizeof(float)*3);
  viewRot = (float*)malloc(sizeof(float)*3);

  viewPos[0] =   0.0;
  viewPos[1] =  -1.0;
  viewPos[2] = -10.0;

  viewRot[0] = 10.0;
  viewRot[1] =  0.0;
  viewRot[2] =  0.0;

  // 物体の作成
  [self addObject:(id)[ground new]];
  [self addObject:(id)[boxRobot new]];

  objObject *o = [objObject new];
  [o setPos:1.0:1.0:-3.0];
  [self addObject:o];

  //e = [o getData:&a:&b:&c:&d];

  return (self);
}

- (int)addObject:(id)obj
{
  if (objNum >= MAX_OBJNUM){
    //NSLogs();
    return (-1);
  }else{
    drawTargets[objNum] = obj;
    objNum++;
  }
  return 0;
}

- (void) draw
{
  static GLfloat lightpos[] = { 3.0, 4.0, 5.0, 1.0 }; /* 光源の位置 */

  /* 画面クリア */
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  /* モデルビュー変換行列の初期化 */
  glLoadIdentity();

  /* 光源の位置を設定 */
  glLightfv(GL_LIGHT0, GL_POSITION, lightpos);

  /* 視点の移動（物体の方を奥に移す）*/
  [self setCamera];

  for (int i = 0; i < objNum; i++){
    [drawTargets[i] draw];
  }

  glFlush();

}

- (void)setCamera
{
  glRotatef(viewRot[0], 1, 0, 0);
  glRotatef(viewRot[1], 0, 1, 0);
  glRotatef(viewRot[2], 0, 0, 1);

  //  glTranslatef(0.0, -1.0, -10.0);
  glTranslatef(viewPos[0],viewPos[1],viewPos[2]);

}

- (void)dealloc
{
  free(viewPos);
  free(viewRot);

  [super dealloc];
}

@end
