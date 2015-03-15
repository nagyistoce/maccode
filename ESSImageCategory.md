# ESSImageCategory - NSImage additions #

This will make it possible for you not only to get a _TIFFRepresentation_, but also _JPEGRepresentation, JPEG2000Representation, PNGRepresentation, GIFRepresentation, BMPRepresentation_.

## JPEGRepresentation ##
```
- (NSData *)JPEGRepresentation;
```

Returns an NSData object containing the jpeg representation of the image.

## JPEG2000Representation ##
```
- (NSData *)JPEG2000Representation;
```

Returns an NSData object containing the jpeg2000 representation of the image.

## PNGRepresentation ##
```
- (NSData *)PNGRepresentation;
```

Returns an NSData object containing the png representation of the image.

## GIFRepresentation ##
```
- (NSData *)GIFRepresentation;
```

Returns an NSData object containing the gif representation of the image.

## BMPRepresentation ##
```
- (NSData *)BMPRepresentation;
```

Returns an NSData object containing the bmp representation of the image.