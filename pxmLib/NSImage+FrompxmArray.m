/*
 Copyright (c) 2007, Peter Hosey and Colin Barrett
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of Peter Hosey, nor the name of Colin Barrett, nor the names of his contributors may be used to endorse or promote products derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <machine/endian.h>
#import "NSImage+FrompxmArray.h"

@implementation NSImage (CBPRHFrompxmArray)

+ (NSImage *)imageFrompxmArrayData:(NSData *)data {
	NSLog(@"Creating NSImage from pxm# data that is %u bytes long (structure type: %u bytes long)", [data length], sizeof(struct pxmData));
	const struct pxmData *pxmBytes = [data bytes];

	NSAssert1(pxmPixelType(pxmBytes) == pxmTypeDirect16 || pxmPixelType(pxmBytes) == pxmTypeDirect32, @"Incorrect pxm# pixel-type: %hi", pxmPixelType(pxmBytes));

	Rect bounds;
	pxmBounds(pxmBytes, &bounds);
	NSSize size = {
		.width  = bounds.right - bounds.left,
		//QuickDraw Rects are oriented from the top-left, not bottom-left, so bottom is the greater number.
		.height = bounds.bottom - bounds.top
	};

	NSImage *image = [[[NSImage alloc] initWithSize:size] autorelease];

	NSLog(@"bitfield number: %hx; multiMask: %hu; imageCount: %hu", pxmBytes->bitfield.number, pxmIsMultiMask(pxmBytes), pxmImageCount(pxmBytes));
	
	size_t bitsPerPixel = pxmPixelSize(pxmBytes);
	size_t bytesPerPixel = bitsPerPixel / 8U;

	size_t bytesPerRow = size.width * bytesPerPixel;
	size_t bytesPerFrame = bytesPerRow * size.height;
	NSLog(@"Size of structure %u + first frame %u: %u", sizeof(struct pxmData), bytesPerFrame, sizeof(struct pxmData) + bytesPerFrame);

	size_t samplesPerPixel = pxmHasAlpha(pxmBytes) ? 4U : 3U;

	NSLog(@"wah: %f by %f; bps: 8; spp: %u; has alpha: %u; planar: no; bytes per row: %u; bitsPerPixel: %u", size.width, size.height, samplesPerPixel, (unsigned)pxmHasAlpha(pxmBytes), bytesPerRow, bitsPerPixel);

	unsigned numFrames = pxmImageCount(pxmBytes);
	NSMutableArray *reps = [NSMutableArray arrayWithCapacity:numFrames];
	for(unsigned i = 0U; i < numFrames; ++i) {
		unsigned char *planes[1] = { (unsigned char *)pxmBaseAddressForFrame(pxmBytes, i) };
		NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc]
			initWithBitmapDataPlanes:planes
			pixelsWide:size.width
			pixelsHigh:size.height
			bitsPerSample:8U
			samplesPerPixel:samplesPerPixel
			hasAlpha:pxmHasAlpha(pxmBytes)
			isPlanar:NO
			colorSpaceName:NSDeviceRGBColorSpace
			bytesPerRow:bytesPerRow
			bitsPerPixel:bitsPerPixel];

		[reps addObject:bitmapRep];
		[bitmapRep release];
	}

	[image addRepresentations:reps];

	return image;
}

@end
