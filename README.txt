XF-Scraper

This is a command line program which scrapes the posts from a XenForo-based message board.  The program uses the first argument passed to it (which needs to be a thread) and prints the posts on the given page of that thread as well as the username of the users who made those posts into STDOUT.  So far, I have tested this program with forums.spacebattles.com as well as forums.sufficientvelocity.com.

Compilation instructions:
Issuing the make command will build the program and should work as is if this is being done in a Unix-like environment with SBCL.  Windows users may need to get some sort of POSIX-like environment to build on or at least the make command.  Make sure that the specific Lisp implementation is running an ASDF version which supports asdf:make.

Usage:
xf-scraper [url]
