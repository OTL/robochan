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
  NSBundle* bundle;
  bundle = [NSBundle mainBundle];
  NSString* path;
  path = [bundle pathForResource:@"hoge" ofType:@"obj"];
  const char *cstr = [path UTF8String];
  model = glmReadOBJ((char *)cstr);
  //glmReverseWinding(model);
  return (self);
}

/** @brief ファイル名(拡張子を除く)をうけとり初期化
 *
 * @retval self 
 */
- (id) initWithFile: (NSString *)objFile
{
  [super init];
  NSBundle* bundle;
  bundle = [NSBundle mainBundle];
  NSString* path;
  path = [bundle pathForResource:objFile ofType:@"obj"];
  const char *cstr = [path UTF8String];
  model = glmReadOBJ((char *)cstr);
  //glmReverseWinding(model);
  return (self);
}

/**
 * @brief サイズをスケール倍する
 *
 **/

- (void) scale: (float)s
{
  glmScale(model, s);
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
