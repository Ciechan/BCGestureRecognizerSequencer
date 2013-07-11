//
//  BCGestureRecognizerSequencer.h
//
//  Created by Bartosz Ciechanowski on 11.07.2013.
//  Copyright (c) 2013 Bartosz Ciechanowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCGestureRecognizerSequencer;


// The first step in the sequence has index 0
@protocol BCGestureRecognizerSequencerDelegate <NSObject>
@optional

- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didRecognizeSequenceStep:(NSUInteger)step;

- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didTimeOutOnSequenceStep:(NSUInteger)step;
- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didCancelOnSequenceStep:(NSUInteger)step;

// If delegate implements 'gestureRecognizerSequencer:intervalBeforeStep:', then 'stepInterval' property is ignored
// This method will never be called for 0th step
- (NSTimeInterval)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer intervalBeforeStep:(NSUInteger)step;

@end


@interface BCGestureRecognizerSequencer : NSObject

@property (nonatomic, weak) id<BCGestureRecognizerSequencerDelegate> delegate;

@property (nonatomic, copy) NSArray *gestureRecognizers;
@property (nonatomic) NSTimeInterval stepInterval; // defaults to 2.0 seconds
@property (nonatomic, readonly) NSUInteger recognizedSteps;

- (id)initWithGestureRecognizers:(NSArray *)gestureRecognizers;

- (void)reset;

@end
