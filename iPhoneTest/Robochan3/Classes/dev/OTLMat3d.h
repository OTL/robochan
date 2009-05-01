/** @file OTLMat3d.h
 @brief 3éüå≥çsóÒåvéZ
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/*  $Id:$ */

#import <Foundation/Foundation.h>

static const float[] OTLMAT3D_IDENTITY = {1.0f, 0, 0, 0,
                                 0, 1.0f, 0, 0,
                                 0, 0, 1.0f, 0,
                                 0, 0, 0, 1.0f};

@interface OTLMat3d : NSObject
{
@private
  float n11 = 0;
	float n12 = 0;
	float n13 = 0;
	float n14 = 0;
	float n21 = 0;
	float n22 = 0;
	float n23 = 0;
	float n24 = 0;
	float n31 = 0;
	float n32 = 0;
	float n33 = 0;
	float n34 = 0;
	float n41 = 0;
	float n42 = 0;
	float n43 = 0;
	float n44 = 0;
}

@end
