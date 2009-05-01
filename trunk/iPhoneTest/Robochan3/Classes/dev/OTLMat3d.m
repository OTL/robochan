/** 
 * @file OTLMat3d.m
 * @brief 3ŸŒ³s—ñŒvZ
 *
 * @author Takashi Ogura
 * @date 2009/03/01
 * @version 0.0.1
*/

#import "OTLMat3d.h"
#import "math.h"

@implementation OTLMat3d
	
- (id) initWithArray:(float *)ar
{
  [self set:ar];
}
	
- (float) get:(int)index
{
  switch( index ) {
  case 11: return n11;
  case 12: return n12;
  case 13: return n13;
  case 14: return n14;
  case 21: return n21;
  case 22: return n22;
  case 23: return n23;
  case 24: return n24;
  case 31: return n31;
  case 32: return n32;
  case 33: return n33;
  case 34: return n34;
  case 41: return n41;
  case 42: return n42;
  case 43: return n43;
  case 44: return n44;
  }
  return 0;
}
	
- (void) set:(int) index: (floa)t n
{
  switch( index ) {
  case 11: n11 = n; break;
  case 12: n12 = n; break;
  case 13: n13 = n; break;
  case 14: n14 = n; break;
  case 21: n21 = n; break;
  case 22: n22 = n; break;
  case 23: n23 = n; break;
  case 24: n24 = n; break;
  case 31: n31 = n; break;
  case 32: n32 = n; break;
  case 33: n33 = n; break;
  case 34: n34 = n; break;
  case 41: n41 = n; break;
  case 42: n42 = n; break;
  case 43: n43 = n; break;
  case 44: n44 = n; break;
  }		
}
	
- (void) set:(float *)ar
{
  n11 = ar[0]; n12 = ar[1]; n13 = ar[2]; n14 = ar[3];
  n21 = ar[4]; n22 = ar[5]; n23 = ar[6]; n24 = ar[7];
  n31 = ar[8]; n32 = ar[9]; n33 = ar[10]; n34 = ar[11];
  n41 = ar[12]; n42 = ar[13]; n43 = ar[14]; n44 = ar[15];
}
	
- (float *) get
{
  float* a;
  a = (float *)malloc(sizeof(float)*16);
  a[0] = n11;
  a[1] = n12;
  a[2] = n13;
  a[3] = n14;
  a[4] = n21;
  a[5] = n22;
  a[6] = n23;
  a[7] = n24;
  a[8] = n31;
  a[9] = n32;
  a[10] = n33;
  a[11] = n34;
  a[12] = n41;
  a[13] = n42;
  a[14] = n43;
  a[15] = n44;
  return a;
}

- (void)calc:(OTLMat3d)a:(OTLMat3d)b
{
  float *m1 = [a get];
  float *m2 = [b get];
  float r[16];
		
  for( int j = 0; j < 4; ++ j ) {
    for( int i = 0; i < 4; ++ i ) {
      int n = 4*j;
      r[n+i] = m1[n]*m2[i]+m1[n+1]*m2[4+i]+m1[n+2]*m2[8+i]+m1[n+3]*m2[12+i];
    }
  }
  free(m1);
  free(m2);
  [self set:r];
}
	
	//-----rotation
+ (OTLMat3d *) euler2Quaternion:(float) ax: (float) ay: (float) az
{		
  float sinX = (float)sin(ax/2);
  float cosX = (float)cos(ax/2);
  float sinY = (float)sin(ay/2);
  float cosY = (float)cos(ay/2);
  float sinZ = (float)sin(-az/2);
  float cosZ = (float)cos(-az/2);
  float a = sinY * sinX;
  float b = cosY * cosX;
  float c = sinY * cosX;
  float d = cosY * sinX;
		
  OTLMat3d *m = [OTLMat3d new];
		
  [m set:11: cosZ * d - sinZ * c];
  [m set:12: sinZ * d + cosZ * c];
  [m set:13: sinZ * b - cosZ * a];
  [m set:14: cosZ * b + sinZ * a];
  
  return m;
}
	
+	(OTLMat3d *)quaternion2Euler:(float) x: (float) y: (float) z: (float) w
{
  float n = 0;
  float xx = x * x;
  float xy = x * y;
  float xz = x * z;
  float xw = x * w;
	
  float yy = y * y;
  float yz = y * z;
  float yw = y * w;
	
  float zz = z * z;
  float zw = z * w;
		
  OTLMat3d *m = [OTLMat3d new];
		
  [m set:11: 1 - 2 * (yy + zz)];
  [m set:12: 2 * (xy - zw)];
  [m set:13: 2 * (xz + yw)];
  [m set:21: 2 * (xy + zw)];
  [m set:22: 1 - 2 * (xx + zz)];
  [m set:23: 2 * (yz - xw)];
  [m set:31: 2 * (xz - yw)];
  [m set:32: 2 * (yz + xw)];
  [m set:33: 1 - 2 * (xx + yy)];
  
  for( int i = 1; i < 4; ++ i ) {
    for( int j = 1; j < 4; ++ j ) {
      n = [m get:i * 10 + j];
      if( abs(n) < 1.0e-6 ) [m set:i * 10 + j, 0.0f];
    }
  }
	
  return m;
}
	
@end
