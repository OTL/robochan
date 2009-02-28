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

#import "world.h"

@implementation world

- (id) init
{
  objNum = 0;
  [self addObject:(id)[ground new]];
  [self addObject:(id)[boxRobot new]];

  boxRobot *r2 = [boxRobot new];

  [r2 setPos:1.0:0.0:1.0];
  [self addObject:r2];

  boxRobot *r3 = [boxRobot new];

  [r3 setPos:-1.0:0.0:-1.0];

  [self addObject:r3];

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
  glRotatef(10, 1.0, 0.0, 0.0);
  glTranslatef(0.0, -1.0, -10.0);

  for (int i = 0; i < objNum; i++){
    [drawTargets[i] draw];
  }

  glFlush();

}

@end
