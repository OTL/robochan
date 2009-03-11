/** 
 * @file OTLObjObject.m
 * @brief OTLObjObjectクラス
 *
 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

/*  $Id:$ */

#import "OTLObjObject.h"

@implementation OTLObjObject

/** @brief 初期化
 *
 * デフォルトの高さで初期化する
 *
 * @retval self 
 */
- (id) init
{
  [super init];
  //とりあえずフルパスじゃないとだめっぽい
  //model = glmReadOBJ("/Applications/Robochan.app/hoge.obj");
  model = glmReadOBJ("/Applications/Robochan.app/face.obj");
  glmScale(model, 0.2);
  //glmReverseWinding(model);
  return (self);
}


/**
 * 形状を描く
 */
- (void) drawShape
{
  //glmDraw(model, GLM_FLAT | GLM_SMOOTH);
  glmDraw(model,GLM_SMOOTH);
  //glmDraw(model, GLM_SMOOTH | GLM_COLOR);
}

/**
 * モデルの削除
 */
- (void)dealloc
{
  glmDelete(model);
  [super dealloc];
}


/**
 * @brief デバッグ用
 *
 */
- (int)getData:(int*)a:(float*)b:(float*)c:(float*)d
{
  *a = (int)model->numvertices;
  *b = (float)model->position[0];
  *c = (float)model->position[1];
  *d = (float)model->position[2];
  return (model->numvertices);
}
@end
