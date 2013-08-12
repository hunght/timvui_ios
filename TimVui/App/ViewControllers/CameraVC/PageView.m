
#import "PageView.h"

@implementation PageView

-(void)setName:(NSString*)name andAddress:(NSString*)address{
    
}

- (UIImage*)mergeSkinWithImage:(UIImage *)bottomImage{
    
    return bottomImage;
}
- (void)setTextForSkin:(UILabel *)lbl fontText:(int)fontText sizeBottomImage:(CGSize)size {
    [lbl.textColor set];
    int textSize=fontText*(size.width/320);
    CGRect rectView=lbl.frame;
    UIFont *font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(textSize)];
    CGRect rect = CGRectMake(rectView.origin.x*size.width/320, rectView.origin.y*size.width/320, rectView.size.width*size.width/320, rectView.size.height*size.width/320);
    
    [ lbl.text drawInRect : CGRectIntegral(rect)                      // render the text
                 withFont : font
            lineBreakMode : lbl.lineBreakMode  // clip overflow from end of last line
                alignment : lbl.textAlignment ];
}

- (void)settingView{
}
@end
