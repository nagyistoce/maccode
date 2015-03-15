# pxmLib NSImage additions #

These methods, which pxmLib adds to NSImage, provide the ability to quickly access a 'pxm#' resource with a single message to NSImage.

## imageFrompxmArrayWithResourceID:inResourceFileAtPath:forkName: ##
```
+ (NSImage *)imageFrompxmArrayWithResourceID:(short)resID inResourceFileAtPath:(NSString *)path forkName:(struct HFSUniStr255 *)forkName;
```

Opens the fork `forkName` of the file at `path`, and retrieves the 'pxm#' resource whose ID is `resID` from it. If the file does not have a 'pxm#' resource with that ID, returns nil.

This method only looks in the specified file; it does not traverse the search path of other opened resource files.

The image returned contains all the frames of the 'pxm#' resource, with one NSImageRep for each frame.

## imageFrompxmArrayWithResourceID:inResourceFileAtPath: ##
```
+ (NSImage *)imageFrompxmArrayWithResourceID:(short)resID inResourceFileAtPath:(NSString *)path;
```

Opens the file at `path`, and retrieves the 'pxm#' resource whose ID is `resID` from it. If the file does not have a 'pxm#' resource with that ID, returns nil.

This method first tries the resource fork; if that does not work, it tries the data fork.

This method only looks in the specified file; it does not traverse the search path of other opened resource files.

The image returned contains all the frames of the 'pxm#' resource, with one NSImageRep for each frame.

## imageFrompxmArrayInSearchPathWithResourceID: ##
```
+ (NSImage *)imageFrompxmArrayInSearchPathWithResourceID:(short)resID;
```

Retrieves the 'pxm#' resource whose ID is `resID`. It will retrieve the first available matching resource, like [GetResource](http://developer.apple.com/documentation/Carbon/Reference/Resource_Manager/Reference/reference.html#//apple_ref/c/func/GetResource).

## imageFromSystemwidepxmArrayWithResourceID: ##
```
+ (NSImage *)imageFromSystemwidepxmArrayWithResourceID:(short)resID;
```

Retrieves the 'pxm#' resource whose ID is `resID`. On big-endian systems, it looks in `/System/Library/Frameworks/Carbon.framework/Frameworks/HIToolbox.framework/Resources/Extras.rsrc`, whereas on little-endian systems, it looks in `/System/Library/Frameworks/Carbon.framework/Frameworks/HIToolbox.framework/Resources/Extras2.rsrc`. Their content is the same; the only difference is the byte-ordering.

## imageFrompxmArrayData: ##
```
+ (NSImage *)imageFrompxmArrayData:(NSData *)data;
```

Returns an `NSImage` containing all the frames from the 'pxm#' data in `data`. You will probably have retrieved this data from a 'pxm#' resource.

The image returned contains all the frames of the 'pxm#' resource, with one NSImageRep for each frame.

This is the method that ultimately powers all the others.