//
//  KeyboardViewController.m
//  TranslateKeyboard
//
//  Created by ThuyLuong on 2/3/15.
//  Copyright (c) 2015 ThuyLuong. All rights reserved.
//

#import "KeyboardViewController.h"


typedef NS_ENUM(NSUInteger, ShiftStatus)
{
    ShiftStatusOn,
    ShiftStatusOff,
    ShiftStatusCapslock
};

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;

@property (nonatomic, assign) ShiftStatus shiftStatus;

// IBOutlet
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *letterButtonsCollection;
@property (nonatomic, weak) IBOutlet UIView *letterRow1;
@property (nonatomic, weak) IBOutlet UIView *letterRow2;
@property (nonatomic, weak) IBOutlet UIView *letterRow3;

@property (nonatomic, weak) IBOutlet UIView *numberRow1;
@property (nonatomic, weak) IBOutlet UIView *numberRow2;
@property (nonatomic, weak) IBOutlet UIView *symbolRow1;
@property (nonatomic, weak) IBOutlet UIView *symbolRow2;
@property (nonatomic, weak) IBOutlet UIView *numberSymbolRow3;

@property (nonatomic, weak) IBOutlet UIView *functionRow4;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
//    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
//    [self.nextKeyboardButton sizeToFit];
//    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:self.nextKeyboardButton];
//    
//    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
//    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
//    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}


#pragma mark - UITextInputDelegate

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

#pragma mark - Initialization


#pragma mark - Action

- (IBAction)keyPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.textDocumentProxy insertText:button.titleLabel.text];
}

- (IBAction)globalKeyPressed:(id)sender
{
    [self advanceToNextInputMode];
}

- (IBAction)backSpaceKeyPressed:(id)sender
{
    [self.textDocumentProxy deleteBackward];
}

- (IBAction)spaceKeyPressed:(id)sender
{
    [self.textDocumentProxy insertText:@" "];
}

- (IBAction)shiftKeyPressed:(id)sender
{
    self.shiftStatus = (self.shiftStatus == ShiftStatusOn) ? ShiftStatusOff : ShiftStatusOn;
    [self shiftKeys];
}

- (void)shiftKeyDoubleTapped
{
    self.shiftStatus = ShiftStatusCapslock;
    [self shiftKeys];
}

- (IBAction)returnKeyPressed:(id)sender
{
    [self.textDocumentProxy insertText:@"\n"];
}


#pragma mark - Helper

- (void)shiftKeys
{
    if (self.shiftStatus == ShiftStatusOn) {
        for (UIButton* letterButton in self.letterButtonsCollection) {
            [letterButton setTitle:letterButton.titleLabel.text.uppercaseString forState:UIControlStateNormal];
        }
    } else {
        for (UIButton* letterButton in self.letterButtonsCollection) {
            [letterButton setTitle:letterButton.titleLabel.text.lowercaseString forState:UIControlStateNormal];
        }
    }
}



@end
