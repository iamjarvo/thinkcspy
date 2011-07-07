..  Copyright (C) Peter Wentworth, Jeffrey Elkner, Allen B. Downey and Chris Meyers.
    Permission is granted to copy, distribute and/or modify this document
    under the terms of the GNU Free Documentation License, Version 1.3
    or any later version published by the Free Software Foundation;
    with Invariant Sections being Foreword, Preface, and Contributor List, no
    Front-Cover Texts, and no Back-Cover Texts.  A copy of the license is
    included in the section entitled "GNU Free Documentation License".

.. |rle_start| image:: illustrations/rle_start.png
   
.. |rle_end| image:: illustrations/rle_end.png
 
.. |rle_open| image:: illustrations/rle_open.png
   
.. |rle_close| image:: illustrations/rle_close.png    
 
|    
    
Modules and Files
=================


Modules
-------

A **module** is a file containing Python definitions and statements intended
for use in other Python programs. There are many Python modules that come with
Python as part of the **standard library**. We have seen two of these already,
the ``turtle`` module and the ``string`` module.

We have also shown you how to access help. The help system contains 
a listing of all the standard modules that are available with Python.  
You are encouraged to use and navigate help. 

.. _random_numbers:

.. index:: random numbers, shuffle, promise

Random numbers
--------------

We often want to use random numbers in programs: here are a few typical uses:

* To play a game of chance where the computer needs to throw some dice, pick a number, or flip a coin,
* To shuffle a deck of playing cards randomly,
* To randomly allow a new enemy spaceship to appear and shoot at you,
* To simulate possible rainfall when we make a computerized model for
  estimating the environmental impact of builing a dam,
* For encrypting your banking session on the Internet.
  
Python provides a module ``random`` that helps with tasks like this.  You can
look it up using help, but here are the key things we'll do with it::

    import random
    
    rng = random.Random()    # create a black box object that generates random numbers
    
    dice_throw = rng.randrange(1,7)       # return an int, one of 1,2,3,4,5,6
    delay_in_seconds = rng.random() * 5.0
    
The ``randrange`` method call generates generates an integer between its lower and upper
argument, using the same semantics as ``range`` --- so the lower bound is included, but
the upper bound is excluded.   All the values have an equal probability of occurring  
(i.e. the results are *uniformly* distributed).   Like ``range``, ``randrange`` can 
also take an optional step argument. So let's assume we needed a random odd number less
than 100, we could say::

    r_odd = rng.randrange(1, 100, 2)  

Other methods can also generate other distributions e.g. a bell-shaped, 
or "normal" distribution might be more appropriate for estimating seasonal rainfall,
or the concentration of a compound in the body after taking a dose of medicine. 

The ``random()`` method returns a floating number in the range [0.0, 1.0) --- the
square bracket means "closed interval on the left" and the round parenthesis means
"open interval on the right".  In other words, 0.0 is possible, but all returned
numbers will be strictly less than 1.0.  It is usual to *scale* the results after
calling this method, to get them into a range suitable for your application.  In the
case shown here, we've converted the result of the method call to a number in
the range [0.0, 5.0).  Once more, these are uniformly distributed numbers --- numbers
close to 0 are just as likely to occur as numbers close to 0.5, or numbers close to 1.0.

This example shows how to shuffle a list.  (`shuffle` cannot work directly
with a lazy promise, so notice that we had to convert the range object
using the ``list`` type converter first.) ::

    cards = list(range(52))         # generate integers 0..51, representing a pack of cards
    rng.shuffle(cards)              # shuffle the pack

.. index:: deterministic algorithm,  algorithm; deterministic, unit tests   
    
Repeatability and Testing
^^^^^^^^^^^^^^^^^^^^^^^^^

Random number generators are based on a **deterministic** algorithm --- repeatable and predictable.
So they're called **pseudo-random** generators --- they are not genuinely random.
They start with a *seed* value. Each time you ask for another random number, you'll get
one based on the current seed attribute, and the state of the seed (which is one
of the attributes of the generator) will be updated. 

For debugging and for writing unit tests, it is convenient
to have repeatability --- programs that do the same thing every time they are run.  
We can arrange this by forcing the random number generator to be initialized with
a known seed every time.  (Often this is only wanted during testing --- playing a game
of cards where the shuffled deck was always in the same order as last time you played
would get boring very rapidly!)   ::

    drng = random.Random(123)  # create a generator with a known starting state 
     
This alternative way of creating a random number generator gives an explicit seed
value to the object. Without this argument, the system probably uses something based
on the time.  So grabbing some random numbers from ``drng`` today will give you 
precisely the same random sequence as it will tomorrow! 

Picking balls from bags, throwing dice, shuffling a pack of cards
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Here is an example to generate a list containing `n` random ints between one and
`limit`: 

.. sourcecode:: python

    import random

    def make_random_ints(num, lower_bound, upper_bound): 
       """ 
         Generate a list containing num random ints between lower_bound
         and upper_bound. upper_bound is an open bound.
       """
       result = []
       rng = random.Random()
       for i in range(num):
          result.append(rng.randrange(lower_bound, upper_bound))
       return result
    
