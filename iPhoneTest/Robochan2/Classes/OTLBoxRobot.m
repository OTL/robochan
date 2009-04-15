/** @file OTLBoxRobot.m
 @brief OTLBoxRobotクラス
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import "OTLBoxRobot.h"
#import "math.h"

@implementation OTLBoxRobot

/** 初期化
 *
 */
- (id) init
{
  frame = 0;
  dir = 1;
  neck = 0;
  return [super init];
}

/** 腕／足の描画
 * 
 * @param [in] girth 太さ
 * @param [in] length 長さ
 * @param [in] r1 関節1の角度(deg)
 * @param [in] r2 関節2の角度(deg)
 */
- (void) drawArmLeg:(float) girth: (float) length: (float) r1: (float) r2
{
  glRotatef(r1, 1.0, 0.0, 0.0);
  [self drawBox:girth:length:girth];
  glTranslatef(0.0, -0.05 - length, 0.0);
  glRotatef(r2, 1.0, 0.0, 0.0);
  [self drawBox:girth: length: girth];
}


/** 直方体を描く
 * 
 * @param [in] x X軸長さ
 * @param [in] y Y軸長さ
 * @param [in] z Z軸長さ
 */
- (void)drawBox:(float)x:(float) y:(float) z
{
  GLfloat hx = x * 0.5, hz = z * 0.5;

  GLfloat vertex[][3] = {
    //
    {-hx,  0.0, -hz} ,//3
    {hx,  0.0, -hz} ,//2
    { hx,   -y, -hz} ,//1
    {-hx,   -y, -hz} ,//0
    //
    {hx,  0.0, -hz} ,//2
    {hx,  0.0,  hz} ,//6
    {hx,   -y,  hz} ,//5
    { hx,   -y, -hz} ,//1
    //
    {hx,  0.0,  hz} ,//6
    {-hx,  0.0,  hz}, //7
    {-hx,   -y,  hz} ,//4
    {hx,   -y,  hz} ,//5
    //
    {-hx,  0.0,  hz}, //7
    {-hx,  0.0, -hz} ,//3
    {-hx,   -y, -hz} ,//0
    {-hx,   -y,  hz} ,//4
    //
    {-hx,   -y, -hz} ,//0
    { hx,   -y, -hz} ,//1
    {hx,   -y,  hz} ,//5
    {-hx,   -y,  hz} ,//4
    //
    {-hx,  0.0,  hz}, //7
    {hx,  0.0,  hz} ,//6
    {hx,  0.0, -hz} ,//2
    {-hx,  0.0, -hz} ,//3
  };

  static GLfloat normal[][3] = {
    {0.0, 0.0, -1.0 },
    {1.0, 0.0, 0.0 },
    {0.0, 0.0, 1.0 },
    {-1.0, 0.0, 0.0},
    {0.0,-1.0, 0.0 },
    {0.0,1.0, 0.0 },
  };

  static GLfloat red[] = { 0.8, 0.2, 0.2, 1.0 };

  int i;

  /* 材質を設定する */
  glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, red);

  glEnableClientState(GL_VERTEX_ARRAY);

  for (i = 0 ; i < 6; i++){
    glVertexPointer(3, GL_FLOAT, 0, &vertex[i*4]);
    glNormal3f(normal[i][0],normal[i][1],normal[i][2]);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
  }

  glDisableClientState(GL_VERTEX_ARRAY);
}

/** drawableObjectクラスで要求される形状の描画
 * 
 * 位置はdrawableObjectのpos, rotで決定される
 */
- (void) drawShape
{
  //  static int frame = 0;                               /* フレーム数 */

//   /* STEPCYCLE に指定した枚数のフレームを描画する間に 0→1 に変化　 */
//   double t = (frame % STEPCYCLE) / (double)STEPCYCLE;

//   /* WALKCYCLE に指定した枚数のフレームを描画する間に 0→1 に変化　 */
//   double s = (frame % WALKCYCLE) / (float)WALKCYCLE;

  /*
   * 以下の変数に値を設定する
   */

  float ll1 = 0.0; /* 箱男の左足の股関節の角度 */
  float ll2 = 30.0; /* 箱男の左足の膝関節の角度 */

  float rl1 = 0.0; /* 箱男の右足の股関節の角度 */
  float rl2 = 40.0; /* 箱男の右足の膝関節の角度 */

  //float la1 = 0.0; /* 箱男の左腕の肩関節の角度 */
  float la1 = 100 * sin(3.14*((float)frame/100.0)); /* 箱男の左腕の肩関節の角度 */
  float la2 = 1.0; /* 箱男の左腕の肘関節の角度 */

  float ra1 = 0.0; /* 箱男の右腕の肩関節の角度 */
  float ra2 = 1.0; /* 箱男の右腕の肘関節の角度 */

  //float px = 0.0, pz = 0.0;      /* 箱男の位置 */
  //float r = 0.0;                 /* 箱男の向き */
  //float h = 0.0;                 /* 箱男の高さ */
//   static GLfloat neck = 0;
//   static GLfloat dir  = 1;

  /* フレーム数（画面表示を行った回数）をカウントする */
  ++frame;


  /* シーンの描画 */

  /* 地面 */
  //[self drawGround:-1.8];

  /* 箱男の位置と方向 */
  //glTranslatef(px, h, pz);
  //glTranslatef(pos[0], pos[1], pos[2]);
  //glRotatef(r, 0.0, 1.0, 0.0);

  /* 頭 */
  glPushMatrix();

  if ( neck > 30) {
    dir = -1;
  }
  if ( neck < -30) {
    dir = 1;
  }
  neck += dir;
  //printf("neck=%f\n", neck);
  glRotatef(neck, 0.0, 1.0, 0.0);
  [self drawBox:0.20: 0.25: 0.22];
  glPopMatrix();

  /* 胴 */
  glTranslatef(0.0, -0.3, 0.0);
  [self drawBox:0.4: 0.6: 0.3];

  /* 左足 */
  glPushMatrix();
  glTranslatef(0.1, -0.65, 0.0);
  [self drawArmLeg:0.2: 0.4: ll1: ll2];
  glPopMatrix();

  /* 右足 */
  glPushMatrix();
  glTranslatef(-0.1, -0.65, 0.0);
  [self drawArmLeg:0.2: 0.4: rl1: rl2];
  glPopMatrix();

  /* 左腕 */
  glPushMatrix();
  glTranslatef(0.28, 0.0, 0.0);
  [self drawArmLeg:0.16: 0.4: la1: la2];
  glPopMatrix();

  /* 右腕 */
  glPushMatrix();
  glTranslatef(-0.28, 0.0, 0.0);
  [self drawArmLeg:0.16: 0.4: ra1: ra2];
  glPopMatrix();

  
}

@end
