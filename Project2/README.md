<html><head></head><body bgcolor="white">
<h1>Homework II</h1>

<h2><strong>Problem A due February 16</strong>
<br>
<strong>Problem B due February 23</strong>
<br>
<strong>Problem C due February 27</strong>
</h2>

<h3>
Note:
As always, do not deviate from the problem specs.
</h3>

<h3>Problem A</h3>

<p>
The programming in this problem will be fairly straightforward, but it
is important that you understand the motivation, as follows.
</p>

<p>
Imagine a 3-question survey, with each question asking the respondent to
rate a product from 1 to 5.  There will be 5<sup>3</sup> = 125 possible
patterns, i.e. (1,1,1), (1,1,2),...,(5,5,5).  We are interested in
determining which patterns in our data set are most common.
</p>

<p>
For example, say there are 7 people who completed the survey, and they
answered
(5,4,5),
(5,2,3),
(5,4,5),
(1,4,2),
(3,3,3),
(5,4,5),
(1,4,2).
Then the most frequent pattern was (5,4,5), and the second-most frequent
one was (1,4,2).
</p>

<p>
We might store our frequencies in a two-dimensional array, with the
first 3 columns being the pattern and the last column being the
frequency.  So, we'd have 4 rows, one for each of the patterns we found,
with one of the rows being (5,4,5,3).
</p>

<p>
Now consider what would happen if the survey had 50 questions, with a
large number of respondents.  There would now be 5<sup>50</sup> 
possible patterns, and though most patterns would not show up in the 
data, the above 2-D array would have a ton of rows.  That in itself 
is not so bad, but what if we want to do many queries, asking the 
frequencies of various patterns?  Then we would have to do a search 
through the array each time, which could be really slow.
</p>

<p>
A better approach would be the use a Python dictionary. In the above
example, we might create a dictionary <b>freqs</b>, with for instance 
<b>freqs['5,4,5']</b> equal to 3.  This way we could do
<i>associative</i> lookups; for instance, we would submit the query
<b>'5,4,5'</b> and the return value would be 3.
This would be much faster, because Python dictionaries are implemented
as hash tables.
</p>

<p>
The other issue is that real-world data is messy, with a lot of missing
values.  For example, we might have a record consisting of (5,4,NA),
where NA means "not available."  This is an R term, roughly the same as
Python's None.  But it partly matches the (5,4,5) pattern in our data,
so we might count it as 2/3 of a match to (5,4,5). So, the frequency of
(5,4,5) would be 3 2/3.  And if we had had, say, a (5,4,1) record in 
our data, that would count 2/3 as well.  If we have 4 questions in 
our survey, a record with 2 NAs but which matches an intact record in 
the other 2 components, it would count as half a match.  Partial 
matches are made only of nonintact patterns to intact patterns.
</p>

<p>
So here are the specs:
</p>

<ul>

