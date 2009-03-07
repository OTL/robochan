/** @file drawableObject.m
 @brief drawableObjectクラス
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/


/* $Id:$ */

#import "drawableObject.h"

@implementation drawableObject

/** 初期化
 *
 * @retval [super init] 
 */
- (id)init
{
//   pos = (float *)malloc(sizeof(float)*3);
//   rot = (float *)malloc(sizeof(float)*4);

  for (int i = 0; i < 3; i++){
    pos[i] = 0;
  }
  rot[0]=0;
  rot[1]=0;
  rot[2]=1;
  rot[3]=0;

  return([super init]);
}

/** 物体の位置を指定する
 *
 * @param x X軸位置
 * @param y Y軸位置
 * @param z Z軸位置
 */
- (void)setPos:(float)x:(float)y:(float)z
{
  pos[0] = x;
  pos[1] = y;
  pos[2] = z;
}


/** 物体の姿勢を指定する
 *
 * @param [in] t 回転角度
 * @param [in] x 軸1
 * @param [in] y 軸2
 * @param [in] z 軸3
 */
- (void)setRot:(float)t:(float)x:(float)y:(float)z
{
  rot[0] = t;
  rot[1] = x;
  rot[2] = y;
  rot[3] = z;
}

/** 描画メソッド
 *
 * worldクラスから呼び出される
 * 位置を指定し、drawShapeメソッドを呼び出し形状を描画する。
 * OpenGL ESを前提としている。
 */
- (void)draw
{
  glPushMatrix();
  glTranslatef(pos[0], pos[1], pos[2]);
  glRotatef(rot[0], rot[1], rot[2], rot[3]);

  [self drawShape];

  glPopMatrix();
}

/** 形状の描画：サブクラスでオーバーライドすること
 *
 * サブクラスでオーバーライドされる
 *
 */
- (void)drawShape
{
  //形状の描画：サブクラスでオーバーライドすること
}

// - (void)dealloc
// {
//   [super dealloc];
//   free(pos);
//   free(rot);
// }

@end
