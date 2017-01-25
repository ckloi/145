<html><head></head><body bgcolor="white">
<h1>Homework I</h1>

<h2><strong>Due Friday, February 3</strong></h2>

<p>
Here you will develop a Python modules <b>fs</b> which creates and
manages a private file system.  This will be a "parallel universe" in
which the usual functions are available, e.g. <b>fs.chdir()</b> rather
than <b>os.chdir()</b>.  Here is the overview:
</p>

<ul>

<li> 
An <b>fs</b> system will be created within a
native file <b>f</b> specified by the file system administrator.  It is
presumed to exist before this call.
</li> <p></p>

<li> It would be nice to have this as a multiuser, multiprocess sytem,
but that would become too complicated.  So, it will be single-user, one
process running at a time.
</li> <p></p> 

<li> In creating the file system, the user must first call 
<b>fs.init(fsname)</b>.  The argument is the name of the native file in
which we will do our storage.
</li> <p></p> 

<li>
File name specification in the calls described below
is done either using relative or absolute path.
The root directory is <b>/</b>, and that character is also the separator
in path names.  The expressions <b>.</b> and <b>..</b> have the same
meaning as in Unix-family systems.
</li> <p></p>

<li> Error checking is required in the cases specified below.  Handle
this via Python's <b>raise</b> and <b>Exception()</b> features.
</li> <p></p> 

<li> The system will have a function <b>fs.create(filename,nbytes)</b>.
The <b>nbytes</b> argument specifies the number of bytes needed for 
the file.  When this function is called, <b>fs</b>
will attempt to allocate space for the file.  
Typically the space will consist of multiple chunks within the native
file <b>f</b>; of course <b>fs</b> must record 
this information.  The function will raise an
exception upon failure to allocate space.  The bytes will be 
initialized to NULLs, i.e. all bits 0. 
</li> <p></p> 

<li> There will be a function <b>fs.mkdir(dirname)</b>. 
</li> <p></p>

<li> The system will have a function <b>fs.open(filename,mode)</b>,
where <b>mode</b> is either <b>'r'</b> or <b>'w'</b>.  The return value
will be a file descriptor as with the Python <b>open()</b>, except that
it will now be a file descriptor for <b>fs</b>.  The code will raise an
exception if (a) the file system is currently suspended or (b) there is no
such file. 
</li> <p></p> 

<li> 
There will also be a function <b>fs.close(fd)</b>, with a single 
argument, the file descriptor.  
</li> <p></p> 

<li> 
The function <b>fs.length(fd)</b> will return the current number of 
bytes actually used in the file, initially 0.  The argument <b>fd</b>
is the file descriptor.  For example, say the file is created with size
100 bytes, and then 3 bytes are written.  These will be in bytes 0-2 of
the file, and the length will be 3.
</li> <p></p> 

<li> 
The function <b>fs.pos(fd)</b> will return the current read/write position
in the file.  This is initially set to 0 by <b>fs.open()</b>, i.e. 
the beginning of the file.    
</li> <p></p> 

<li> The function <b>fs.seek(fd,pos)</b> will set the current
read/write position to <b>pos</b>.  An exception is raised if (a) the
argument is negative or (b) greater than the file size or (c) would make
the file bytes non-contiguous.
</li> <p></p>

<li> There will be these I/O functions:
<p></p>

   <ul>

   <li> <b>fs.read(fd,nbytes)</b>; returns a string; raises an exception
   if the read would extend beyond the current length of the file
   </li> <p></p> 

   <li> <b>fs.write(fd,writebuf)</b>, where <b>writebuf</b> 
   is a string 
   </li> <p></p> 

   <li> <b>fs.readlines(fd)</b>; reads the entire file, returning a list
   of strings; treats any 0xa byte it encounters as end of a line; does
   NOT change the <b>pos</b> value
   </li> <p></p> 

   </ul>

<p>
Note that strings are not necessarily ASCII.
</p>

</li> <p></p> 

<li> There will be functions <b>fs.delfile(filename)</b> and
<b>fs.deldir(dirname)</b> to delete files and directories.  Raise an
exception if the file/directory doesn't exist or (b) the file is open or
(c) the calling process is currently within the specified directory.
</li> <p></p> 

<li> Have functions <b>fs.isdir()</b> and <b>fs.listdir()</b>, to work
like their Python <b>os</b> counterparts.
</li> <p></p> 

<li> 
It is presumed that the machine on which the file system is stored will
not always be up, or the user may not always be logged on.  So, the user
can temporarily suspend the system, by calling <b>fs.suspend()</b>, 
and later resume service via <b>fs.resume()</b>.  Suspension will not be
allowed if any files are open for writing.
<p></p>

<p>
Upon suspension, all data structures etc. are saved
to a file in a native file whose name is the concatenation of the name
of <b>f</b> and <b>'.fssave'</b>.  The saving/resuming of the system is
done via the Python <b>pickle</b> module.
</p></li> <p></p>


 
</ul></body></html>
