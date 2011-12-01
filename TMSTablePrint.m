/*
  TMSTablePrint.m  

  Created by Michael Swan on 7/28/10.
  Copyright 2010 Michael S. Swan. All rights reserved.
  
 This is exactly the same license agreement that Matt Legend Gemmell uses on his source code. I choose it because I agree with his ideas on this stuff. Feel free to use this class/code as you want. If you use this class in your software I would love acknowledgment of that in your software (such as in the about panel). Of course you can't claim that I endorse or support your software, just that I provided a class for it.
 
 License Agreement for Source Code provided by Mike Swan
 
 This software is supplied to you by Mike Swan in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.
 
 In consideration of your agreement to abide by the following terms, and subject to these terms, Mike Swan grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Mike Swan as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Mike Swan may be used to endorse or promote products derived from the software without specific prior written permission from Mike Swan. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Mike Swan herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.
 
 The software is provided by Mike Swan on an "AS IS" basis. MIKE SWAN MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL MIKE SWAN BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF MIKE SWAN HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
#import "TMSTablePrint.h"

@interface TMSTablePrint ()
- (void) addCell:(NSString *)contents toTable:(NSTextTable *)table row:(NSInteger)row column:(NSInteger)column withAligment:(NSTextAlignment)aligment toText:(NSMutableAttributedString *)text;
@end

@implementation TMSTablePrint

@synthesize table;
@synthesize alignment;
@synthesize headerRow;
@synthesize headerColumn;
@synthesize alternateRows;
@synthesize alternateTextRows;
@synthesize usesColumnPercentages;
@synthesize rowColor;
@synthesize alternateRowColor;
@synthesize headerColor;
@synthesize headerTextStyle;
@synthesize rowTextStyle;
@synthesize alternateRowTextStyle;
@synthesize columnPercentages;

- (id)init {
    if ((self = [super init])) {
        table = [[NSTextTable alloc] init];
        [table setLayoutAlgorithm: NSTextTableAutomaticLayoutAlgorithm];
        [table setCollapsesBorders:YES];
        [table setHidesEmptyCells:NO];
        self.alignment = NSLeftTextAlignment;
        self.headerRow = YES;
        self.headerColumn = NO;
        self.alternateRows = YES;
        self.alternateTextRows = NO;
		self.usesColumnPercentages = NO;
        self.rowColor = [NSColor whiteColor];
        self.alternateRowColor = [NSColor lightGrayColor];
        self.headerColor = [NSColor lightGrayColor];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[NSFont systemFontOfSize:0] forKey:NSFontAttributeName];
        self.rowTextStyle = dict;
        self.alternateRowTextStyle = dict;
        NSFont *boldFont = [NSFont boldSystemFontOfSize:0];
        [dict setObject:boldFont forKey:NSFontAttributeName];
        self.headerTextStyle = dict;
    }
    return self;
}

#pragma mark layout
- (void) setLayout:(NSTextTableLayoutAlgorithm)layout {
    [table setLayoutAlgorithm:layout];
}

- (NSTextTableLayoutAlgorithm) layout {
    return [table layoutAlgorithm];
}

#pragma mark Primary Method
- (NSAttributedString *)attributedStringFromItems:(NSArray *)items {
	NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:@"\n"];
	NSAttributedString *returnString = [[NSAttributedString alloc] initWithString:@"\n"];
	// Determine what we need to set up with the table
    [table setNumberOfColumns:[[items objectAtIndex:0] count]];
    // Start adding all the data rows
    NSUInteger r = 0;
    NSUInteger c = 0;
	NSArray *anArray;
    for (anArray in items) {
        c = 0;
		// Step through each item and create a row from it
        for (NSString *string in anArray) {
            [self addCell:string toTable:table row:r column:c withAligment:alignment toText:result];
            c++;
        }
        r++;
    }
    [result appendAttributedString:returnString];
    return result;
}

#pragma mark support methods
- (void) addCell:(NSString *)contents toTable:(NSTextTable *)table row:(NSInteger)row column:(NSInteger)column withAligment:(NSTextAlignment)anAligment toText:(NSMutableAttributedString *)text {
	// Get the current end of the string
    NSUInteger textLength = [text length];
    // Set up a block
	NSTextTableBlock *block = [[NSTextTableBlock alloc] initWithTable:self.table startingRow:row rowSpan:1 startingColumn:column columnSpan:1];
    // Get the default paragraph style, maybe this should also be configurable
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	if (usesColumnPercentages) {
		[block setValue:[[columnPercentages objectAtIndex:column] floatValue] type:NSTextBlockPercentageValueType forDimension:NSTextBlockWidth];
	}
	// Set some block attributes. Should make these attributes customizable
	[block setWidth:0.0f type:NSTextBlockAbsoluteValueType forLayer:NSTextBlockBorder];
	[block setWidth:2.0f type:NSTextBlockAbsoluteValueType forLayer:NSTextBlockPadding edge:NSMinXEdge];
	[block setWidth:2.0f type:NSTextBlockAbsoluteValueType forLayer:NSTextBlockPadding edge:NSMaxXEdge];
	[block setVerticalAlignment:NSTextBlockMiddleAlignment];
    // Should also add in the ability to set the border color
    // Set up the background color for the cell
    // First set the overall color
    [block setBackgroundColor:rowColor];
    // if it is an even row number, we are using alternating rows, and there is a header row it should get the alternate color
	if (row % 2 == 0 && alternateRows && headerRow) [block setBackgroundColor:alternateRowColor];
    // If we are using alternate row color without a header row odd row numbers should get the alternate color
    if (row % 2 != 0 && alternateRows && !headerRow) [block setBackgroundColor:alternateRowColor];
    // If we are using a header row and the row number is 0 it should get the header color
    if (row == 0 && headerRow) [block setBackgroundColor:headerColor];
    // If we are using a header column and it is column 0 it needs the header color
    if (column == 0 && headerColumn) [block setBackgroundColor:headerColor];
    
	[style setTextBlocks:[NSArray arrayWithObject:block]];
	[style setAlignment:anAligment];
	[text replaceCharactersInRange:NSMakeRange(textLength, 0) withString:[NSString stringWithFormat:@"%@\n", (contents ? contents : @"")]];
	[text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(textLength, [text length] - textLength)];
    // Now to set up the text style based on what kind of cell we are working on using the same method as color
    [text addAttributes:rowTextStyle range:NSMakeRange(textLength, [text length] - textLength)];
    // if it is an even row number, we are using alternating rows, and there is a header row it should get the alternate style
	if (row % 2 == 0 && alternateTextRows && headerRow) [text addAttributes:alternateRowTextStyle range:NSMakeRange(textLength, [text length] - textLength)];
    // If we are using alternate row color without a header row odd row numbers should get the alternate style
    if (row % 2 != 0 && alternateTextRows && !headerRow) [text addAttributes:alternateRowTextStyle range:NSMakeRange(textLength, [text length] - textLength)];
    // If we are using a header row and the row number is 0 it should get the header style
    if (row == 0 && headerRow) [text addAttributes:headerTextStyle range:NSMakeRange(textLength, [text length] - textLength)];
    // If we are using a header column and it is column 0 it needs the header style
    if (column == 0 && headerColumn) [text addAttributes:headerTextStyle range:NSMakeRange(textLength, [text length] - textLength)];
}
@end
