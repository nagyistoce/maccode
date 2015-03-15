# What a pxm# is not #

While “pxm” can be reasonably assumed to mean “pixmap”, it does not mean [PixMap](http://developer.apple.com/documentation/Carbon/Reference/QuickDraw_Ref/Reference/reference.html#//apple_ref/c/tdef/PixMap) in the QuickDraw sense. They are separate formats.

# What a pxm# is #

A 'pxm#' resource contains zero or more raster images. Mac OS X, as of Tiger, uses many 'pxm#' resources as storage for pieces of the Aqua and brushed-metal UI graphics.

As usual, the # in the resource type indicates that the resource contains an array of objects (in this case, masks and images). Compare 'STR#' (string array), 'PAT#' (pattern array), etc.

# Graphics formats #

Pixels can be in any of the following formats:

  * `pxmTypeIndexed` (8): Indexed-color, 8-bit
  * `pxmTypeDirect16` (16): Direct pixels, 16-bit
  * `pxmTypeDirect32` (32): Direct pixels, 32-bit RGBA

We don't know what pixels look like in 16-bit mode. We can assume that they are RGB, but we don't know whether they are 555 or 565. Conclusions cannot be borrowed from QuickDraw: 32-bit Color QuickDraw ordinarily uses ARGB, whereas 'pxm#' resources use RGBA.

32-bit mode can be with or without alpha. So far, in looking at Tiger's resources, we have only encountered graphics with alpha, even when their coverage has no holes. Therefore, the layout of components in no-alpha 'pxm#' graphics is unknown.

Note: The pixel format for any one 'pxm#' resource applies to all the images therein.

# Architectural notes #

The header in a 'pxm#' resource is in native byte-order; the mask and pixel data in a 'pxm#' resource is big-endian.

On Tiger, HIToolbox.framework contains two files, Extras.rsrc and Extras2.rsrc, which are identical in all respects other than the byte-order of their header (Extras.rsrc is big-endian, whereas Extras2.rsrc is little-endian). Testing byte-order is fairly simple: The `version` field's high byte will be zero if the header is big-endian, or non-zero if the header is little-endian.

Alignment follows the rules for the 68000 processor family.

# The pxmData structure #

pxmLib uses a structure called `struct pxmData` to interpret the contents of a 'pxm#' resource.

The structure contains the following fields:

  1. `version`: As of both Panther and Tiger, always 3.
  1. `bitfield`:
    1. `__empty`: 11 bits. Never used.
    1. `chaos`: 1 bit. Never used.
    1. `mystery`: 1 bit. Spotted set in Extras.rsrc#2062 (Tiger).
    1. `hasAlpha`: 1 bit. Seems to always be set in Tiger.
    1. `__unknown1`: 1 bit. Never used.
    1. `singleMask`: 1 bit. Indicates whether the image has exactly one click-mask for all images, or one mask _per_ image.
  1. `bounds`: QuickDraw Rect. Ramifications of a non-zero-origin rectangle are unknown.
  1. `pixelSize`: Number of bits per pixel.
  1. `pixelType`: Number of bits per component. `pxmTypeIndexed` means indexed-color. See “Graphics formats” above.
  1. `clutAddr`: Pointer to a ['clut' (color look-up table) resource](http://developer.apple.com/documentation/mac/QuickDraw/QuickDraw-267.html). Probably not safe to use fresh off the disk; should be filled in after reading by looking up the resource by its ID (see `clutID`, the next field).
  1. `clutID`: Resource ID of a 'clut' resource.
  1. `imageCount`: Number of frames in the image. If `singleMask` is 0, this is also the number of masks in the image.
  1. `data`: All mask and image data.

## Format of image data ##

First are the masks: either `imageCount` of them (if `singleMask` is 0), or exactly one (if `singleMask` is 1). These are 1-bit-per-pixel images, regardless of the pixel format specified by `pixelSize` and `pixelType`. Presumably, they are used for hit-testing: you would map the mouse location to an index, then test the bit at that index for whether it's considered part of the control.

After the masks come the actual image frames. The size and format of the pixels in these images are defined by `pixelSize` and `pixelType`, respectively. All frames in a given resource have the same pixel size and format. Despite the use of the word “frame”, a 'pxm#' is not necessarily (nor even usually) an animation.

If the pixel format is indexed-color (`pixelType` is `pxmTypeIndexed`), we presume that colors should be looked up using the 'clut' resource indicated by the `clutID` field.

# Implementation notes #

pxmLib used to call the `singleMask` member in the bitfield `maskCount`, and provided constants named `pxmSingleMask` and `pxmMultiMask` for it. We have chosen to deprecate the constants, and construe the field as a Boolean choice. We made this decision because we are of the opinion that calling it `maskCount` implies that it will actually count off the masks, which it does not do—in other words, that calling it that is misleading.

As of this writing, pxmLib does not handle custom 'clut' specifications. For that matter, it doesn't do anything with the 'clut' at all.