<li> Write a function <b>calcfreqs(infile,nqs,maxrat</b>, with arguments
as follows: The input file name is given by <b>infile</b>; the number of
questions in the survey is <b>nqs</b>; and the choice of responses is
1...<b>maxrat</b>.  The return value is a Python dictionary as described
above.
</li> <p></p>

<li> The input file's line format is, e.g.
<p></p>

<pre>5 4 NA
</pre>
</li> <p></p> 

<li> Have your code raise an exception, with an error message printed,
if the file doesn't exist, or if a line in the file is found to have an
error.
</li> <p></p> 

<li> Write a function <b><b>highfreqs(freqs,k)</b></b>, where <b>freqs</b>
is the output of <b>calcfreqs()</b>, and <b>k</b> is a positive integer.
The return value is the subdictionary corresponding to the patterns
with the <b>k</b> highest frequencies.  If two different patterns have
the same frequency and the latter is among the <b>k</b> highest, include
them both.  Also, if <b>k</b> is negative, find the <i>least </i>
frequent patterns, not the most.
</li> <p></p>

<li> Place your entire code in a file <b>ProblemA.py</b>.
</li> <p></p>

</ul>

<p>
Below is an example, using the file <b>y</b>,
</p>

<pre>5 4 5
NA 3 3
5 2 3
5 4 5
1 4 2
5 4 NA
4 NA 1
5 4 1
3 3 3
5 2 3
5 4 5
1 4 2
</pre>

<pre>&gt;&gt;&gt; from Freq import *
&gt;&gt;&gt; fr = calcfreqs('y',3,5)
&gt;&gt;&gt; fr
{'5,4,5': 3.6666666666666665, '1,4,2': 2, '5,4,1': 1.6666666666666665,
'3,3,3': 1.6666666666666665, '5,2,3': 2}
&gt;&gt;&gt; highfreqs(fr,2)
{'5,4,5': 3.6666666666666665, '1,4,2': 2, '5,2,3': 2}
</pre>

<h2>Problem B:</h2>

<p>
Here you will write code to perform a type of file data operation, using
Python threads. 

You are required to use either the <b>thread</b> or
<b>threading</b> module.
</p>

<p>
The problem statement is simple (and the code is not difficult):  Write
a function with declaration
</p>

<pre>def linelengths(filenm,ntrh):
</pre>

<p>
which returns a Python <b>list</b>, the i<sup>th</sup> element of which
is the number of characters in line i of the file.
Here are the details:
</p>

<ul>

<li> Do not count the EOL character in the line length.  But allow for
empty lines, i.e. length 0.
</li> <p></p>

<li>
If the last byte in the file is not the EOL character, operate as if
there is one, i.e. treat the last set of bytes in the file as a line.
</li> <p></p> 

<li> Have the threads work on approximately equal chunks of the file,
starting at about equally-spaced points.  For instance, say the file is
1200 bytes long (including EOLs) and you run 3 threads.  Have thread 0
start at byte 0, thread 1 start at byte 400, and thread 2 start at 800.
</li> <p></p>

<li> The point of Problem B is to get experience with interactions
between threads.  In this case, that will mean having the threads
cooperate to create the final list of line lengths.  Do not have the
parent thread splice together the individual lists found by the child
threads.
</li> <p></p>

<li> Hopefully the threaded version is faster than an unthreaded one,
due to parallelism.  The GIL limits the potential for speed increase,
but we may be able to get parallelism via the overlapping of computation
and I/O.  For Extra Credit, do a timing experiment, probably on a very
large file, which you will store in <b>/tmp</b>.  Make sure your steps
are reproducible by the TA. Please your report in a file
<b>Report.txt</b>, a plain ASCII text file.
</li> <p></p>

<li> 
Put your code in a file <b>ProbB.py</b>.
</li> <p></p> 

</ul>

<p>
Test example:
</p>

<pre>% cat z

1
23
abc
de
f
% od -h z
0000000 310a 320a 0a33 6261 0a63 6564 660a 000a
0000017
wc -c z
15 z
</pre>

<p>
There are 15 bytes in this file, including the EOL character, 0x0a. By
the way, note that because this is a Little Endian machine, the order of
the reported bytes here is "backwards." For instance, byte 6 has contents,
0x61, byte 7 has contents 0x62.
</p>

<p>
Say you have 2 threads, so thread 0 works on bytes 0-6 and thread 1
handles 7-14.  Thread 0 will find line lengths in its chunk of the file,
and thread 1 will work on its chunk.  
</p>

<p>
Note carefully that the 'abc' line is split between the 2 chunks.  The
threads will have to deal with this, reconciling any discrepancies.  Do
not have the parent thread do this; it should only set up the threads,
call them and then return the list that they cooperatively form.
</p>

<p>
Calling <b>linelengths('z',2)</b> should return the list [0,1,2,3,2,1].
</p>

<h2>Problem C:</h2>

<p>
Here you will write a 
<a href="http://heather.cs.ucdavis.edu/~matloff/simpy.html">SimPy</a> 
simulation program for a very simple model 
of an online store.  Here are the details:
</p>

<ul>

<li> Customer orders arrive at random times, with times between
successive orders having a gamma distribution.  You call this via
<b>random.gammavariate()</b>, with arguments <b>alpha</b> and
<b>beta</b>.  
<p></p>

<p> The 
<a href="https://en.wikipedia.org/wiki/Gamma_distribution">Wikipedia
entry </a> for the gamma distribution family has pictures of the density
function; their k is Python's <b>alpha</b> and their θ is Python's
<b>beta</b>.  If you generate, say 1000, random variates using this
Python call and draw a histogram, it will look like one of the curves in
the picture.
</p></li> <p></p>

<li> The distribution of times between deliveries of new inventory will
also be modeled as gamma, with different values of  <b>alpha</b> and 
<b>beta</b> than above.
</li> <p></p>

<li> There is only one kind of item sold. Each customer orders a
quantity of 1.  Each delivery of new stock is a quantity of 1.
</li> <p></p>

<li> Your "main" function will have the declaration 
<p></p>

<pre>def storesim(maxsimtime,alphac,betac,alphai,betai):
</pre>

</li> <p></p>

<li> The function returns the following in a tuple:
<p></p>

   <ul>

   <li> the mean time it takes for a customer's order to be filled (0 if
   immediate)
   </li> <p></p>

   <li> the proportion of customer orders that are filled immediately
   </li> <p></p>

   <li> the proportion of inventory deliveries that are immediately used
   to fill a customer order upon arrival of the delivery
   </li> <p></p> 

   </ul>

</li> <p></p> 

<li> Place your code in a file <b>ProbC.py</b>.

</li></ul>
</body></html>
