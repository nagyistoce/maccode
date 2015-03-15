# AutoHyperlinks.framework #
AutoHyperlinks is the framework used by some programs, like Adium, to scan for URLs in strings and other text containers.  This framework is released under the modified BSD license, and is free to be used in most any software project.


## What, exactly, does AutoHyperlinks do? ##
The AutoHyperlinks framework handles the detection of hyperlinks in normal language, leaving you, the developer, free to concentrate on the core functionality of your application.

It's the same code we use in Adium to match all our hyperlinks, and we think it's pretty great.

AutoHyperlinks gives you a framework with a flex based lexer and two Objective-C classes in it: _AHMarkedHyperlink_ and _AHHyperlinkScanner_.  Together, these two classes can work together to identify and add the NSLinkAttributeNames like Adium does, or you can simply gather all the links strings and do whatever you want with them.


## How do I get it? ##
Right here in maccode.  See WhatIsMacCode.


## How do I use it in my project? ##
To use AutoHyperlinks in your existing project, take the following steps:

  1. Place the _AutoHyperlinks Framework_ directory in a subdirectory of your main project
  1. Drag the AutoHyperlinks.xcodeproj file into your project.
  1. Xcode will ask you to what targets you'd like the project to reference
  1. Select the build target(s) you want to include AutoHyperlinks, and hit ok.
  1. Xcode will automatically build and install the AutoHyperlinks framework when you build your project.


## What does it Include? ##
You're given two classes to work with: _AHMarkedHyperlink_ and _AHHyperlinkScanner_.  It's sole dependency is the system Cocoa.framework, and is technically compatible down to OS X 10.3 (though we recommend 10.4 or later).
### AHMarkedHyperlink ###
AHMarkedHyperlink is a data type that holds onto information about each link; such as a NSURL object, a reference to it's parent string, and the link's range within that string.  It also holds the links verification status as defined in AHLinkLexer.h so you know what type of link it is.

### AHHyperlinkScanner ###
AHHyperlinkScanner is the main interface to all of the framework's link detection abilities.

It has two parsing modes: **strict** and **non-strict**.

**Strict Mode**::
> This is the default mode. Only proper URIs with specified schemes (http://example.com/ but not example.com) will get identified as links.

**Non-Strict Mode**::
> Setting strict checking to NO removes this restriction, so [example.com](http://example.com) is included as a link, as well as http://example.com/.

#### Class Methods: ####

**+[hyperlinkScannerWithString:](AHHyperlinkScanner.md)**
> _Creates a non-strict instance of AHHyperlinkScanner with a given NSString._
**+[strictHyperlinkScannerWithString:](AHHyperlinkScanner.md)**
> _Creates a strict instance of AHHyperlinkScanner with a given NSString._
**+[hyperlinkScannerWithAttributedString:](AHHyperlinkScanner.md)**
> _Creates a non-strict instance of AHHyperlinkScanner with a given NSAttributedString._
**+[strictHyperlinkScannerWithAttributedString:](AHHyperlinkScanner.md)**
> _Creates a strict instance of AHHyperlinkScanner with a given NSAttributedString._
**+[isStringValidURI:usingStrict:fromIndex:withStatus:](AHHyperlinkScanner.md)**
> _Returns a BOOL of the given string's validity._

#### Instance Methods ####
**-[nextURI](AHHyperlinkScanner.md)**
> _Returns the next valid URI in the string as an AHMarkedHyperlink._
**-[allURIs](AHHyperlinkScanner.md)**
> _Returns an NSArray of all valid URIs in the scanner's string as AHMarkedHyperlinks._
**-[linkifiedString](AHHyperlinkScanner.md)**
> _Returns an attributed string of the original string with NSURLs attached to all URI substrings.  If the class was instantiated with an attributed string, all original attributes are preserved._



## Other Questions ##
### What kinds of URLs will it match? ###
  * Most anything that should be a link, and we respect enclosed links and punctuation, so <http://example.com/> and [example.com](http://example.com), and "[example.com](http://example.com)" all get linked properly.
  * Ugly URLs that include multiple and complex parameter strings.
  * All sponsored and unsponsored TLDs, along with ccTLDs are valid matches.
  * Unicode characters.
  * IPv4 and IPv6 addresses with scheme specifiers are valid matches.
  * Local/internal domains with scheme specifiers are valid matches. (ex: "http://example.megaCorp" or "http://localhost")
  * Recognized schemes include:
    * http and https
    * ftp, sftp, ssh and svn
    * radar links
    * itms links
    * several Chat/IM service links, including IRC, AIM, Jabber, and Yahoo!
### What kinds of URLs will it _not_ match ###
We allow simple domain names to be linked in non-strict mode, however we **never** match the following:
  * IPv4 or IPv6 addresses without schemes.
  * Common and simple abbreviations without schemes (they will, however, link _with_ a scheme). (ex: B.Sc, m.in)
  * Local/internal domains without schemes. (ex: "example.megaCorp" or "localhost" by themselves)
  * links that already contain a NSLinkAttributeName within an attributed string.