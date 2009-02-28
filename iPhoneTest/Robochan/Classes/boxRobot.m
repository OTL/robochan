/*

  File: BoxRobot.m
  Abstract: This class wraps the CAEAGLLayer from CoreAnimation into a convenient
  UIView subclass. The view content is basically an EAGL surface you render your
  OpenGL scene into.  Note that setting the view non-opaque will only work if the
  EAGL surface has an alpha channel.

  Version: 1.7

  Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
  ("Apple") in consideration of your agreement to the following terms, and your
  use, installation, modification or redistribution of this Apple software
  constitutes acceptance of these terms.  If you do not agree with these terms,
  please do not use, install, modify or redistribute this Apple software.

  In consideration of your agreement to abide by the following terms, and subject
  to these terms, Apple grants you a personal, non-exclusive license, under
  Apple's copyrights in this original Apple software (the "Apple Software"), to
  use, reproduce, modify and redistribute the Apple Software, with or without
  modifications, in source and/or binary forms; provided that if you redistribute
  the Apple Software in its entirety and without modifications, you must retain
  this notice and the following text and disclaimers in all such redistributions
  of the Apple Software.
  Neither the name, trademarks, service marks or logos of Apple Inc. may be used
  to endorse or promote products derived from the Apple Software without specific
  prior written permission from Apple.  Except as expressly stated in this notice,
  no other rights or licenses, express or implied, are granted by Apple herein,
  including but not limited to any patent rights that may be infringed by your
  derivative works or by other works in which the Apple Software may be
  incorporated.

  The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
  WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
  WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
  COMBINATION WITH YOUR PRODUCTS.

  IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
  DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
  CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
  APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "boxRobot.h"
#import "math.h"

@implementation boxRobot

/*
 * 腕／足
 */
- (void) drawArmLeg:(float) girth: (float) length: (float) r1: (float) r2
{
  glRotatef(r1, 1.0, 0.0, 0.0);
  [self drawBox:girth:length:girth];
  glTranslatef(0.0, -0.05 - length, 0.0);
  glRotatef(r2, 1.0, 0.0, 0.0);
  [self drawBox:girth: length: girth];
}


/*
 * 直方体を描く
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

/*
 * 画面表示
 */
- (void) drawShape
{
  static int frame = 0;                               /* フレーム数 */

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
  static GLfloat neck = 0;
  static GLfloat dir  = 1;

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
