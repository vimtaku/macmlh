//
//  MacmlhController.m
//  macmlh
//
//  Created by vimtaku on 2014/05/05.
//  Copyright (c) 2014年 vimtaku. All rights reserved.
//

#import "MacMlhController.h"
/////#import "NSText.h"


@interface MacMlhController()

@property(nonatomic, readonly) NSMutableString* originalBuffer;
@property(nonatomic, readonly) NSMutableString* composedBuffer;
@property(nonatomic, readonly) id currentClient; // _currentClient

@property(readonly) int insertionIndex;


@end


@implementation MacMlhController

- (id)init {
    self = [super init];
    if (!self){
        return nil;
    }
    // 初期化
    _originalBuffer = [[NSMutableString alloc] initWithString:@""];
    _composedBuffer = [[NSMutableString alloc] initWithString:@""];

    return self;
}


-(BOOL)inputText:(NSString*)string client:(id)sender
{
    NSLog(@"%@", string);
    BOOL inputHandled = FALSE;
    extern IMKCandidates* candidates;

    /* if ([string hasPrefix:@"o"]) { */
    /*     [sender insertText: replacementRange:NSMakeRange(NSNotFound, NSNotFound)]; */
    /*     return NO; */
    /* } */

    if ([string hasPrefix:@" "]) {
        NSLog(@"string is '%@'", string);
        NSLog(@"originalBuffer is '%@'", _originalBuffer);

        if ([_originalBuffer hasSuffix:@"/"]) {

//NSMutableString* del = [[NSMutableString alloc] initWithString:@""];
            /* unichar theChar = 0x000D; */
            /* NSString* thestring = [NSStirng stringWithCharacters:&theChar length:1]; */
            /* for (int i = 0, len = [_originalBuffer length]; i < len; i++) { */
            /*     //[sender insertText:@"" replacementRange:NSMakeRange(NSNotFound, NSNotFound)]; */
            /*     [sender insertText:thestring replacementRange:NSMakeRange(NSNotFound, NSNotFound)]; */
            /* } */

            NSLog(@"変換開始");
            _currentClient = sender;
            [candidates updateCandidates];
            [candidates show:kIMKLocateCandidatesBelowHint];
        }
        else {
            [candidates setDismissesAutomatically:YES];
            NSLog(@"バッファクリア");
            _originalBuffer = [[NSMutableString alloc] initWithString:@""];
            _composedBuffer = [[NSMutableString alloc] initWithString:@""];
        }
        return YES;
    }

    [self originalBufferAppend:string client:sender];
    return NO;
}

// Change the composed buffer.
-(void)setComposedBuffer:(NSString*)string
{
    NSMutableString* buffer = [self composedBuffer];
    [buffer setString:string];
}
// Change the original buffer.
-(void)setOriginalBuffer:(NSString*)string
{
    NSMutableString* buffer = [self originalBuffer];
    [buffer setString:string];
}

// Add newly input text to the original buffer.
-(void)originalBufferAppend:(NSString*)string client:(id)sender
{
    NSMutableString* buffer = [self originalBuffer];
    [buffer appendString: string];
    _insertionIndex++;
    [sender setMarkedText:buffer selectionRange:NSMakeRange(0, [buffer length])
         replacementRange:NSMakeRange(NSNotFound, NSNotFound)];
}



// This method is called to see if your input method handles an NSResponder action.
-(BOOL)didCommandBySelector:(SEL)aSelector client:(id)sender
{
    if ([self respondsToSelector:aSelector]) {
        // The NSResponder methods like insertNewline: or deleteBackward: are
        // methods that return void. didCommandBySelector method requires
        // that you return YES if the command is handled and NO if you do not.
        // This is necessary so that unhandled commands can be passed on to the
        // client application. For that reason we need to test in the case where
        // we might not handle the command.

        // The test here is simple.  Test to see if any text has been aded to the original buffer.

        NSString* bufferedText = [self originalBuffer];
        if ( bufferedText && [bufferedText length] > 0 ) {
            if (aSelector == @selector(insertNewline:))
            {
                [self performSelector:aSelector withObject:sender];
                return YES;
            }
        }

    }

    return NO;
}


// When a new line is input we commit the composition.
- (void)insertNewline:(id)sender
{
    [self commitComposition:sender];
}

/* -(void)deleteBackward:(id)sender */
/* { */
/* //#[sender deleteBackward]; */
/*     NSLog(@"BackSpace Detected"); */
/* } */


-(void)commitComposition:(id)sender
{
    NSString* text = [self composedBuffer];
    if ( text == nil || [text length] == 0 ) {
        text = [self originalBuffer];
    }

    [sender insertText:text replacementRange:NSMakeRange(NSNotFound, NSNotFound)];

    _originalBuffer = [[NSMutableString alloc] initWithString:@""];
    _composedBuffer = [[NSMutableString alloc] initWithString:@""];
    _insertionIndex = 0;
}


- (void)candidateSelectionChanged:(NSAttributedString*)candidateString
{
    [_currentClient setMarkedText:[candidateString string]
                   selectionRange:NSMakeRange(_insertionIndex, 0)
                 replacementRange:NSMakeRange(NSNotFound,NSNotFound)];
    _insertionIndex = [candidateString length];
}


/*!
    @method
    @abstract   Called when a new candidate has been finally selected.
    @discussion The candidate parameter is the users final choice from the candidate window.
    The candidate window will have been closed before this method is called.
*/
- (void)candidateSelected:(NSAttributedString*)candidateString
{
    [self setComposedBuffer:[candidateString string]];
    [self commitComposition:_currentClient];
}



- (NSArray*)candidates:(id)sender {
    return @[_originalBuffer, _originalBuffer];
}

@end
