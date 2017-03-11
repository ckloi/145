<html><head></head><body bgcolor="white">
<h1>ECS 145 Project</h1>

<h2>Due date:</h2>

<p>
Final exam day (no written final), March 21, 11:59 pm.  <b>NO LATE 
SUBMISSIONS</b>. 
</p>

<h2>Project Title:  Trees, Stacks and Queues in R</h2>

<p>
R is not a convenient language for data structures, as it lacks pointers.
But that is not an insurmountable obstacle, as one can just use arrays.
</p>

<p>
For instance, consider binary trees.  One can implement a tree as a 
matrix, with each row representing one node of the tree.  In a row, the
first element is the value at the node, and the second and third are the
row numbers of the left and right children, if any.  (NA means no child
link in that direction.)
</p>

<p>
Here is what you will develop:
</p>

<ul>

<li> S3 classes <b>'bintree'</b>, <b>'stack'</b>, and <b>'queue'</b>.
</li> <p></p>

<li> A tree is kept in sorted order, as with the Python example in our
book.
</li> <p></p>

<li> Each class starts out empty, as c(NA,NA,NA) for a tree and simply
NA for the other two.  (No element value of any structure will be
allowed to be NA.)
</li> <p></p> 

<li> Each class has a <b>print()</b> method, e.g.
<b>print.bintree()</b>.  Printing an empty structure produces no output.
</li> <p></p> 

<li> Each class has push and pop methods, e.g. <b>push.bintree()</b>.
For trees, the push operation will add an element, of course maintaining
the sorted order; pop removes the smallest element.  For stacks and
queues, push and pop act in the traditional way.
</li> <p></p> 

<li> For constructors, simply write functions <b>newbintree()</b> and so
on.
</li> <p></p> 

<li> Form an R package from all this, named <b>tsq</b>, with directories
<b>R</b>, <b>man</b> and file <b>DESCRIPTION</b> and <b>NAMESPACE</b>.
There are tutorials on the Web for this, but most go into far much
advanced detail.  I suggest you just use my <a href="https://github.com/matloff/partools">partools</a> as
an example.
<p></p>

<p>
Once you have made these directories and their contents, say contained
in a directory <b>tsq</b>, then run
</p>

<pre>% R CMD build tsq
</pre>

<p>
in a terminal window to create the source code for your library, a 
file <b>tsq.tar.gz</b> (a version number will be added).  Users 
install it by typing </p>

<pre>% R CMD INSTALL -l rhomedir tsq.tar.gz
</pre>

<p>
where rhomedir is the directory where the user stores libraries.
</p>

<p>
Concerning the <b>man</b> directory, make sure to include examples,
preferably simple ones.
</p>

<p>
All this must run on CSIF, as usual.
</p></li> <p></p> 

<li> In addition to your code, you will write a clear, organized,
professional-quality report on what you did.  Explain the challenge of
doing this without pointers, compared to Python, why you made the design
choices that you did, etc.
</li> <p></p> 

</ul>

<h2><a name="submit">
<strong><span style="color: #FF0000">
IMPORTANT SUBMISSION DETAILS: </span></strong>
</a></h2>

   <ul>

   <li> Your group submits just ONE copy of the report. </li> <p></p>

   <li> Submit your report, including all files (<strong>.tex</strong>,
   <strong>.pdf</strong>, <strong>.tar.gz</strong>, 
   to my <strong>handin</strong> site on CSIF, directory <strong>
   145project</strong>.  The name of your file must be of the form 
   <strong>email1.email2....tar</strong>, where each 
   <strong>emaili</strong> is the UCD e-mail address of group member i,
   e.g. <strong>bclinton.gbush.bobama.tar</strong>.  Note the periods
   separating fields.  Your <strong>.tar</strong> file must contain
   only regular files, NO SUBDIRECTORIES!!!!
   </li> <p></p>

   <li> Make sure that all partners' names are on the report, and that
   the e-mail addresses in the file name are EXACTLY the official UCD
   e-mail addresses for the students.  These are the addresses at which
you
   have been receiving your Quiz results.  DON'T RISK HAVING A TEAM
   MEMBER FAILING TO GET CREDIT FOR THE PROJECT--IT HAS HAPPENED!

   </li> <p></p>

   </ul>

<h2><a name="grading">Grading criteria:</a></h2>

   <ul>

   <li> Technical content of the work. </li> <p></p>

   <li> Adherence to instructions. </li> <p></p>

   <li> Professional quality of the work. </li> <p></p>

   <li> A+ grades are very possible, and can have a significant impact
   on your course grade, letters of recommendation, knighthoods,
   coronoations, etc.
   </li> <p></p>

   </ul>

</body></html>
