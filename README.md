BCGestureRecognizerSequencer
==========

BCGestureRecognizerSequencer provides a simple way to detect sequence of gestures, like left swipe followed by right swipe or tap followed by long press.

BCGestureRecognizerSequencer has a notion of step interval - maximum elapsed time between consecutive gesture recognition. It provides delegate methods for sequence steps recognitions, timeouts and cancelation - see the header file for details, or checkout the demo project.

## How To Use

### Adding to project

Just drag BCGestureRecognizerSequencer.h and BCGestureRecognizerSequencer.m to your project.

### Setting up


- Setup some gesture recognizers

```objective-c
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] init];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    NSArray *gestureRecognizers = @[rightSwipeRecognizer, tapRecognizer];
    for (UIGestureRecognizer *recognizer in gestureRecognizers) {
        [targetView addGestureRecognizer:recognizer];
    }
```

- Create a strong reference to sequencer

```objective-c
@property (nonatomic, strong) BCGestureRecognizerSequencer *sequencer;
```



- Create sequencer instance

```objective-c
    self.sequencer = [[BCGestureRecognizerSequencer alloc] initWithGestureRecognizers:gestureRecognizers];
    self.sequencer.delegate = self;
```
- Implement some optional delegate methods (you probably want some of them)

```objective-c
- (void)gestureRecognizerSequencer:(BCGestureRecognizerSequencer *)sequencer didRecognizeSequenceStep:(NSUInteger)step
{
	if (step == sequencer.gestureRecognizers.count - 1) {
        NSLog(@"Entire sequence!);
    } else {
        NSLog(@"Work in progress!);
    }
}
```

## Extra info

- Gesture recognizers can be added to different views to create some epic sequences
- Setting `HUGE_VAL` as `stepInterval` disables the timer

## Requirements

- iOS 5.0
- ARC

## Contact

Bartosz Ciechanowski

[@BCiechanowski](https://twitter.com/BCiechanowski)

## License

BCGenieEffect is released under an MIT license.

Copyright (c) 2013 Bartosz Ciechanowski

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

