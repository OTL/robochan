/** 
 @file OTLRobochanViewController.h
 @brief ������Ԃŕ\������View
 @author Takashi Ogura
 @date 2009/03/01
 @version 0.0.1
*/

/* $Id:$ */

#import <UIKit/UIKit.h>

/** @brief ������Ԃŕ\������ViewController�N���X
 *
 */
@class OTLKHRInterface;

@interface OTLTestViewController : UIViewController{
  /// ���{�b�g(KHR-2HV)����C���^�t�F�[�X
  OTLKHRInterface *ki;
}

/// �Z�O�����g�R���g���[���̃C�x���g�n���h��
- (void)sendCommand:(id)sender;
/// �Z�O�����g�R���g���[����ǉ�
- (void)addSegment;

@end

