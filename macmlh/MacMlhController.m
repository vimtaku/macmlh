//
//  MacmlhController.m
//  macmlh
//
//  Created by vimtaku on 2014/05/05.
//  Copyright (c) 2014年 vimtaku. All rights reserved.
//

#import "MacMlhController.h"


@implementation MacMlhController


-(BOOL)inputText:(NSString*)string client:(id)sender
{
    //Return YES to indicate the the key input was received and dealt with.  Key processing will not continue in that case.  In
    //other words the system will not deliver a key down event to the application.
    //Returning NO means the original key down will be passed on to the client.
    NSLog(@"%@", string);
    return NO;
}


@end