>>> make_random_ints(5, 1, 13)  # pick 5 random month numbers
[8, 1, 8, 5, 6] 

Notice that we got a duplicate in the result. Often this is
wanted, e.g. if we throw a die five times, we would expect
duplicates. 

But what if you don't want duplicates?  If you wanted 5 distinct months, 
then this algorithm is wrong.  A better algorithm is to generate the 
list of possibilities, shuffle it, and slice off the number of elements you want::

    xs = list(range(1,13))  # make the list 1..12
    random.shuffle(xs)      # shuffle it
    result = xs[:5]         # take the first five elements
 
In statistics courses, the first case is usually described as
pulling balls out of a bag *with replacement* --- you put the drawn
ball back in each time.  The latter case, with no duplicates, 
is usually described as pulling balls out of the bag *without
replacement*. 


The `math` module
-----------------

The ``math`` module contains the kinds of mathematical functions you'd typically find on your
calculator (`sin`, `cos`, `sqrt`, `asin`, `log`, `log10`) and some mathematical constants
like `pi` and `e`::  

    >>> import math
    
    >>> math.pi                     # constant attribute for pi
    3.141592653589793
    >>> math.e                      # constant natural log base
    2.718281828459045
    >>> math.sqrt(2.0)              # square root function
    1.4142135623730951
    >>> math.radians(90)            # convert 90 degrees to radians
    1.5707963267948966
    >>> math.sin(math.radians(90))  # find sin of 90 degrees.
    1.0
    >>> math.asin(1.0) * 2          # find arcsin of 1, double it, to get pi
    3.141592653589793

Like almost all other programming languages, angles are expressed in *radians*
rather than degrees.  There are two functions ``radians`` and ``degrees`` to
convert between the two popular ways of measuring angles.

Notice another difference between this module and our use of ``random`` and ``turtle``:
in ``random`` and ``turtle`` we create objects and call methods on the object.  This is
because objects have *state* --- a turtle has a colour, a position, a heading, etc., 
and every random number generator has a seed value that determines its next result. 

Mathematical functions are "pure" and don't need any state --- calculating the square root of
2.0 doesn't depend on any kind of state or history about what happened in the past.  
So the functions are not methods of a stateful object --- 
they are simply housed together in a module called `math`.  

.. index:: import statement, statement; import

Creating your own modules
-------------------------

All we need to create our own modules is to save our script as 
a file with a ``.py`` extension on the filename.  Suppose,
for example, this script is saved as a file named ``seqtools.py``::

    def remove_at(pos, seq):
        return seq[:pos] + seq[pos+1:]

We can now use our module in both scripts and the Python shell. To do so, we
must first *import* the module.  

.. sourcecode:: python
    
    >>> import seqtools
    >>> s = "A string!"
    >>> seqtools.remove_at(4, s)
    'A sting!'


Notice that  we do not include the ``.py`` file extension when
importing. Python expects the file names of Python modules to end in ``.py``,
so the file extention is not included in the **import statement**.

The use of modules makes it possible to break up very large programs into
managable sized parts, and to keep related parts together.

.. index:: namespace

Namespaces
----------

