/**
 * @file NSObject.m
 * @brief NSObjectのふりをする
 *
 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

#import "NSObject.h"

@implementation NSObject
- (void) release
{
  [self dealloc];
}

- (void) deaaloc
{
  [self free];
}

@end
