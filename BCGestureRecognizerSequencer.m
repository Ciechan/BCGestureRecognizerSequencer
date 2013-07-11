//
//  BCGestureRecognizerSequencer.m
//
//  Created by Bartosz Ciechanowski on 09.07.2013.
//  Copyright (c) 2013 Bartosz Ciechanowski. All rights reserved.
//

#import "BCGestureRecognizerSequencer.h"

@interface BCGestureRecognizerSequencer()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, readwrite) NSUInteger recognizedSteps;

@end


@implementation BCGestureRecognizerSequencer

- (id)init
{
    return [self initWithGestureRecognizers:nil];
}

- (id)initWithGestureRecognizers:(NSArray *)gestureRecognizers
{
    self = [super init];
    if (self) {
        self.stepInterval = 2.0;
        self.gestureRecognizers = gestureRecognizers;
    }
    return self;
}

- (void)dealloc
{
    [self stopTimeoutTimer];
    self.gestureRecognizers = nil; // will unregister from events
}


- (void)reset
{
    [self stopTimeoutTimer];
    self.recognizedSteps = 0;
}

#pragma mark - Recognizers management

- (void)setGestureRecognizers:(NSArray *)gestureRecognizers
{
    [self unregisterFromGestureRecognizers:_gestureRecognizers];
    _gestureRecognizers = [gestureRecognizers copy];
    [self registerToGestureRecognizers:_gestureRecognizers];
}


- (void)registerToGestureRecognizers:(NSArray *)gestureRecognizers
{
    for (UIGestureRecognizer *recognizer in gestureRecognizers) {
        [recognizer addTarget:self action:@selector(gestureRecognized:)];
    }
}

- (void)unregisterFromGestureRecognizers:(NSArray *)gestureRecognizers
{
    for (UIGestureRecognizer *recognizer in gestureRecognizers) {
        [recognizer removeTarget:self action:@selector(gestureRecognized:)];
    }
}

#pragma mark - Timer management

- (void)startTimeoutTimer
{
    if (self.stepInterval == HUGE_VAL) {
        return;
    }
    
    self.timer = [NSTimer timerWithTimeInterval:self.stepInterval
                                         target:self
                                       selector:@selector(timerFired:)
                                       userInfo:nil
                                        repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimeoutTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerFired:(NSTimer *)sender
{
    self.timer = nil;
    if ([self.delegate respondsToSelector:@selector(gestureRecognizerSequencer:didTimeOutOnSequenceStep:)]) {
        [self.delegate gestureRecognizerSequencer:self didTimeOutOnSequenceStep:self.recognizedSteps];
    }
    [self reset];
}


#pragma mark - Recognizers events handling

- (void)gestureRecognized:(UIGestureRecognizer *)sender
{
    NSUInteger index = [self.gestureRecognizers indexOfObject:sender]; // O(n), but who cares in this case?
    
    if (index != self.recognizedSteps) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateCancelled) {
        if ([self.delegate respondsToSelector:@selector(gestureRecognizerSequencer:didCancelOnSequenceStep:)]) {
            [self.delegate gestureRecognizerSequencer:self didCancelOnSequenceStep:self.recognizedSteps];
        }
        [self reset];
        return;
    }
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        // we don't want to timeout on stuff like UILongPressGestureRecognizer, when it's still possible to recognize
        [self stopTimeoutTimer];
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateRecognized) {
        [self stopTimeoutTimer];
        if ([self.delegate respondsToSelector:@selector(gestureRecognizerSequencer:didRecognizeSequenceStep:)]) {
            [self.delegate gestureRecognizerSequencer:self didRecognizeSequenceStep:self.recognizedSteps];
        }
        self.recognizedSteps++;

        if (self.recognizedSteps == self.gestureRecognizers.count) {
            [self reset];
        } else {
            [self startTimeoutTimer];
        }
    }
}



@end
