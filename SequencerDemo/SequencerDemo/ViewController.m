//
//  ViewController.m
//  SequencerDemo
//
//  Created by Bartosz Ciechanowski on 11.07.2013.
//  Copyright (c) 2013 Bartosz Ciechanowski. All rights reserved.
//

#import "ViewController.h"
#import "BCGestureRecognizerSequencer.h"

@interface ViewController () <BCGestureRecognizerSequencerDelegate>

@property (nonatomic, strong) BCGestureRecognizerSequencer *sequencer;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *stepLabels;
@property (weak, nonatomic) IBOutlet UIView *indicator;
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sorting labels in IBOutletCollection by x coordinate
    self.stepLabels = [self.stepLabels sortedArrayUsingComparator:^NSComparisonResult(UILabel *label1, UILabel *label2) {
        return label1.center.x < label2.center.x ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    // Setting up gesture recognizers
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    
    NSArray *gestureRecognizers = @[rightSwipeRecognizer, tapRecognizer, leftSwipeRecognizer, doubleTapRecognizer];
    for (UIGestureRecognizer *recognizer in gestureRecognizers) {
        [self.targetView addGestureRecognizer:recognizer];
    }
    
    // Sequencer configuration
    
    self.sequencer = [[BCGestureRecognizerSequencer alloc] initWithGestureRecognizers:gestureRecognizers];
    self.sequencer.delegate = self;
}

- (void)viewDidUnload {
    [self setStepLabels:nil];
    [self setTargetView:nil];
    [self setStatusLabel:nil];
    [self setIndicator:nil];
    [super viewDidUnload];
}


- (void)unhighlightLabels {
    for (UILabel *label in self.stepLabels) {
        label.highlighted = NO;
    }
}

#pragma mark - Gesture Reocgnizers actions

- (void)tapRecognized:(UIGestureRecognizer *)sender {
    // Gesture recgonizer can still send its actions
}

#pragma mark - BCGestureRecognizerSequencerDelegate methods

- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didRecognizeSequenceStep:(NSUInteger)step
{
    CGFloat offset = 0.0;
    if (step == sequencer.gestureRecognizers.count - 1) {
        self.statusLabel.text = @"Success!";
        [self unhighlightLabels];
    } else {
        self.statusLabel.text = @"Perform Gestures";
        [self.stepLabels[step] setHighlighted:YES];
        
        offset = (step + 1) * self.indicator.bounds.size.width;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicator.transform = CGAffineTransformMakeTranslation(offset, 0.0);
    }];
}

- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didTimeOutOnSequenceStep:(NSUInteger)step
{
    self.statusLabel.text = @"Timeout!";
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicator.transform = CGAffineTransformIdentity;
    }];
    [self unhighlightLabels];
}

- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didCancelOnSequenceStep:(NSUInteger)step
{
    self.statusLabel.text = @"Gesture Cancelled!";
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicator.transform = CGAffineTransformIdentity;
    }];
    [self unhighlightLabels];
}


@end
