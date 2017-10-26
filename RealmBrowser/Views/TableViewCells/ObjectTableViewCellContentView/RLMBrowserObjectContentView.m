//
//  RLMBrowserObjectView.m
//  RealmBrowser
//
//  Created by Tim Oliver on 12/9/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "RLMBrowserObjectContentView.h"

@interface RLMBrowserObjectContentView ()

@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) IBOutlet UILabel *propertyNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *propertyStatsLabel;
@property (nonatomic, strong) IBOutlet UILabel *objectValueLabel;
@property (nonatomic, strong, readwrite) IBOutlet UIButton *quickLookButton;
@property (nonatomic, strong) IBOutlet UILabel *nilLabel;

@end

@implementation RLMBrowserObjectContentView

+ (instancetype)objectContentView
{
    RLMBrowserObjectContentView *contentView = [[[NSBundle mainBundle] loadNibNamed:@"RLMBrowserObjectContentView" owner:nil options:nil] firstObject];
    contentView.propertyStatsLabel.hidden = YES;
    contentView.propertyStats = nil;
    return contentView;
}

- (void)setUp
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect frame = self.propertyNameLabel.frame;
    frame.size.width = [self.propertyNameLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
    self.propertyNameLabel.frame = frame;

    if (self.propertyStats.length) {
        frame = self.propertyStatsLabel.frame;
        frame.origin.x = CGRectGetMaxX(self.propertyNameLabel.frame) + 5.0f;
        frame.size.width = [self.propertyStatsLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].width;
        self.propertyStatsLabel.frame = frame;
        self.propertyStatsLabel.hidden = NO;
    }
    else {
        self.propertyStatsLabel.hidden = YES;
    }

    frame = self.objectValueLabel.frame;
    frame.size.width = CGRectGetMinX(self.quickLookButton.frame) - frame.origin.x;
    self.objectValueLabel.frame = frame;
}

#pragma mark - Accessor Overrides -

- (void)setPropertyName:(NSString *)propertyName
{
    self.propertyNameLabel.text = propertyName;
    [self setNeedsLayout];
}

- (NSString *)propertyName
{
    return self.propertyNameLabel.text;
}

- (void)setPropertyStats:(NSString *)propertyStats
{
    self.propertyStatsLabel.text = propertyStats;
    [self setNeedsLayout];
}

- (NSString *)propertyStats
{
    return self.propertyStatsLabel.text;
}

- (void)setObjectValue:(NSString *)objectValue
{
    self.objectValueLabel.text = objectValue;
    [self setNeedsLayout];
}

- (NSString *)objectValue
{
    return self.objectValueLabel.text;
}

- (void)setIconImage:(UIImage *)iconImage
{
    self.iconView.image = iconImage;
}

- (UIImage *)iconImage
{
    return self.iconView.image;
}

- (void)setIconColor:(UIColor *)iconColor
{
    self.iconView.tintColor = iconColor;
}

- (UIColor *)iconColor
{
    return self.iconView.tintColor;
}

- (void)setQuickLookIcon:(UIImage *)quickLookIcon
{
    [self.quickLookButton setImage:quickLookIcon forState:UIControlStateNormal];
}

- (UIImage *)quickLookIcon
{
    return [self.quickLookButton imageForState:UIControlStateNormal];
}

- (void)setNilValue:(BOOL)nilValue
{
    self.nilLabel.hidden = !nilValue;
    self.objectValueLabel.hidden = nilValue;
}

- (BOOL)nilValue
{
    return !self.nilLabel.hidden;
}

#pragma mark - UIMenuItem -
- (void)showCopyButton
{
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyValueToClipboard)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    menuController.menuItems = @[copyItem];
    [menuController update];

    [self becomeFirstResponder];

    [menuController setTargetRect:self.frame inView:self.superview];
    [menuController setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (@selector(copyValueToClipboard) == action);
}

- (void)copyValueToClipboard
{
    [UIPasteboard generalPasteboard].string = self.objectValue;
}

@end