.. sidebar:: How are namespaces, files and modules related?

  Python has a convenient and simplifying one-to-one mapping, one module per file, 
  giving rise to one namespace. Also, Python takes the module name from the file name,
  and this becomes the name of the namespace.  ``math.py`` is a filename, the module
  is called ``math``, and its namespace is ``math``.
  So in Python the concepts are more or less interchangeable.
  
  But you will encounter other languages (e.g. C#), that allow one module 
  to span multiple files, or one file to have multiple namespaces, 
  or many files to all share the same namespace. So the name of the file doesn't
  need to be the same as the namespace.   
  
  So a good idea is to try to keep the concepts distinct in your mind.  
  
  Files and directories organize *where* things are stored in our computer.  
  On the other hand, namespaces and modules are a programming concept: 
  they help us organize how we want to group related functions and attributes.  
  They are not about "where" to store things, and should not have to 
  coincide with the file and directory structures.
  
  So in Python, if you rename the file ``math.py``, its module name also changes, 
  your ``import`` statements would need to change, and your code that refers to
  functions or attributes inside that namespace would also need to change.  
  
  In other languages this is not necessarily the case.  So don't blur the concepts,
  just because Python blurs them!

A **namespace** is a collection of identifiers that belong to 
a module, or to a function, (and as we will see soon, in classes too).  Generally,
we like a namespace to hold "related" things, e.g. all the math functions, or all
the typical things we'd do with random numbers.
 
Each module has its own namespace, so we can use the same identifier name in
multiple modules without causing an identification problem.

.. sourcecode:: python
    
    # module1.py
    
    question = "What is the meaning of life, the Universe, and everything?"
    answer = 42

.. sourcecode:: python
    
    # module2.py
    
    question = "What is your quest?"
    answer = "To seek the holy grail." 

We can now import both modules and access ``question`` and ``answer`` in each:

.. sourcecode:: python
    
    import module1
    import module2
    
    print(module1.question)
    print(module2.question)
    print(module1.answer)
    print(module2.answer)
    
will output the following::

    What is the meaning of life, the Universe, and everything?
    What is your quest?
    42
    To seek the holy grail.
    
Functions also have their own namespaces:

.. sourcecode:: python
    
    def f():
        n = 7
        print("printing n inside of f:", n)

    def g():
        n = 42
        print("printing n inside of g:", n)

    n = 11
    print("printing n before calling f:", n)
    f()
    print("printing n after calling f:", n)
    g()
    print("printing n after calling g:", n)

Running this program produces the following output:

.. sourcecode:: python
    
    printing n before calling f: 11
    printing n inside of f: 7
    printing n after calling f: 11
    printing n inside of g: 42
    printing n after calling g: 11

The three ``n``'s here do not collide since they are each in a different
namespace --- they are three names for three different variables, just like
there might be three different instances of people, all called "Bruce".

Namespaces permit several programmers to work on the same project without
having naming collisions.

.. index:: scope, scope; global, scope; local, scope; builtin, builtin scope, global scope, local scope
    
Scope and lookup rules
----------------------

The **scope** of an identifier is the region of program code in which the 
identifier can be accessed, or used.  

There are three important scopes in Python:

* **Local scope** refers to identifiers declared within a function.  These identifiers are kept
  in the namespace that belongs to the function, and each function has its own namespace. 
* **Global scope** refers to all the identifiers declared within the current module, or file.  
* **Built-in scope** refers to all the identifiers built into Python --- those like ``range`` and
  ``min`` that can be used without having to import anything, and are (almost) always available.
  
Python (like most other computer languages) uses precedence rules: the same name could occur in
more than one of these scopes, but the innermost, or local scope, will always take
precedence over the global scope, and the global scope always gets used in preference to the
built-in scope.  Let's start with a simple example:

.. sourcecode:: python
    
    def range(n):
        return 123*n
        
    print(range(10))
    
What gets printed?  We've defined our own function called ``range``, so there
is now a potential ambiguity.  When we use ``range``, do we mean our own one,
or the built-in one?  Using the scope lookup rules determines this: our own
range function, not the built-in one, is called, because our function ``range``
is in the global namespace, which takes precedence over the built-in names.

So although names likes ``range`` and ``min`` are built-in, they can be "hidden"
from your use if you choose to define your own variables or functions that reuse
those names.  (It is a confusing practice to redefine built-in names --- so to be 
a good programmer you need to understand the scope rules and understand 
that you can do nasty things that will cause confusion, and then you avoid doing them!)  

Now, a slightly more complex example:

.. sourcecode:: python
   :linenos:

   n = 10
   m = 3
   def f(n):
      m = 7
      return 2*n+m
      
   print(f(5), n, m)
    
This prints 17 10 3.  The reason is that the two variables ``m`` and ``n`` in lines 1 and 2
are outside the function in the global namespace.  Inside the function, new variables
called ``n`` and ``m`` are created *just for the duration of the execution of f*. These are 
created in the local namespace of function ``f``.  Within the body of ``f``, the scope lookup rules
determine that we use the local variables m and n.  By contrast, after we've returned from ``f``,
the ``n`` and ``m`` arguments to the ``print`` function refer to the original variables
on lines 1 and 2, and these have not been changed in any way by executing function ``f``.

Notice too that the ``def`` puts name ``f`` into the global namespace here.  So it can be
called on line 7.

What is the scope of the variable ``n`` on line 1?  Its scope --- the region in which it is
visible ---  is lines 1, 2, 6, 7.  It is hidden from view in lines 3,4,5 because of the 
local variable ``n``.

.. index:: attribute, dot operator
   
Attributes and the dot operator
-------------------------------

Variables defined inside a module are called **attributes** of the module. 
We've seen that objects have attributes too: for example, most objects have
a ``__doc__`` attribute, some functions have a ``__annotations__`` attribute.
Attributes are accessed by using the **dot operator** ( ``.``). The ``question`` attribute
of ``module1`` and ``module2`` are accessed using ``module1.question`` and
``module2.question``.

Modules contain functions as well as attributes, and the dot operator is used
to access them in the same way. ``seqtools.remove_at`` refers to the
``remove_at`` function in the ``seqtools`` module.

When we use a dotted name, we often refer to it as a **fully qualified name**,
because we're saying exactly which ``question`` attribute we mean.
    
.. index:: import statement  
    
Three ``import`` statement variants
-----------------------------------
    
Here are three different ways to import names into the current namespace, and to use them::

    import math
    x = math.sqrt(10)

Here just the single identifier ``math`` is added to the current namespace.  If you want to 
access one of the functions in the module, you need to use the dot notation to get to it.

Here is a different arrangement::

    from math import cos, sin, sqrt
    x = sqrt(10)

The names are added directly to the current namespace, and can be used without qualification. The name
``math`` is not itself imported, so trying to use the qualified form ``math.sqrt`` would give an error.
 
Then we have a convenient shorthand:: 
    
    from math import *   # import all the identifiers from math,
                         # adding them to the current namespace.
    x = sqrt(10)         # Use them without qualification.
    
Of these three, the first method is generally preferred, even though it means
a little more typing each time. (But hey, with nice editors that do auto-completion,
and fast fingers, that is a small price.)

Finally, observe this case::

    def area(radius):
        import math
        return math.pi * r * r
         
    x = math.sqrt(10)      # this gives an error
    
Here we imported ``math``, but we imported it into the local namespace of ``area``.
So the name is usable within the function body, but not in the enclosing script,
because it is not in the global namespace. 

Turn your unit tester into a module
-----------------------------------

Near the end of Chapter 6 we introduced unit testing, and our own ``test``
function, and you've had to copy this into each module for which you 
wrote tests.   Now we can put that definition into a module of its
own, say ``my_own_unit_tester.py``, and simply use one line in each new script instead::

    from my_own_unit_tester import test

.. index:: file   
    
Reading and writing files
-------------------------

While a program is running, its data is stored in *random access memory* (RAM).
RAM is fast and inexpensive, but it is also **volatile**, which means that when
the program ends, or the computer shuts down, data in RAM disappears. To make
data available the next time you turn on your computer and start your program,
you have to write it to a **non-volatile** storage medium, such a hard drive,
usb drive, or CD-RW.

Data on non-volatile storage media is stored in named locations on the media
called **files**. By reading and writing files, programs can save information
between program runs.

Working with files is a lot like working with a notebook. To use a notebook,
you have to open it. When you're done, you have to close it.  While the
notebook is open, you can either write in it or read from it. In either case,
you know where you are in the notebook. You can read the whole notebook in its
natural order or you can skip around.

All of this applies to files as well. To open a file, you specify its name and
indicate whether you want to read or write. 

Opening a file creates a file object. In this example, the variable ``myfile``
refers to the new object.

.. sourcecode:: python
    
    myfile = open('test.dat', 'w')

The open function takes two arguments. The first is the name of the file, and
the second is the **mode**. Mode ``'w'`` means that we are opening the file for
writing.

If there is no file named ``test.dat``, it will be created. If there already is
one, it will be replaced by the file we are writing.

To put data in the file we invoke the ``write`` method on the object:

.. sourcecode:: python
    
    myfile.write("Now is the time")
    myfile.write("to close the file")

Closing the file tells the system that we are done writing and makes
the file available for reading:

.. sourcecode:: python
    
    myfile.close()

Now we can open the file again, this time for reading, and read the
contents into a string. This time, the mode argument is ``'r'`` for reading:

.. sourcecode:: python
    
    >>> myfile = open('test.dat', 'r')

If we try to open a file that doesn't exist, we get an error:

.. sourcecode:: python
    
    >>> myfile = open('test.cat', 'r')
    IOError: [Errno 2] No such file or directory: 'test.cat'

Not surprisingly, the ``read`` method reads data from the file. With no
arguments, it reads the entire contents of the file into a single
string:

.. sourcecode:: python
    
    >>> text = myfile.read()
    >>> print(text)
    Now is the timeto close the file

There is no space between time and to because we did not write a space
between the strings.

``read`` can also take an argument that indicates how many characters to read:

.. sourcecode:: python
    
    >>> myfile = open('test.dat', 'r')
    >>> print(myfile.read(5))
    Now i

If not enough characters are left in the file, ``read`` returns the remaining
characters. When we get to the end of the file, ``read`` returns the empty
string:

.. sourcecode:: python
    
    >>> print(myfile.read(1000006))
    s the timeto close the file
    >>> print(myfile.read())
       
    >>>

The following function copies a file, reading and writing up to fifty
characters at a time. The first argument is the name of the original file; the
second is the name of the new file:

.. sourcecode:: python
    
    def copy_file(oldfile, newfile):
        infile = open(oldfile, 'r')
        outfile = open(newfile, 'w')
        while True:
            text = infile.read(50)
            if text == "":
                break
            outfile.write(text)
        infile.close()
        outfile.close()

This functions continues looping, reading 50 characters from ``infile`` and
writing the same 50 charaters to ``outfile`` until the end of ``infile`` is
reached, at which point ``text`` is empty and the ``break`` statement is
executed.

.. index:: file; text,  text file

Text files
----------

A **text file** is a file that contains printable characters and whitespace,
organized into lines separated by newline characters.  Since Python is
specifically designed to process text files, it provides methods that make the
job easy.

Notice the subtle difference in abstraction here: in the previous section, we
simply regarded a file as containing many characters, and could read them one
at a time, many at a time, or all at once.  In this section, specifically for
reading data, we're interested in files that are organized into lines, 
and will process them line-at-a-time.

To demonstrate, we'll create a text file with three lines of text separated by
newlines:

.. sourcecode:: python
    
    >>> outfile = open("test.dat","w")
    >>> outfile.write("line one\nline two\nline three\n")
    >>> outfile.close()

The ``readline`` method reads all the characters up to and including the
next newline character:

.. sourcecode:: python
    
    >>> infile = open("test.dat","r")
    >>> print(infile.readline())
    line one
       
    >>>


``readlines`` returns all of the remaining lines as a list of strings:

.. sourcecode:: python

    
    >>> print(infile.readlines())
    ['line two\n', 'line three\n']


In this case, the output is in list format, which means that the
strings appear with quotation marks and the newline character appears
at the end of each.

At the end of the file, ``readline`` returns the empty string and
``readlines`` returns the empty list:

.. sourcecode:: python
    
    >>> print(infile.readline())
       
    >>> print(infile.readlines())
    []

The following is an example of a line-processing program. ``filter`` makes a
copy of ``oldfile``, omitting any lines that begin with ``#``:

.. sourcecode:: python
    
    def filter(oldfile, newfile):
        infile = open(oldfile, 'r')
        outfile = open(newfile, 'w')
        while True:
            text = infile.readline()
            if text == "":
               break
            if text[0] == '#':
               continue
            outfile.write(text)
        infile.close()
        outfile.close()
        return

The **continue statement** ends the current iteration of the loop, but
continues looping. The flow of execution moves to the top of the loop, checks
the condition, and proceeds accordingly.

Thus, if ``text`` is the empty string, the loop exits. If the first character
of ``text`` is a hash mark, the flow of execution goes to the top of the loop.
Only if both conditions fail do we copy ``text`` into the new file.

.. index:: directory

Directories
-----------

Files on non-volatile storage media are organized by a set of rules known as a
**file system**. File systems are made up of files and **directories**, which
are containers for both files and other directories.

When you create a new file by opening it and writing, the new file goes in the
current directory (wherever you were when you ran the program). Similarly, when
you open a file for reading, Python looks for it in the current directory.

If you want to open a file somewhere else, you have to specify the **path** to
the file, which is the name of the directory (or folder) where the file is
located:

.. sourcecode:: python
    
    >>> wordsfile = open('/usr/share/dict/words', 'r')
    >>> wordlist = wordsfile.readlines()
    >>> print(wordlist[:6])
    ['\n', 'A\n', "A's\n", 'AOL\n', "AOL's\n", 'Aachen\n']

This (unix) example opens a file named ``words`` that resides in a directory named
``dict``, which resides in ``share``, which resides in ``usr``, which resides
in the top-level directory of the system, called ``/``. It then reads in each
line into a list using ``readlines``, and prints out the first 5 elements from
that list.  

A Windows path might be ``"c:/temp/words.txt"`` or ``"c:\\temp\\words.txt"``.
Because backslashes are used to escape things like newlines and tabs, you need 
to write two backslashes in a literal string to get one!  So the length of these two
strings is the same!

You cannot use ``/`` or ``\`` as part of a filename; they are reserved as a **delimiter**
between directory and filenames.

The file ``/usr/share/dict/words`` should exist on unix-based systems, and
contains a list of words in alphabetical order.


What about fetching something from the web?
-------------------------------------------

The Python libraries are pretty messy in places.  But here is a very
simple example that copies a web URL to a local file, and then opens
and prints the file contents using the techniques we've covered above.

.. sourcecode:: python
    :linenos:
    
    import urllib.request

    url = 'http://www.cs.ru.ac.za/courses/CSc102/pythons.txt' 
    destination_filename = 'c:\\temp\\tempfile.txt'
    
    wf = urllib.request.urlretrieve(url, destination_filename)

    f = open(destination_filename)
    s = f.read()
    f.close()
    print(s)
    
The ``urlretrieve`` function collects the resource at the url, and
saves it to a local file.  You could use this to download any kind
of content from Internet.
   
You'll need to get a few things right before this works:  
 * The page you're trying to fetch must exist!  Check this using a browser.
 * You'll need permission to write to the destination filename.
 * If you are behind a proxy server, (as many students are), this may
   require some more special handling to work around your proxy. 
   Use a local text resource for the purpose of this demonstration! 
  

Counting Letters
----------------

The ``ord`` function returns the integer representation of a character:

.. sourcecode:: python
    
    >>> ord('a')
    97
    >>> ord('A')
    65
    >>>

This example explains why ``'Apple' < 'apple'`` evaluates to ``True``.

The ``chr`` function is the inverse of ``ord``. It takes an integer as an
argument and returns its character representation:

.. sourcecode:: python
    
    >>> for i in range(65, 71):
    ...     print(chr(i))
    ...
    A
    B
    C
    D
    E
    F
    >>>

The following program, ``countletters.py`` counts the number of times each
character occurs in the book `Alice in Wonderland <./resources/ch10/alice_in_wonderland.txt>`__:

.. sourcecode:: python
    
    #
    # countletters.py
    #
    
    def display(i):
        if i == 10: return 'LF'
        if i == 13: return 'CR' 
        if i == 32: return 'SPACE' 
        return chr(i)
    
    infile = open('alice_in_wonderland.txt', 'r')
    text = infile.read()
    infile.close()
    
    counts = 128 * [0]
    
    for letter in text:
        counts[ord(letter)] += 1
    
    layout = "{0:>12} {1:>5}\n"
    outfile = open('alice_counts.dat', 'w')
    outfile.write(layout.format("Character", "Count"))
    outfile.write("============ =====\n")
    
    for i in range(len(counts)):
        if counts[i] > 0:
            outfile.write(layout.format(display(i), counts[i]))
    
    outfile.close()

Run this program and look at the output file it generates using a text editor.
You will be asked to analyze the program in the exercises below.


Glossary
--------

.. glossary::


    argv
        ``argv`` is short for *argument vector* and is a variable in the
        ``sys`` module which stores a list of command line arguments passed to
        a program at run time.

    attribute
        A variable defined inside a module (or class or instance -- as we will
        see later). Module attributes are accessed by using the **dot
        operator** ( ``.``).

    command line
        The sequence of characters read into the *command interpreter* in a
        *command line interface* (see the Wikipedia article on
        `command line interface <http://en.wikipedia.org/wiki/Command_line>`__
        for more information).

    command line argument
        A value passed to a program along with the program's invocation at the
        *command prompt* of a command line interface (CLI).

    command prompt
        A string displayed by a `command line interface
        <http://en.wikipedia.org/wiki/Command_line>`__ indicating that commands
        can be entered.

    continue statement
        A statement that causes the current iteration of a loop to be skipped. The
        flow of execution goes back to the top of the loop, evaluates the condition,
        and proceeds accordingly, so further execution of the loop body may still take
        place.

    delimiter
        A sequence of one or more characters used to specify the boundary
        between separate parts of text.

    directory
        A named collection of files, also called a folder.  Directories can
        contain files and other directories, which are refered to as
        *subdirectories* of the directory that contains them.

    dot operator
        The dot operator ( ``.``) permits access to attributes and functions of
        a module (or attributes and methods of a class or instance -- as we
        have seen elsewhere).

    file
        A named entity, usually stored on a hard drive, floppy disk, or CD-ROM,
        that contains a stream of characters.

    file system
        A method for naming, accessing, and organizing files and the data they
        contain. 
            
    fully qualified name
        A name that is prefixed by some namespace identifier and the dot operator, or
        by an instance object, e.g. ``math.sqrt`` or ``tess.forward(10)``.

    import statement
        A statement which makes the objects contained in a module available for
        use within another module. There are two forms for the import
        statement. Using a hypothetical module named ``mymod`` containing
        functions ``f1`` and ``f2``, and variables ``v1`` and ``v2``, examples
        of these two forms include:

            .. sourcecode:: python
            
                import mymod 

            and

            .. sourcecode:: python

                from mymod import f1, f2, v1, v2 

            The second form brings the imported objects into the namespace of
            the importing module, while the first form preserves a seperate
            namespace for the imported module, requiring ``mymod.v1`` to access
            the ``v1`` variable.

    Jython
        An implementation of the Python programming language written in Java.
        (see the Jython home page at `http://www.jython.org
        <http://www.jython.org>`__ for more information.)

    method
        Function-like attribute of an object. Methods are *invoked* (called) on
        an object using the dot operator. For example:

        .. sourcecode:: python
        
            >>> s = "this is a string."
            >>> s.upper()
            'THIS IS A STRING.'
            >>>

        We say that the method, ``upper`` is invoked on the string, ``s``.
        ``s`` is implicitely the first argument to ``upper``.

    mode
        A distinct method of operation within a computer program.  Files in
        Python can be openned in one of three modes: read (``'r'``), write
        (``'w'``), and append (``'a'``).

    module
        A file containing Python definitions and statements intended for use in
        other Python programs. The contents of a module are made available to
        the other program by using the ``import`` statement.

    namespace
        A syntactic container providing a context for names so that the same
        name can reside in different namespaces without ambiguity. In Python,
        modules, classes, functions and methods all form namespaces.

    naming collision
        A situation in which two or more names in a given namespace cannot be
        unambiguously resolved. Using

        .. sourcecode:: python

            import string

        instead of

        .. sourcecode:: python
        
            from string import *

        prevents naming collisions.
        
    non-volatile memory
        Memory that can maintain its state without power. Hard drives, flash
        drives, and rewritable compact disks (CD-RW) are each examples of
        non-volatile memory.

    path
        A sequence of directory names that specifies the exact location of a
        file.

    standard library
        A library is a collection of software used as tools in the development
        of other software. The standard library of a programming language is
        the set of such tools that are distributed with the core programming
        language.  Python comes with an extensive standard library.

    text file
        A file that contains printable characters organized into lines
        separated by newline characters.

    volatile memory
        Memory which requires an electrical current to maintain state. The
        *main memory* or RAM of a computer is volatile.  Information stored in
        RAM is lost when the computer is turned off.
 
Exercises
---------

#. Every week a computer scientist buys four lotto tickets. He always choses the 
   same prime numbers, with the hope that he ever hits the jackpot, others
   will suddenly get interested in prime numbers.  He represents his weekly tickets
   in Python as a list of lists::

        my_tickets = [ [ 7, 17, 37, 19, 23, 43], 
                       [ 7,  2, 13, 41, 31, 43], 
                       [ 2,  5,  7, 11, 13, 17], 
                       [13, 17, 37, 19, 23, 43] ]
                       
   Complete these exercises.
    
   a. Each lotto draw takes six random balls, numbered from 1 to 49.  Write
      a function to return a lotto draw.
   b. Write a function that returns compares a single ticket and a draw, and returns
      the number of correct picks on that ticket::
      
        test(lotto_match([42, 4, 7, 11, 1, 13], [2, 5, 7, 11, 13, 17]), 3)
         
   c. Write a function that takes a list of tickets and a draw, and returns a list 
      telling how many picks were correct on each ticket::
      
        test(lotto_matches([42, 4, 7, 11, 1, 13], my_tickets), [1, 2, 3, 1])
      
   d. Write a function that takes a list of integers, and returns the number of primes in the list::
   
        test(primes_in([42, 4, 7, 11, 1, 13]), 3)
   
   e. Write a function to discover whether the computer scientist has missed any
      prime numbers in his selection of the four tickets.  Return a list of all primes that he has missed::
      
         test(prime_misses(my_tickets), [3, 29, 47])
         
   f. Write a function that repeatedly makes a new draw, and compares the draw to the four tickets.
   
      i. Count how many draws are needed until one of the computer scientist's tickets has at least 
         3 correct picks.
         Try the experiment twenty times, and average out the number of draws needed.
       
      ii. How many draws are needed, on average, before he gets at least 4 picks correct?  
              
      iii. How many draws are needed, on average, before he gets at least 5 correct?  (Hint: this
           might take a while.  It would be nice if you could print some dots, like a progress bar,
           to show when each of the 20 experiments has completed.)

      Notice that we have difficulty constructing test cases here, because our random numbers
      are not deterministic. Automated testing only really works if you already know what 
      the answer should be! 

#. Open help for the ``calendar`` module. 

    a. Try the following:
 
         .. sourcecode:: python
            
            import calendar
            cal = calendar.TextCalendar()      # create an instance
            cal.pryear(2011)                   # What happens here?

    b. Observe that the week starts on Monday. An adventurous CompSci student
       believes that it is better mental chunking to have his week start on
       Thursday, because then there are only two working days to the weekend, and
       every week has a break in the middle.  Read the documentation for TextCalendar, 
       and see how you can help him print a calendar that suits his needs. 
    
    c. Find a function to print just the month in which your birthday occurs this year.

    d. Try this::
    
         d = calendar.LocaleTextCalendar(6, "SPANISH")    # create an instance
         d.pryear(2011)   
        
       Try a few other languages, including one that doesn't work, and see what happens.
        
    e. Experiment with ``calendar.isleap``. What does it expect as an
       argument? What does it return as a result? What kind of a function is this?

   Make detailed notes about what you learned from htese exercises.
   
#. Open help for the ``math`` module. 

   a. How many functions are in the ``math`` module?
   b. What does ``math.ceil`` do? What about ``math.floor``? ( *hint:* both
      ``floor`` and ``ceil`` expect floating point arguments.)
   c. Describe how we have been computing the same value as ``math.sqrt``
      without using the ``math`` module.
   d. What are the two data contstants in the ``math`` module?

   Record detailed notes of your investigation in this exercise.
   
#. Investigate the ``copy`` module. What does ``deepcopy``
   do? In which exercises from last chapter would ``deepcopy`` have come in
   handy?
   
#. Create a module named ``mymodule1.py``. Add attributes ``myage`` set to
   your current age, and ``year`` set to the current year. Create another
   module named ``mymodule2.py``. Add attributes ``myage`` set to 0, and
   ``year`` set to the year you were born. Now create a file named
   ``namespace_test.py``. Import both of the modules above and write the
   following statement:

   .. sourcecode:: python
    
        print( (mymodule2.myage - mymodule1.myage) == (mymodule2.year - mymodule1.year))

   When you will run ``namespace_test.py`` you will see either ``True`` or
   ``False`` as output depending on whether or not you've already had your
   birthday this year.
   
#. Add the following statement to ``mymodule1.py``, ``mymodule2.py``, and
   ``namespace_test.py`` from the previous exercise:

   .. sourcecode:: python
    
        print("My name is", __name__)

   Run ``namespace_test.py``. What happens? Why? Now add the following to the
   bottom of ``mymodule1.py``:

   .. sourcecode:: python
    
        if __name__ == '__main__':
            print("This won't run if I'm  imported.")

   Run ``mymodule1.py`` and ``namespace_test.py`` again. In which case do you
   see the new print statement?
   
#. In a Python shell try the following:

   .. sourcecode:: python
    
        >>> import this

   What does Tim Peter's have to say about namespaces?
   
#. Rewrite ``matrix_mult`` from the last chapter using what you have learned
   about list methods.
   
#. Give the Python interpreter's response to each of the following from a
   continuous interpreter session:

   .. sourcecode:: python
    
      >>> s = "If we took the bones out, it wouldn't be crunchy, would it?"
      >>> s.split()
      >>> type(s.split())
      >>> s.split('o')
      >>> s.split('i')
      >>> '0'.join(s.split('o'))
          
   Be sure you understand why you get each result. Then apply what you have
   learned to fill in the body of the function below using the ``split`` and
   ``join`` methods of ``str`` objects:

   .. sourcecode:: python
    
        def myreplace(old, new, s):
            """ Replace all occurences of old with new in the string s. """
            ...
            
            
        test(myreplace(',', ';', 'this, that, and some other thing'),
                                 'this; that; and some other thing')
        test(myreplace(' ', '**', 'Words will now      be  separated by stars.'),
                                  'Words**will**now**be**separated**by**stars.')
    
   Your solution should pass the tests.
   
#. Create a module named ``wordtools.py`` with our test scaffolding in place.

   Now add functions to these tests pass::
   
        test(cleanword('what?'),  'what')
        test(cleanword('"now!"'), 'now')
        test(cleanword('?+="w-o-r-d!,@$()"'),  'word')
    
        test(has_dashdash('distance--but'), True)
        test(has_dashdash('several'), False)
        test(has_dashdash('spoke--'), True)
        test(has_dashdash('distance--but'), True)
        test(has_dashdash('-yo-yo-'), False)

        test(extract_words('Now is the time!  "Now", is the time? Yes, now.'),
              ['now', 'is', 'the', 'time', 'now', 'is', 'the', 'time', 'yes', 'now'])
        test(extract_words('she tried to curtsey as she spoke--fancy'),
              ['she', 'tried', 'to', 'curtsey', 'as', 'she', 'spoke', 'fancy'])
    
        test(wordcount('now', ['now', 'is', 'time', 'is', 'now', 'is', 'is']), 2)
        test(wordcount('is', ['now', 'is', 'time', 'is', 'now', 'is', 'the', 'is']), 4)
        test(wordcount('time', ['now', 'is', 'time', 'is', 'now', 'is', 'is']), 1)
        test(wordcount('frog', ['now', 'is', 'time', 'is', 'now', 'is', 'is']), 0)
    
        test(wordset(['now', 'is', 'time', 'is', 'now', 'is', 'is']), 
              ['is', 'now', 'time'])
        test(wordset(['I', 'a', 'a', 'is', 'a', 'is', 'I', 'am']),
              ['I', 'a', 'am', 'is'])
        test(wordset(['or', 'a', 'am', 'is', 'are', 'be', 'but', 'am']),
              ['a', 'am', 'are', 'be', 'but', 'is', 'or'])
       
        test(longestword(['a', 'apple', 'pear', 'grape']), 5)
        test(longestword(['a', 'am', 'I', 'be']), 2)
        test(longestword(['this', 'that', 'supercalifragilisticexpialidocious']), 34)
        test(longestword([ ]), 0)

   Save this module so you can use the tools it contains in future programs.
   
#. `unsorted_fruits.txt <resources/ch10/unsorted_fruits.txt>`__ contains a
   list of 26 fruits, each one with a name that begins with a different letter
   of the alphabet. Write a program named ``sort_fruits.py`` that reads in the
   fruits from ``unsorted_fruits.txt`` and writes them out in alphabetical
   order to a file named ``sorted_fruits.txt``.
   
#. Answer the following questions about ``countletters.py``:

   a. Explain in detail what the three lines do:

      .. sourcecode:: python
        
            infile = open('alice_in_wonderland.txt', 'r')
            text = infile.read()
            infile.close()

      What would ``type(text)`` return after these lines have been executed?
      
   b. What does the expression ``128 * [0]`` evaluate to? Read about `ASCII
      <http://en.wikipedia.org/wiki/ASCII>`__ in Wikipedia and explain why you 
      think the variable, ``counts`` is assigned to ``128 * [0]`` in light of
      what you read.
      
   c. What does

      .. sourcecode:: python
        
            for letter in text:
                counts[ord(letter)] += 1

      do to ``counts``?
      
   d. Explain the purpose of the ``display`` function. Why does it check for
      values ``10``, ``13``, and ``32``? What is special about those values?
      
   e. Describe in detail what the lines

      .. sourcecode:: python
        
            layout = "{0:>9} {1:>5}\n"
            outfile = open('alice_counts.dat', 'w')
            outfile.write(layout.format("Character", "Count"))
                          outfile.write("========= =====\n")

      do. What will be in ``alice_counts.dat`` when they finish executing?
      
   f. Finally, explain in detail what

      .. sourcecode:: python
        
            for i in range(len(counts)):
                if counts[i] > 0:
                    outfile.write(layout.format(display(i), counts[i]))

      does. 

