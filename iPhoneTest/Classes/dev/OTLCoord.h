/** @file OTLCoord.h
 @brief 3éüå≥ç¿ïWån
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <Foundation/Foundation.h>

@interface OTLCoord : NSObject
{
@private
  float pos[3];
  float rot[3];

  BOOL update = YES;
}

@end
