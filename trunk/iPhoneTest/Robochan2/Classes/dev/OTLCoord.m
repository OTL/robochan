/** 
 * @file OTLCoord.m
 * @brief 3éüå≥ç¿ïWån
 *
 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

#import "OTLCoord.h"
#import "math.h"


@implementation OTLCoord

/* private */	
- (void)update
{
  if (update)
  {
    [self updateTransform];
  }
}

/* public */
- (void)reset
{
  for (int i = 0; i < 3; i++)
  {
    pos[i] = 0;
    rot[i] = 0;
  }
  update = YES;
}

- (void) setPos(float *p)
{
  for (int i = 0; i < 3; i++)
  {
    pos[i] = p[i];
  }
  update = YES;
}

- (void) setRot(float *r)
{
  for (int i = 0; i < 3; i++)
  {
    rot[i] = r[i];
  }
  update = YES;
}


- (void) getPos(float *p)
{
  for (int i = 0; i < 3; i++)
  {
    p[i] = pos[i];
  }
}

- (void) getRot(float *r)
{
  for (int i = 0; i < 3; i++)
  {
    r[i] = rot[i];
  }
}

- (void) updateTransform
{
  OTLMat3d *m = [OTLMat3d euler2Quaternion:rot[0]:rot[1]:rot[2]];
  m = [OTLMat3d quaternion2Euler:[m get:11]:[m get:12]: [m get:13]: [m get:14]];
  [m set:44: 1.0f];
  
  OTLMat3d transform = [OTLMat3d initWithArray:OTLMAT3D_IDENTITY];
  [transform set:41:pos[0]];
  [transform set:42:pos[1]];
  [transform set:43:pos[2]];
  [transform calc:m:transform];
		
  OTLMat3d vertexM = [new Matrix3D();
  Matrix3D r = new Matrix3D();
		vertexM.set(14, 1.0f);
		for( int i = 0; i < mVertexBuffer.capacity(); i += 3 ) {
			vertexM.set(11, (float)mVertexBuffer.get(i));
			vertexM.set(12, (float)mVertexBuffer.get(i+1));
			vertexM.set(13, (float)mVertexBuffer.get(i+2));
						
			r.calc(vertexM, this.transform);
			
			mTransformBuffer.put(i, (int)r.get(11));
			mTransformBuffer.put(i+1, (int)r.get(12));
			mTransformBuffer.put(i+2, (int)r.get(13));;
		}
		
		transformDirty = false;
	}

@end

