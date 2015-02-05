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
@property (nonatomic, weak) IBOutlet UIView *keyboardInputView;
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

@property (nonatomic, weak) IBOutlet UIButton *shiftKey;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

#pragma mark - Life Cycle

- (id)init
{
    self = [super initWithNibName:@"KeyboardViewController" bundle:nil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeKeyboardView];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGFloat _expandedHeight = CGRectGetHeight(self.view.frame) + 60;
    NSLayoutConstraint *_heightConstraint =
    [NSLayoutConstraint constraintWithItem: self.view
                                 attribute: NSLayoutAttributeHeight
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: nil
                                 attribute: NSLayoutAttributeNotAnAttribute
                                multiplier: 0.0
                                  constant: _expandedHeight];
    [self.view addConstraint: _heightConstraint];
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

- (UIView *)inputAccessoryView
{
    
    return nil;
}

#pragma mark - Initialization
- (void)initializeKeyboardView
{
    [self initShiftKeyStatus];
    [self shiftKeys];

    UITapGestureRecognizer *doubleTapOnShiftKey = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shiftKeyDoubleTapped)];
    doubleTapOnShiftKey.numberOfTapsRequired = 2;
    [self.shiftKey addGestureRecognizer:doubleTapOnShiftKey];
    
}

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
    if (self.shiftStatus == ShiftStatusCapslock) {
        self.shiftStatus = ShiftStatusOff;
    }
    else {
        self.shiftStatus = (self.shiftStatus == ShiftStatusOn) ? ShiftStatusOff : ShiftStatusOn;
    }
    [self updateShiftKeyStatus];
    [self shiftKeys];
}

- (void)shiftKeyDoubleTapped
{
    self.shiftStatus = ShiftStatusCapslock;
    [self updateShiftKeyStatus];
    [self shiftKeys];
}

- (IBAction)returnKeyPressed:(id)sender
{
    [self.textDocumentProxy insertText:@"\n"];
}


#pragma mark - Helper

- (void)initShiftKeyStatus
{
    switch (self.textDocumentProxy.autocapitalizationType) {
        case UITextAutocapitalizationTypeNone:
            self.shiftStatus = ShiftStatusOff;
            break;
        case UITextAutocapitalizationTypeWords:
            self.shiftStatus = ShiftStatusOn;
            break;
        case UITextAutocapitalizationTypeSentences:
            self.shiftStatus = ShiftStatusOn;
            break;
        case UITextAutocapitalizationTypeAllCharacters:
            self.shiftStatus = ShiftStatusCapslock;
            break;
    }
    [self updateShiftKeyStatus];
}

- (void)updateShiftKeyStatus
{
    switch (self.shiftStatus) {
        case ShiftStatusOn:
            [self.shiftKey setImage:[UIImage imageNamed:@"shiftKey_on"] forState:UIControlStateNormal];
            break;
        case ShiftStatusOff:
            [self.shiftKey setImage:[UIImage imageNamed:@"shiftKey_off"] forState:UIControlStateNormal];
            break;
        case ShiftStatusCapslock:
            [self.shiftKey setImage:[UIImage imageNamed:@"capslock"] forState:UIControlStateNormal];
            break;
    }
}

- (void)shiftKeys
{
    if (self.shiftStatus == ShiftStatusOn || self.shiftStatus == ShiftStatusCapslock) {
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
