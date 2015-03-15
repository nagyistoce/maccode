# pxmLib API documentation #

## Creation, disposal, and external representations ##

### pxmCreate ###
```
pxmRef pxmCreate( void* inData, UInt32 inSize );
```

Creates a pxmRef from an external representation. You supply the pointer to the bytes, and the length of the bytes.

This function performs any necessary byte-swapping for you.

After you have created a pxmRef, you must later free it by calling pxmDispose.

### pxmDispose ###
```
pxmErr pxmDispose( pxmRef inRef );
```

Frees a pxmRef created by pxmCreate.

If you pass `NULL`, this function returns `pxmErrBadParams`. Otherwise, it returns `pxmErrNone`.

### pxmRead ###
```
pxmErr pxmRead( pxmRef inRef, void* ioBuffer, UInt32* ioSize );
```

Writes `inRef` to `ioBuffer` in its external-representation.

This function peforms any necessary byte-swapping for you.

### pxmSize ###
```
UInt32 pxmSize( pxmRef inRef );
```

Returns the total length in bytes of the pxmRef.

## Accessors ##

### pxmBounds ###
```
pxmErr pxmBounds( pxmRef inRef, Rect *outRect );
```

Returns the bounds as a QuickDraw Rect. Keep in mind that QuickDraw Rects have their origin in the top left.

The Rect is returned by reference. If either `inRef` or `outRect` is `NULL`, this function returns `pxmErrBadParams`. Otherwise, it returns `pxmErrNone`.

### pxmHasAlpha ###
```
bool pxmHasAlpha( pxmRef inRef );
```

Returns whether the pixels contained in the pxmRef have alpha (opacity) information.

### pxmPixelSize ###
```
UInt16 pxmPixelSize( pxmRef inRef );
```

Returns the size, **in bits**, of each pixel in the pxmRef.

### pxmPixelType ###
```
UInt16 pxmPixelType( pxmRef inRef );
```

Returns a pixel-type constant. Valid constants are:

  * `pxmTypeIndexed`: 8-bit indexed color.
  * `pxmTypeDirect16`: 16-bit RGB.
  * `pxmTypeDirect32`: 32-bit RGBA.

### pxmImageCount ###
```
UInt16 pxmImageCount( pxmRef inRef );
```

Returns the number of image frames in the pxmRef.

When `pxmIsMultiMask` returns true, `pxmImageCount` is also the number of masks.

### pxmIsMultiMask ###
```
bool pxmIsMultiMask( pxmRef inRef );
```

Returns whether the pxmRef contains one mask per image (true), or exactly one mask for all images (false).

## Image retrieval ##

### pxmBaseAddressForFrame ###
```
void *pxmBaseAddressForFrame( pxmRef inRef, UInt32 imageIndex );
```

Returns the base address for the pixel data at the given 0-based index. You can use this to create a `CGImage` or `NSBitmapImageRep`, among other things.