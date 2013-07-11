//
//  BCGestureRecognizerSequencer.h
//
//  Created by Bartosz Ciechanowski on 09.07.2013.
//  Copyright (c) 2013 Bartosz Ciechanowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCGestureRecognizerSequencer;

@protocol BCGestureRecognizerSequencerDelegate <NSObject>
@optional

- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didRecognizeSequenceStep:(NSUInteger)step;

- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didTimeOutOnSequenceStep:(NSUInteger)step;
- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didCancelOnSequenceStep:(NSUInteger)step;

@end


@interface BCGestureRecognizerSequencer : NSObject

@property (nonatomic, weak) id<BCGestureRecognizerSequencerDelegate> delegate;

@property (nonatomic, copy) NSArray *gestureRecognizers;
@property (nonatomic) NSTimeInterval stepInterval; // defaults to 2.0 seconds, passing HUGE_VAL disables timeout timer
@property (nonatomic, readonly) NSUInteger recognizedSteps;

- (id)initWithGestureRecognizers:(NSArray *)gestureRecognizers;

- (void)reset;

@end
