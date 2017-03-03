


<body bgcolor="white">
<h1>Homework III</h1>

<h2>Due Monday, March 6</h2>

<h3>
Note:
As always, do not deviate from the problem specs.
</h3>

<h3>Problem A</h3>

<p>
When I was a kid, comic books, cereal boxes and so on would have ads for
things like "secret decoder rings."  In this assignment, you'll develop
one, using R. :-)
</p>

<p>
The basic idea is to embed secret messages in images.  Some pixels will
be replaced by the characters in the message.  If the message is
not very long, no one will notice that a few random pixels of the image
are corrupted.
</p>

<p>
Before you start, you'll need to familiarize yourself wtih some tools.
Do the following from a shell window on a Unix-family machine (on a Mac,
use <b>curl</b> if you don't have <b>wget</b>):
</p>

<pre>
% wget http://cdn5.thr.com/sites/default/files/imagecache/scale_crop_768_433/2016/12/lll_d33_05656_r-h_2016.jpg
% convert lll_d33_05656_r-h_2016.jpg LLL.pgm
</pre>

<p>
You'll then need the <b>pixmap</b> library.  Install it on your own
machine, using <b>install.packages()</b>, or use my R library on CSIF,
in <b>~matloff/Pub/Rlib</b>; use <b>.libPaths()</b> to include it in
your R search path.
</p>

<p>
Then from R do
</p>

<pre>
# load the package
> library(pixmap)
# read in the image
> lll <- read.pnm('LLL.pgm')
# display it
> plot(lll)  # note use of generic function
# extract the pixel array, numbers in [0,1], darkest to lightest
> a <- lll@grey  # note S4 class
# change row 200 to black
> a[200,] <- 0.0
# make a new image with the altered pixels
> lll1 <- lll
> lll1@grey <- a
> plot(lll1)
# highly visible; but try changing one pixel
> a[210,1] <- utf8ToInt('G') / 128
> lll1@grey <- a
> plot(lll1)  # change not visible
</pre>

<p>
Now here is your task:
</p>

<UL>

<li> 
Write a function with call form
</p>

<pre>
secretencoder(imgfilename,msg,startpix,stride,consec=NULL)
</pre>

<p> 
with arguments as follows:
</p>

   <UL>

   <li> <b>imgfilename:</b> Name of the file in which the secret
   message is to be embedded.
   </li> </p>

   <li> <b>msg:</b> The message, a quoted string.
   </li> </p> 

   <li> <b>startpix:</b> The pixel at which the first character of the
   message is to be embedded.  This is a single number, interpreted as a
   position in column-major order storage of the pixels, starting at
   index 1.
   </li> </p> 

   <li> <b>stride:</b> Distance in pixels from one message character to
   the next (slightly modified if <b>consec</b> is FALSE).
   </li> </p>

   <li> <b>consec:</b> Explained below.
   </li> </p> 

   </UL>
</li> </p>

<li> Terminate your embedded secret message with a null byte (value 0).
</li> </p> 

<li> By allowing the <b>consec</b> to default to NULL, the user opts for a
quick-and-dirty enocding.  The altered pixels will be exactly <b>stride</b>
pixels apart (wrapping around at the end of the pixel array).  Your code
will make use R's vector subsetting ops for speed -- this is REQUIRED
-- even though it might jeopardize exposure of the image as a carrier of
a secret message and even though the procedure may overwrite a given
pixel more than once, thus losing part of the message.
</p>

<p>
If on the other hand the user sets <b>consec</b> to a positive integer, 
we avoid character loss, as overwriting a pixel more than once is not
allowed.  Exposure as a secret message carrier is also mitigated by 
not allowing more than <b>consec</b> contiguous pixels in any row or
column to be altered.  (It would be nice to check diagonals too, but we
won't do that.)
</p>

<p>
If, while inserting the message bytes, one of the above conditions
occurs, then move <b>stride</b> pixels further along and try inserting
at that new spot.  Iterate until an eligible pixel is found or you run
out of pixels.
</li> </p>

<li> Note:  The value of <b>stride</b> is best set to a value that is
relatively prime to the image size.  (Why?)  Issue a warning if the user
does not set such a value; use R's <b>warning()</b> function.
</li> </p>

<li> Check for the following error conditions:  File doesn't exist or
somehow doesn't load properly by <b>pixmap</b>; and insufficient room for
the message (including effects of <b>consec</b>, if any). Use <b>stop()</b>
in such cases.
</li> </p>

<li> The return value will be an object of class <b>'pixmapGrey'</b>.
It can be saved to disk as a <b>.pgm</b> image using <b>write.pnm()</b>,
or as an R object using R's <b>save()</b> function.
</li> </p>  
</p>

<li> 
Write a function with call form
</p>

<pre>
secretdecoder(imgfilename,startpix,stride,consec=MULL)
</pre>

<p> 
with arguments as above.  Of course, the recipient of the message must
know the values of <b>startpix</b> etc.  The return value is the
message.
</p>

</UL>

<h3>Problem B</h3>

<p>
Here you will implement a function similar to Python's
<b>os.path.walk()</b>, as follows:
</p>

<UL>

<li> The call form will be
</p>

<pre>
walk(currdir,f,arg,firstcall=TRUE) 
</pre>

<p>
where the arguments are:
</p>

   <UL>

   <li> <b>currdir:</b> starting directory for the current call
   </li> </p>

   <li> <b>f:</b> user-defined function, with arguments
   </p>

      <UL>

      <li> <b>dname:</b> Name of the directory within which the function
      is called.
      </li> </p>

      <li> <b>flist:</b> A list of files in that directory.  This will
      be supplied to <b>f()</b> by <b>walk()</b>.
      </li> </p> 

      <li> <b>arg:</b> An input to some running computation, say a sum.
      In the course of recursion, the output of <b>walk()</b>
      (initially, the output of <b>f()</b>) will be input
      to <b>f()</b>.
      </li> </p> 

      </UL> 

   </li> </p>

   <li> <b>firstcall:</b> if TRUE, this is the first of recursive calls
   </li> </p>

   </UL>

<li> The function <b>walk()</b> will have a return value, typically 
but not necessarily non-NULL
</li> </p>

<li> After returning from the orginal call, the new working directory
must be the one from which the original call had been made.
</li> </p> 
</UL>

<p>
Example:  Say the current directory has a subdirectory <b>a</b>, which
in turn file <b>c</b>, <b>d</b> and <b>e</b>, the last of which is a
directory containing files <b>f</b>, <b>g</b> and <b>h</b>, with
<b>g</b> being a directory containing a file <b>i</b>.
</p>

<pre>
> getwd()
[1] "/usr/home/matloff/tmp"
> dir()
[1] "a"           "debugrecord"
> 
> nfiles <- function(drname,filelist,arg) {
+    arg + length(filelist)
+ }
> 
> walk('a',nfiles,0)
[1] 7
> getwd()
[1] "/usr/home/matloff/tmp"
</pre>

<p>
Also REQUIRED:  You will write two application functions.  
The first will have call form
</p>

<pre>
nbytes(drname,filelist,arg) 
</pre>

<p>
and will find the total number of bytes in all the (nondirectory) files.
</p>

<p>
The second will have call form
</p>

<pre>
rmemptydirs(drname,filelist,arg) 
</pre>

<p>
and will remove all the empty directories.
</p>
