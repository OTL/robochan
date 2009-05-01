@class UIImageView, UILabel, UIPushButton;

@interface UICalloutView : UIControl

- (UICalloutView *)initWithFrame:(struct CGRect)aFrame;
- (void)fadeOutWithDuration:(float)duration;
- (void)setTemporaryTitle:(NSString *)fp8;
- (NSString *)temporaryTitle;
- (void)setTitle:(NSString *)fp8;
- (NSString *)title;
- (void)addTarget:(id)target action:(SEL)selector;
- (void)removeTarget:(id)target;
- (void)setAnchorPoint:(struct CGPoint)aPoint boundaryRect:(struct CGRect)aRect animate:(BOOL)yorn;

@end

