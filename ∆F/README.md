<div class="right-margin-bar"> 
<div class="pMarquee">

***∆F*** is a function for *Dyalog* APL that interprets *f‑strings*, 
a concise, yet powerful way to display multiline APL text, arbitrary 
APL expressions, and multi&shy;dimensional objects using extensions to 
*dfns* and other familiar tools.

</div>

# Table of Contents  

<details id="TOC">     <!-- option: open  Set id="TOC" here only. -->
<summary class="summary">&ensp;Show/Hide <em>Table of Contents</em></summary>
<span style="font-size:75%;">

- [Table of Contents](#table-of-contents)
- [Installing and Running **∆F** in Dyalog APL](#installing-and-running-f-in-dyalog-apl)
  - [Installing **∆F**](#installing-f)
  - [Running **∆F** (After It's Been Installed)](#running-f-after-its-been-installed)
- [Overview](#overview)
- [Displaying ∆F **Help** in APL](#displaying-f-help-in-apl)
- [∆F Examples: A Primer](#f-examples-a-primer)
  - [Code Fields](#code-fields)
  - [Text Fields and Space Fields](#text-fields-and-space-fields)
  - [Null Space Fields](#null-space-fields)
  - [Code Fields (Continued)](#code-fields-continued)
  - [The Box Shortcut](#the-box-shortcut)
  - [Box Mode](#box-mode)
  - [Omega Shortcuts (Explicit)](#omega-shortcuts-explicit)
  - [Referencing the f‑string Itself](#referencing-the-fstring-itself)
  - [The Format Shortcut](#the-format-shortcut)
  - [The Shortcut for Numeric Commas](#the-shortcut-for-numeric-commas)
  - [Self-documenting **Code** fields (SDCFs)](#self-documenting-code-fields-sdcfs)
  - [The Above Shortcut](#the-above-shortcut)
  - [Text Justification Shortcut](#text-justification-shortcut)
  - [Omega Shortcuts (Implicit)](#omega-shortcuts-implicit)
  - [Shortcuts With Individual Expressions](#shortcuts-with-individual-expressions)
  - [A Shortcut for Dates and Times (Part I)](#a-shortcut-for-dates-and-times-part-i)
  - [A Shortcut for Dates and Times (Part II)](#a-shortcut-for-dates-and-times-part-ii)
  - [The Quote Shortcut](#the-quote-shortcut)
  - [The Wrap Shortcut (Experimental)](#the-wrap-shortcut-experimental)
  - [The Session Library Shortcut (Experimental)](#the-session-library-shortcut-experimental)
    - [Explicitly Copied Library Objects](#explicitly-copied-library-objects)
    - [Automatically Copied Library Objects](#automatically-copied-library-objects)
    - [Session Variables](#session-variables)
  - [Precomputed f‑strings with the ***dfn*** Option](#precomputed-fstrings-with-the-dfn-option)
- [∆F Syntax and Other Information](#f-syntax-and-other-information)
  - [∆F Call Syntax Overview](#f-call-syntax-overview)
  - [∆F Option Details](#f-option-details)
  - [∆F Return Value](#f-return-value)
  - [∆F F‑string Building Blocks](#f-fstring-building-blocks)
  - [Code Field Shortcuts](#code-field-shortcuts)
  - [Escape Sequences For Text Fields and Quoted Strings](#escape-sequences-for-text-fields-and-quoted-strings)
  - [Quoted Strings in Code Fields](#quoted-strings-in-code-fields)
  - [Omega Shortcut Expressions: Details](#omega-shortcut-expressions-details)
  - [Wrap Shortcut: Details](#wrap-shortcut-details)
  - [Session Library Shortcut: Details](#session-library-shortcut-details)
    - [Session Library Shortcut: Filetypes of Source Files](#session-library-shortcut-filetypes-of-source-files)
    - [Session Library Shortcut: Parameters](#session-library-shortcut-parameters)
- [Appendices](#appendices)
  - [Appendix I: Un(der)documented Features](#appendix-i-underdocumented-features)
    - [∆F Option for Dfn Source Code](#f-option-for-dfn-source-code)
    - [∆F Help's Secret Variant](#f-helps-secret-variant)
  - [Appendix II: Python f‑strings](#appendix-ii-python-fstrings)

---

</span>
</details>

# Installing and Running **∆F** in Dyalog APL

<details open>            <!-- option: open -->
<summary class="summary">&ensp;Show/Hide <em>Installing and Running <bold>∆F</bold></em>
</summary>

## Installing **∆F**

1. On Github, search for <mark>"f‑string-apl"</mark>. 
   - During the test phase, go to <mark>github.com/petermsiegel/f‑string-apl</mark>. 
2. Note your current directory. 
3. Copy the file  **∆F.dyalog** and directory **∆F** (which contains several files) into the current working directory,
ensuring they are peers. 
1. Confirm that your current directory remains as before.
2. Then, from your Dyalog session (typically `#` or `⎕SE`), enter:<br>
  `]←load ∆F [-target=`<code>**_anyNs_**]</code> 
   1. Each time it is called, the `]load` will create function **∆F** and namespace **⍙Fapl** in the target namespace.
      1. **⍙Fapl** contains utilities used by **∆F** and, once`]load`ed, ***should not*** be moved. 
      2. **∆F** *may* be relocated; it will refer to **⍙Fapl** in its original location.
   2. If **∆F_Help.html** is available at `]load` time, it will be copied into **⍙Fapl** (or a message will note its absence).

Now, **∆F** is available for use.

## Running **∆F** (After It's Been Installed)

1. `]←load ∆F [-target=`<code>***anyNs***]</code> (see above), ensuring that **∆F** is executable from the current namespace.  
2. Call `∆F` with the desired argument(s) and [options](#f-call-syntax-details). **∆F** is `⎕IO`- and `⎕ML`-independent. 

---

</details>

# Overview  

<details open><summary class="summary">&ensp;Show/Hide <em>Overview</em></summary>

 
Inspired by [Python f‑strings](#appendix-ii-python-fstrings), **∆F** includes a variety of capabilities to make it easy to evaluate, format, annotate, and display related multi&shy;dimensional information. 

**∆F** *f‑strings* include: 

- The abstraction of 2-dimensional character ***fields***, generated one-by-one from the user's specifications and data, then aligned and catenated into a single overall character matrix result;
  


- **Text** fields, supporting multiline Unicode text within each field, with the sequence `` `◇ `` (**backtick** + **statement separator**) generating a newline, <small>`⎕UCS 13`</small>; 

- **Code** fields, allowing users to evaluate and display APL arrays of any dimensionality, depth and type in the user environment, arrays passed as **∆F** arguments, as well as arbitrary APL expressions based on full multi-statement dfn 
logic. Each **Code** field must return a value, simple or otherwise, which will be catenated with other fields and returned from **∆F**;

  **Code** fields also provide a number of concise, convenient extensions, such as:

  - **Quoted strings** in **Code** fields, with several quote styles:

    - **double-quotes**<br>
      `∆F '{"like this"}'` or `` ∆F '{"on`◇""three""`◇lines"} ``,
    - **double angle quotation marks**,<br>
      `∆F '{«with internal quotes like "this" or ''this''»}'`, not to mention   
    -  APL's tried-and-true embedded **single-quotes**,<br>
      `∆F '{''shown ''''right'''' here''}'`.

  - Simple shortcuts for

    - **format**ting numeric arrays, **\$** (short for **⎕FMT**):<br>`∆F '{"F7.5" $ ?0 0}'`,
    - putting a **box** around a specific expression, **\`B**:<br>`` ∆F'{`B ⍳2 2}' ``,
    - placing the output of one expression **above** another, **%**:<br>`∆F'{"Pi"% ○1}'`,
    - formatting **date** and **time** expressions from APL timestamps (**⎕TS**) using **\`T** (combining&nbsp;**1200⌶** and **⎕DT**): <br>` ∆F'{"hh:mm:ss" `T ⎕TS}' ``,
    - _and more_;

  - Simple mechanisms for concisely formatting and displaying data from
    - user arrays or arbitrary code:<br>`tempC←10 110 40`<br>`∆F'{tempC}'` or `∆F'{ {⍵<100: 32+9×⍵÷5 ◇ "(too hot)"}¨tempC }'`,
      <br>
    - arguments to **∆F** that follow the format string:<br>`` ∆F'{32+`⍵1×9÷5}' (10 110 40) ``,<br> where `` `⍵1 `` is a shortcut for `(⍵⊃⍨1+⎕IO)` (here `10 110 40`),
    - _and more_;

- **Space** fields, providing a simple mechanism both for separating adjacent **Text** fields and inserting (rectangular) blocks of any number of spaces between any two fields, where needed;

  - one space: `{ }`; five spaces: `{     }`; or even, zero spaces: `{}`;
  - 1000 spaces? Use a **Code** field instead: `{1000⍴""}`.

- Multiline (matrix) output built up field-by-field, left-to-right, from values and expressions in the calling environment or arguments to **∆F**;

  - After all fields are generated, they are aligned vertically, then concatenated to form a single character matrix: ***the return value from*** **∆F**.  
  
**∆F** is designed for ease of use, _ad hoc_ debugging, fine-grained formatting and informal user interaction, built using Dyalog functions and operators. 

<details open>     <!-- option: open -->
<summary class="summary">&ensp;Recap: <em>The Three Field Types</em></summary><br>  


   | Field Type | Syntax | Examples | Displaying |
   |:------------:|:--------:|:---------:|:---------:|
   | **Text** | *Unicode text* | `` abc`◇def `` | 2-D Text  |
   | **Code** | `{`*dfn code plus*`}` | `{(32+9×÷∘5)degC}`<br> `{↑"one" "two"}` | Arbitrary APL<br>expressions via dfns |
   | **Space** | `{`<big>␠ ␠ ␠</big>`}` | `{  }` &ensp; `{}`| Spacing & Field Separation |
<div>
Table 3a. <strong>The Three Field Types</strong>
</div> 

<br>
</details> 
</details>

# Displaying ∆F **Help** in APL 


<span style="font-size: 130%;">👉 </span>To display this **HELP** information, type: `∆F⍨ 'help'`.

# ∆F Examples: A Primer

<details open>            <!-- option: open -->
<summary class="summary">&ensp;Show/Hide <em>Examples: A Primer</em></summary>


Before providing information on **∆F** syntax and other details, *let's start with some examples*…

First, let's set some context for the examples. (You can set these however you want.)  


```
   ⎕IO ⎕ML← 0 1        
```


## Code Fields

Here are **Code** fields with simple variables. 


```
   name← 'Fred' ◇ age← 43
   ∆F 'The patient''s name is {name}. {name} is {age} years old.'
The patient's name is Fred. Fred is 43 years old.
```


**Code** fields can contain arbitrary expressions. With default options, **∆F** always
returns a single character matrix.
Here **∆F** returns a matrix with 2 rows and 32 columns. 


```
   tempC← ⍪35 85
   ⍴⎕← ∆F 'The temperature is {tempC}{2 2⍴"°C"} or {32+tempC×9÷5}{2 2⍴"°F"}'
The temperature is 35°C or  95°F.
                   85°C    185°F
2 32                
```

Here, we assign the *f‑string* to an APL variable, then call **∆F** twice!


```
   ⎕RL← 2342342                 
   n← ≢names← 'Mary' 'Jack' 'Tony' 
   prize← 1000
   f← 'Customer {names⊃⍨ ?n} wins £{?prize}!'
   ∆F f
Customer Jack wins £80!
   ∆F f
Customer Jack wins £230!
```

Isn't Jack lucky, winning twice in a row!

<details id="pPeek"><summary class="summary">&ensp;View a fancier example...</summary>


<div id="winner1">

``` 
 ⍝ Be sure everyone wins something.
   n← ≢names← 'Mary' 'Jack' 'Tony' 
   prize← 1000
   ∆F '{ ↑names }{ ⍪n⍴ ⊂"wins" }{ "£", ⍕⍪?n⍴ prize}'
Mary wins £711
Jack wins £298
Tony wins £242
```

</div>
</details>

## Text Fields and Space Fields

Below, we have some multi-line **Text** fields separated by non-null **Space** fields.

- The backtick is our "escape" character.
- The sequence `◇ generates a new line in the current text field.
- Each **Space** field `{ }` in the next example contains one space within its braces. It produces a matrix a _single_ space wide with as many rows as required to catenate it with adjacent fields.

A **Space** field is useful here because each multi-line field is built
in its own rectangular space.

```
   ∆F 'This`◇is`◇an`◇example{ }Of`◇multi-line{ }Text`◇Fields'
This    Of         Text
is      multi-line Fields
an
example
```

## Null Space Fields

Two adjacent **Text** fields can be separated by a null **Space** field `{}`,
for example when at least one field contains multiline input that you
want formatted separately from others, keeping each field in is own rectangular space:

```
⍝  Extra space here ↓ 
   ∆F 'Cat`◇Elephant `◇Mouse{}Felix`◇Dumbo`◇Mickey'
Cat      Felix
Elephant Dumbo
Mouse    Mickey
```

In the above example, we added an extra space after the longest
animal name, _Elephant_, so it wouldn't run into the next word, _Dumbo_.

**But wait! There's an easier way!**

Here, you surely want the lefthand field to be guaranteed to have a space
after _each_ word without fiddling; a **Space** field with at least
one space will solve the problem:

```apl
⍝                          ↓↓↓
   ∆F 'Cat`◇Elephant`◇Mouse{ }Felix`◇Dumbo`◇Mickey'
Cat      Felix
Elephant Dumbo
Mouse    Mickey
```

## Code Fields (Continued)


And this is the same example with *identical* output, but built using two **Code** fields 
separated by a **Text** field with a single space.


```
   ∆F '{↑"Cat" "Elephant" "Mouse"} {↑"Felix" "Dumbo" "Mickey"}'
Cat      Felix
Elephant Dumbo
Mouse    Mickey
```

Here's a similar example with double quote-delimited strings in **Code** fields with
the newline sequence, `` `◇ ``:

```
   ∆F '{"This`◇is`◇an`◇example"} {"Of`◇Multi-line"} {"Strings`◇in`◇Code`◇Fields"}'
This    Of         Strings
is      Multi-line in
an                 Code
example            Fields
```

Here is some multiline data we'll add to our **Code** fields.


```
   fNm←  'John' 'Mary' 'Ted'
   lNm←  'Smith' 'Jones' 'Templeton'
   addr← '24 Mulberry Ln' '22 Smith St' '12 High St'
   
   ∆F '{↑fNm} {↑lNm} {↑addr}'
John Smith     24 Mulberry Ln
Mary Jones     22 Smith St
Ted  Templeton 12 High St
```



Here's a slightly more interesting code expression, using `$` (a shortcut for `⎕FMT`)
to round Centigrade numbers to the nearest whole degree and Fahrenheit numbers to the nearest tenth of a degree.

```
   cv← 11.3 29.55 59.99
   ∆F 'The temperature is {"I2" $ cv}°C or {"F5.1"$ 32+9×cv÷5}°F'
The temperature is 11°C or  52.3°F
                   30       85.2
                   60      140.0
```

## The Box Shortcut  
We now introduce the **Box** shortcut `` `B ``. Here we place boxes around key **Code** fields in this same example.

```
   cv← 11.3 29.55 59.99
   ∆F '`◇The temperature is {`B "I2" $ cv}`◇°C or {`B "F5.1" $ 32+9×cv÷5}`◇°F'
                   ┌──┐      ┌─────┐
The temperature is │11│°C or │ 52.3│°F
                   │30│      │ 85.2│
                   │60│      │140.0│
                   └──┘      └─────┘
```

## Box Mode

But what if you want to place a box around every **Code**, **Text**, **_and_** **Space** field?
We just use the **Box** mode option!

While we can't place boxes around text (or space) fields using `` `B ``,
we can place a box around ***each*** field (*regardless* of type) by setting **∆F**'s *third* option, **Box** [mode](#f-call-syntax-details), to `1`:

```
   cv← 11.3 29.55 59.99
       ↓¯¯¯ Box mode
   0 0 1 ∆F '`◇The temperature is {"I2" $ cv}`◇°C or {"F5.1" $ 32+9×cv÷5}`◇°F'
┌───────────────────┬──┬──────┬─────┬──┐
│                   │11│      │ 52.3│  │
│The temperature is │30│°C or │ 85.2│°F│
│                   │60│      │140.0│  │
└───────────────────┴──┴──────┴─────┴──┘
```

We said you could place a box around every field, but there's an exception.
Null **Space** fields `{}`, *i.e.* 0-width **Space** fields, are discarded once they've done their work of separating adjacent fields (typically **Text** fields), so they won't be placed in boxes. 

Try this expression on your own:

```
   0 0 1 ∆F 'abc{}def{}{}ghi{""}jkl{ }mno'
```

<details id="pPeek"><summary class="summary">&ensp;Peek</summary>


```
   0 0 1 ∆F 'abc{}def{}{}ghi{""}jkl{ }mno'
┌───┬───┬───┬┬───┬─┬───┐ 
│abc│def│ghi││jkl│ │mno│ 
└───┴───┴───┴┴───┴─┴───┘

```

</details>

In contrast, **Code** fields that return null values (like `{""}` above) _will_ be displayed!

## Omega Shortcuts (Explicit)  

> Referencing **∆F** arguments after the *f‑string*: **Omega** shortcut expressions like `` `⍵1 ``.

The expression 

`` `⍵1 `` is equivalent to `(⍵⊃⍨ 1+⎕IO)`, selecting the first argument after the *f‑string*. Similarly, `` `⍵99 `` would select `(⍵⊃⍨99+⎕IO)`.

We will use `` `⍵1 `` here, both with shortcuts and an externally defined
function `C2F`, that converts Centigrade to Fahrenheit.
A bit further [below](#omega-shortcuts-implicit), we discuss bare `` `⍵ ``
(*i.e.* without an appended non-negative integer).

```
   C2F← 32+9×÷∘5
   ∆F 'The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ C2F `⍵1}°F' (11 15 20)
The temperature is 11°C or 51.8°F
                   15      59.0
                   20      68.0
```

## Referencing the f‑string Itself 


The expression `` `⍵0 `` always refers to the *f‑string* itself. Try this yourself.

```
   bL bR← '«»'                     ⍝ ⎕UCS 171 187
   ∆F 'Our string {bL, `⍵0, bR} has {≢`⍵0} characters.'
```

<details id="pPeek"><summary class="summary">&ensp;Peek</summary>

```
   bL bR← '«»'                     ⍝ ⎕UCS 171 187
   ∆F 'Our string {bL, `⍵0, bR} has {≢`⍵0} characters.'
Our string «Our string {bL, `⍵0, bR} has {≢`⍵0} characters» has 47 characters.
```

<details id="pPeek"><summary class="summary">&ensp;Let's check our work...</summary>

```
   ≢'Our string {bL, `⍵0, bR} has {≢`⍵0} characters.'
47
``` 

</details>
</details>

## The Format Shortcut

 (short for `⎕FMT`) can also be used monadically, but **∆F** will handle that for you in most cases.
</span>

> Let's add commas to some very large numbers using the **⎕FMT** shortcut `$`.

We can use Dyalog's built-in formatting specifier "C" with shortcut `$` 
to add appropriate commas to the temperatures!


```
⍝  The temperature of the sun at its core in degrees C.
   sun_core← 15E6                   ⍝ 15000000 is a bit hard to parse!
   ∆F 'The sun''s core is at {"CI10" $ sun_core}°C or {"CI10" $ C2F sun_core}°F'
The sun's core is at 15,000,000°C or 27,000,032°F
```

## The Shortcut for Numeric Commas 


The shortcut for *Numeric* **Commas**  `` `C `` adds commas every 3 digits (from the right) to one or more numbers or numeric strings.It has an advantage over the `$` (Dyalog's `⎕FMT`) specifier: it doesn't require you to guesstimate field widths.


Let's use the `` `C `` shortcut to add the commas to the temperatures!


```
   sun_core← 15E6               ⍝ 15000000 is a bit hard to parse!
   ∆F 'The sun''s core is at {`C sun_core}°C or {`C C2F sun_core}°F.'
The sun's core is at 15,000,000°C or 27,000,032°F.
```

And for a bit of a twist, let's display either degrees Centigrade
or Fahrenheit under user control (`1` => F, `0` => C). Here, we establish
the *f‑string* `sunFC` first, then pass it to **∆F** with an additional right argument.

```
   sunFC← 'The sun''s core is at {`C C2F⍣`⍵1⊢ sun_core}°{ `⍵1⊃ "CF"}.'
   ∆F sunFC 1
The sun's core is at 27,000,032°F.
   ∆F sunFC 0
The sun's core is at 15,000,000°C.
```

Now, let's move on to Self-documenting **Code** fields.

## Self-documenting **Code** fields (SDCFs)

 
> Self-documenting Code fields (SDCFs) are a useful debugging tool.

What's an SDCF? An SDCF allows whatever source code is in a **Code** field to be automatically displayed literally along with the result of evaluating that code.


The source code for a **Code** field can automatically be shown in **∆F**'s output—

- to the *left* of the result of evaluating that code; or,
- centered *above* the result of evaluating that code. 

All you need do is enter

- a right arrow <big>`→`</big> for a **horizontal** SDCF, or
- a down arrow <big>`↓`</big> (or <big>`%`</big>) for a **vertical** SDCF,

as the **_last non-space_** character in the **Code** field, before the _final_ right brace.


Here's an example of a horizontal SDCF, *i.e.* using `→`:

```
   name←'John Smith' ◇ age← 34
   ∆F 'Current employee: {name→}, {age→}.'
Current employee: name→John Smith, age→34.
```

As a useful formatting feature, whatever spaces are just **_before_** or **_after_** the symbol **→** or **↓** are preserved **_verbatim_** in the output.

Here's an example with such spaces: see how the spaces adjacent to the symbol `→` are mirrored in the output!

```
   name←'John Smith' ◇ age← 34
   ∆F 'Current employee: {name → }, {age→ }.'
Current employee: name → John Smith, age→ 34.
```

Now, let's look at an example of a vertical SDCF, *i.e.* using `↓`:

```
   name←'John Smith' ◇ age← 34
   ∆F 'Current employee: {name↓} {age↓}.'
Current employee:  name↓     age↓.
                  John Smith  34
```

To make it easier to see, here's the same result, but with a box around each field (using the **Box** [option](#f-call-syntax-details) `0 0 1`).

```
⍝  Box all fields
   0 0 1 ∆F 'Current employee: {name↓} {age↓}.'
┌──────────────────┬──────────┬─┬────┬─┐
│Current employee: │ name↓    │ │age↓│.│
│                  │John Smith│ │ 34 │ │
└──────────────────┴──────────┴─┴────┴─┘
```

## The Above Shortcut  

> A cut above the rest… 


Here's a useful feature. Let's use the shortcut `%` to display one expression centered above another; 
it's called **Above** and can *also* be expressed as `` `A ``. 


```
   ∆F '{"Employee" % ⍪`⍵1} {"Age" % ⍪`⍵2}' ('John Smith' 'Mary Jones')(29 23)
Employee    Age
John Smith  29
Mary Jones  23
```

## Text Justification Shortcut


The Text **Justification** shortcut `` `J `` treats its right argument as a character array, justifying each line to the left (`⍺="L"`, the default), to the right (`⍺="R"`), or centered (`⍺="C"`). 
If its right argument contains floating point numbers, they will be displayed with the maximum
print precision `⎕PP` available.

``` 
   a← ↑'elephants' 'cats' 'rhinoceroses'
   ∆F '{"L" `J a}  {"C" `J a}  {"R" `J a}' 
elephants      elephants       elephants
cats              cats              cats
rhinoceroses  rhinoceroses  rhinoceroses
```


## Omega Shortcuts (Implicit)  

> The _next_ best thing: the use of `` `⍵ `` in **Code** field expressions…

We said we'd present the use of **Omega** shortcuts with implicit indices `` `⍵ `` in **Code** fields. The expression `` `⍵ `` selects the _next_ element of the right argument `⍵` to **∆F**, defaulting to `` `⍵1 `` when first encountered, *i.e.* if there are **_no_** `` `⍵ `` elements (*explicit* or *implicit*) to the **_left_** in the entire *f‑string*. If there is any such expression (*e.g.* `` `⍵5 ``), then `` `⍵ `` points to the element after that one (*e.g.* `` `⍵6 ``). If the item to the left is `` `⍵ ``, then we simply increment the index by `1` from that one.

**Let's try an example.** Here, we display arbitrary 2-dimensional expressions, one above the other. 
`` `⍵ `` refers to the **_next_** argument in sequence, left to right, starting with `` `⍵1 ``, the first, *i.e.* `(⍵⊃⍨ 1+⎕IO)`. 
So, from left to right `` `⍵ `` is `` `⍵1 ``, `` `⍵2 ``, 
and `` `⍵3 ``. 


```
   ∆F '{(⍳2⍴`⍵) % (⍳2⍴`⍵) % (⍳2⍴`⍵)}' 1 2 3
    0 0
  0 0 0 1
  1 0 1 1
0 0 0 1 0 2
1 0 1 1 1 2
2 0 2 1 2 2
```

Let's demonstrate here the equivalence of the _implicitly_ and _explicitly_ indexed **Omega expressions**!

```
   a← ∆F '{(⍳2⍴`⍵) % (⍳2⍴`⍵) % (⍳2⍴`⍵)}' 1 2 3     ⍝ Implicit Omega expressions
   b← ∆F '{(⍳2⍴`⍵1) % (⍳2⍴`⍵2) % (⍳2⍴`⍵3)}' 1 2 3  ⍝ Explicit Omega expressions
   a ≡ b                                           ⍝ Are they the same?
1                                                  ⍝ Yes!
```

## Shortcuts With Individual Expressions

Shortcuts often make sense with individual expressions, not just entire **Code** fields. They can be manipulated like ordinary APL functions; since they are just that -- ordinary APL functions -- under the covers.
Here, we display one boxed value above the other.

```
   ∆F '{(`B ⍳`⍵1) % `B ⍳`⍵2}' (2 2)(3 3)
  ┌───┬───┐
  │0 0│0 1│
  ├───┼───┤
  │1 0│1 1│
  └───┴───┘
┌───┬───┬───┐
│0 0│0 1│0 2│
├───┼───┼───┤
│1 0│1 1│1 2│
├───┼───┼───┤
│2 0│2 1│2 2│
└───┴───┴───┘
```

<details id="pPeek"><summary class="summary">&ensp;Peek: Shortcuts are just Functions</summary>

While not for the faint of heart, the expression above can be recast as this 
concise alternative: 

``` 
   ∆F '{%/ `B∘⍳¨ `⍵1 `⍵2}' (2 2)(3 3)
```

</details

> There are loads of other examples to discover.

## A Shortcut for Dates and Times (Part I)  


**∆F** supports a simple **Date-Time** shortcut `` `T `` built from **1200⌶** and **⎕DT**. It takes one or more Dyalog `⎕TS`-format timestamps as the right argument and a date-time specification as the (optional) left argument. Trailing elements of a timestamp may be omitted (they will each be treated as `0` in the specification string).

Let's look at the use of the `` `T `` shortcut to show the current time (now).



```
   ∆F 'It is now {"t:mm pp" `T ⎕TS}.'
It is now 8:08 am.
```


Here's a fancier example.
(We've added the _truncated_ timestamp `2025 01 01` right into the *f‑string*.)

```
   ∆F '{ "D MMM YYYY ''was a'' Dddd."`T 2025 01 01}'
1 JAN 2025 was a Wednesday.
```

## A Shortcut for Dates and Times (Part II)

If it bothers you to use `` `T `` for a date-only expression,
you can use `` `D ``, which means exactly the same thing.

```
   ∆F '{ "D MMM YYYY ''was a'' Dddd." `D 2025 01 02}'
2 JAN 2025 was a Thursday.
```

Here, we'll pass the time stamp via a single **Omega**
expression `` `⍵1 ``, whose argument  is passed in parentheses.

```
   ∆F '{ "D Mmm YYYY ''was a'' Dddd." `T `⍵1}' (2025 1 21)
21 Jan 2025 was a Tuesday.
```

We could also pass the time stamp via a sequence of **Omega**
expressions: `` `⍵ `⍵ `⍵ ``.
This is equivalent to the _slightly_ verbose
expression: `` `⍵1 `⍵2 `⍵3 ``.

```
   ∆F '{ "D Mmm YYYY ''was a'' Dddd." `T `⍵ `⍵ `⍵}' 2025 1 21
21 Jan 2025 was a Tuesday.
```
## The Quote Shortcut 

> Placing quotes around string elements of an array.


The **Quote** shortcut `` `Q `` recursively scans its right argument, matching rows of character arrays, character vectors, and character scalars, doubling internal single quotes and placing single quotes around the items found.

Non-character data is returned as is. This is useful, for example, when you wish to clearly distinguish character from numeric data.


Let's look at a couple of simple examples:

First, let's use the `` `Q `` shortcut to place quotes around the simple character
arrays in its right argument, `⍵`. This is useful when you want to distinguish between character output that might include numbers and _actual_ numeric output.

```
   ∆F '{`Q 1 2 "three" 4 5 (⍪1 "2") (⍪"cats" "dogs")}'   
1 2  'three'  4 5     1    'cats'
                    '2'    'dogs'
```

And here's an example with a simple, mixed vector (*i.e.* a mix of character and numeric scalars only). We'll call the object `iv`, but we won't disclose its definition yet.

Let's display `iv` without using the **Quote** shortcut.

```
   iv← ...
   ∆F '{iv}'
1 2 3 4 5
```

Are you **_sure_** which elements of `iv` are numeric and which character scalars?

<details id="pPeek"><summary class="summary">&ensp;Peek to see the example with `iv` defined.</summary>

```
   iv← 1 2 '3' 4 '5'
   ∆F '{iv}'
1 2 3 4 5
```

</details>

Now, we'll show the variable `iv` using the  **Quote** `` `Q `` shortcut.

```
   iv← 1 2 '3' 4 '5'
   ∆F '{`Q iv}'
```

<details id="pPeek"><summary class="summary">&ensp;Take a peek at the <bold>∆F</bold> output.</summary>

```
1 2 '3' 4 '5'
```

</details>

Voilà, quotes appear around the character digits, but not the actual APL numbers!


## The Wrap Shortcut <span class="red">(Experimental)</span>

<div class="test-feature">

> Wrapping results in left and right decorators...


The shortcut **Wrap** `` `W `` is <span class="red">**_experimental_**</span>. `` `W `` is used 
when you want to place a **_decorator_** string immediately to the left or right of **_each_** row of simple objects in the right argument, `⍵`. It differs from the **Quote** shortcut `` `Q ``, which puts quotes **_only_** around the character arrays in `⍵`. 


- The decorators are in `⍺`, the left argument to **Wrap**: the left decorator, `0⊃2⍴⍺`, and the right decorator, `1⊃2⍴⍺`, with `⍺` defaulting to a single quote.
- If you need to omit one or the other decorator, simply make it a null string `""` or a _zilde_&nbsp;`⍬`.

**Here are two simple examples.**

In the first, we place `"°C"` after **[a]** each row of a table `` ⍪`⍵2 ``, or **[b]** after each simple vector in `` ,¨`⍵2 ``. We indicate that is no _left_ decorator here
using `""` or `⍬`, as here.

```
⍝         ... [a] ...       .... [b] ....
    ∆F '{ `⍵1 `W ⍪`⍵2 } ...{ `⍵1 `W ,¨`⍵2 }' (⍬ '°C')(18 22 33)
18°C ... 18°C 22°C 33°C
22°C
33°C
```

In this next example, we place brackets around the lines of each simple array in a complex array.

```
   ∆F '{"[]" `W ("cats")(⍳2 2 1)(2 2⍴⍳4)(3 3⍴⎕A) }'
[cats] [0 0 0] [0 1] [ABC]
       [0 1 0] [2 3] [DEF]
                     [GHI]
       [1 0 0]
       [1 1 0]
```

<div id="winner2">


Now, let's try recasting an earlier example to use **Wrap** `` `W ``.


```
   n← ≢names← 'Mary' 'Jack' 'Tony' 
   prize← 1000
   ∆F '{ ↑names }{ ⍪n⍴ ⊂"wins" }{ "£", ⍕⍪?n⍴ prize }'
```

</div>
<details id="pPeek"><summary class="summary">&ensp;Below is one solution...</summary>



```
   n← ≢names← 'Mary' 'Jack' 'Tony' 
   prize← 1000                              
   ∆F '{ ↑names } { "wins " "" `W "£", ⍕⍪?n⍴ prize }'
Mary wins £201
Jack wins £ 73
Tony wins £349
```

</details>
</div>

## The Session Library Shortcut <span class="red">(Experimental)</span>

<div class="test-feature">
 
The shortcut (Session) **Library** `£`  is <span class="red">**experimental**</span>. 
`£` denotes 

a "private" *user* namespace in **⍙Fapl**,
into which the user may place and manipulate  useful objects for the duration
of the ***current*** *APL* session. For example, the user may wish to:  

- have automatically available regularly used functions or operators, *or*  
- create objects that might be referred to, monitored, or modified during the session. 

### Explicitly Copied Library Objects

In this example, the user wants to generate all primes between 1 and 100 using
two routines in the ***dfns*** workspace, `sieve` and `to`. To achieve this,
we copy both routines from ***dfns***.



```
    ∆F '{"sieve" "to" £.⎕CY "dfns"}{£.sieve 2 £.to 100}'
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
```

On subsequent calls, `sieve` and `to` are already available, as we can see here:

```
    ∆F '{ £.⎕NL ¯3 }'
 sieve  to 
```

### Automatically Copied Library Objects

> But, **∆F** provides a simpler solution! 

If 
the user references a name of the form 
`£.name` that 
has not (yet) been defined in the library, 
an attempt is made to copy that name into the library either from the **dfns** workspace  or from a text file; if the name appears to the left-side of a **simple** assigment `←`, it is assumed to exist (as always).  

<span style="font-size: 130%;">👉 </span>
If **∆F** is unable to find the item during its search, a standard *APL* error will be signaled.

In this next example, we use *for the first time* the function `pco` from the 
`dfns` workspace. 

```
    ∆F '{ ⍸ 1 £.pco ⍳100 }' 
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 
```

<details id="pPeek"><summary class="summary">Peek: Using the <em><bold>debug</bold></em> (debug) option</summary>

> First use of a *dfns* function, using **∆F**'s ***debug*** option:
> 
``` 
    0 1 ∆F '{ ⍸ 1 £.pco ⍳100 }' 
DEBUG: Copied "pco" into £=[⎕SE.⍙Fapl.ûLib] from "ws:dfns"
{ ⎕SE.⍙Fapl.M ⌽⍬({⍸ 1 ⎕SE.⍙Fapl.ûLib.pco ⍳100}⍵)}⍵
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
```

</details>

The function is quietly copied in and is available *without the overhead
of copying* for the rest of this *APL* session. 



### Session Variables

Here is an example where we define a local session variable `ctr`, 
a counter of the number of times a particular
statement is executed. Since we define the counter, `£.ctr←0`, 
**∆F** makes ***no*** attempt to copy it from the `dfns` workspace or a file.

```
   ∆F '{ ⍬⊣£.ctr←0 }'         ⍝ Initialise £.ctr.
   t← 'We''ve been called {£.ctr← £.ctr+1} times.'
⍝  ...                    
   ∆F t
We've been called 1 times.
   ∆F t
We've been called 2 times.
```
This may be sensible when ∆F is called from a variety of namespaces and/or
if the user doesn't wish to clutter the active namespace.


<span style="font-size: 130%;">👉 </span>
When a *dfn* created via **∆F** with the ***dfn*** option runs, any uses of `£` will 
require the associated ⍙Fapl namespace to be present.


</div>

## Precomputed f‑strings with the ***dfn*** Option

 
The default returned from **∆F** is always (on success) a character matrix. That can be expressed schematically via expression *(a),* shown here: 

    (a) 0 ∆F… 


However, if the initial [∆F Option](#f-call-syntax-details),&ensp;***dfn***, is `1`, as in *(b),*

    (b) 1 ∆F… 
    
then  **∆F** returns a **dfn** that, *when called later*, will return precisely the same character expression as for *(a)*.
This is most useful when you are making repeated use of an *f‑string*, since the overhead for analyzing the *f‑string* contents _once_ will be amortized over ***all*** the calls.


Let's explore an example where getting the best performance for a heavily
used **∆F** string is important. 

First, let's grab `cmpx` and set the variable `cv`, so we can compare the performance…

```
   'cmpx' ⎕CY 'dfns'
   cv← 11 30 60 
```

Now, let's proceed. Here's our **∆F** String `t`:

``` 
   t←'The temperature is {"I2" $ cv}°C or {"F5.1" $ F← 32+9×cv÷5}°F'
``` 

<details id="pPeek"><summary class="summary">Evaluate <code>∆F t</code>...</summary>

```
   ∆F t 
The temperature is 11°C or  51.8°F
                   30       86.0  
                   60      140.0  
```

</details>

Let's precompute a dfn `T`, given the string `t`.&ensp;`T` has everything needed to generate the output (given the same definition of the vector `cv`, when `T` is evaluated).

``` 
   T← 1 ∆F t
``` 

<details id="pPeek"><summary class="summary">Evaluate <code>T ⍬</code>...</summary>

```
   T ⍬
The temperature is 11°C or  51.8°F
                   30       86.0  
                   60      140.0  
```

</details>

Now, let's compare the performance of the two formats. 

```               
   cmpx '∆F t' 'T ⍬'
∆F t → 1.7E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕
 T ⍬ → 1.0E¯5 | -94% ⎕⎕
```

The precomputed version is about <mark>17 times faster</mark>, at least in this run.

Before we get to syntax and other information, we want to show you 
that 
the _dfn_ returned via the ***dfn*** option can retrieve one or more arguments passed on the right side of **∆F**, using the very same omega shortcut expressions (like `` `⍵1 ``) we've 
discussed above.

Let's share the Centigrade values `cv` from our current example,
not as a *variable*, but as the *first argument* to **∆F**. 
We'll access the value as `` `⍵1` ``.

```
   t←'The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ F← 32+9×`⍵1÷5}°F'
   T← 1 ∆F t

   ∆F t (11 30 60)
The temperature is 11°C or  51.8°F
                   30       86.0  
                   60      140.0 

   T ⊂(11 30 60)
The temperature is 11°C or  51.8°F
                   30       86.0  
                   60      140.0 

   cmpx '∆F t (11 30 60)' 'T ⊂(11 30 60)'
∆F t 35 → 1.8E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕
   T 35 → 1.2E¯5 | -94% ⎕⎕
```
The precomputed version shows a comparable speedup over the default version, 
around <mark>15 times faster</mark>.

---

Below, we summarize key information you've already gleaned from the examples.

</details>


# ∆F Syntax and Other Information

<details open>        <!-- option: open -->       
<summary class="summary">&ensp;Show/Hide <em>Syntax Info</em></summary>

## ∆F Call Syntax Overview

| Call Syntax<div style="width:290px"></div> | Description |
| :----- | :---------- |
| **∆F**&ensp;***f‑string*** | Display an _f‑string_; use the _default_ options. The string may reference objects in the environment or in the string itself. Returns a character matrix. |
| **∆F**&ensp;***f‑string***&ensp;***args*** | Display an _f‑string_; use the _default_ options. Arguments presented _may_ be referred to in the f‑string. Returns a character matrix. |
| ***options***&ensp;**∆F**&ensp;***f‑string***&ensp;[***args***] | Display an _f‑string_; control the result with _options_ specified (see below). <br>If ***dfn*** (see below) is `0` or omitted, returns a character matrix.<br>If ***dfn*** is `1`, returns a dfn that will display such a matrix (given an identical system state). |
| 'help'&ensp;**∆F**&ensp;' ' | Display help info and examples for **∆F**. The _f‑string_ is not examined. |
| **∆F**⍨'help' | Display help info and examples for **∆F**. |
| **_return value_** | *See below.* |
<div>Table 6a. <strong>∆F Call Syntax Overview</strong></div>

<br>

## ∆F Option Details

|<center>Positional<div style="width:150px"></div>Option</center>|Keyword: *default* |Description |
| :----- | :----: | :---------- |
| &emsp;***options[0]***:<br>&emsp;&emsp;*output mode*|***dfn:&nbsp;0***| If ***dfn:&nbsp;1***, **∆F** returns a dfn, which (upon execution) produces the same output as the default mode.<br>If ***dfn:&nbsp;0*** (default): **∆F** returns a char. matrix. |
| &emsp;***options[1]:***<br>&emsp;&emsp;*debug mode*|***debug:&nbsp;0***| If ***debug:&nbsp;1***, Renders newline characters from `` `◇ `` as the visible `␤` character. Displays the source code that the *f‑string* **_actually_** generates; if ***dfn*** is also `1`, this will include the embedded *f‑string* source (accessed as `` `⍵0 ``).  After the source code is displayed, it will be executed or converted to a *dfn* and returned (see the ***dfn*** option above).<br>If ***debug:&nbsp;0*** (default): Newline characters from `` `◇ `` are rendered normally as carriage returns, `⎕UCS 13`; the ***dfn*** source code is not displayed.      |
| &emsp;***options[2]***:<br>&emsp;&emsp;*box mode*|***box:&nbsp;0***| If ***box:&nbsp;1***, each field (except a null **Text** field) is boxed separately.<br>If ***box:&nbsp;0*** (default), nothing is boxed automatically. Any **Code** field expression may be explicitly boxed using the **Box** shortcut, `` `B ``.<br>***box*** **mode can be used both with** ***dfn*** **and default output mode.**</small> |
| &emsp;***options[3]***:<br>&emsp;&emsp;*auto mode*|***auto:&nbsp;1***| If ***auto:&nbsp;0***, user must manually load/create any Session Library objects for use with the £ or `` `L `` shortcuts.<br>If ***auto:&nbsp;1*** (default), honors the default and user-defined settings for `auto`.|
| &emsp;***options[4]***:<br>&emsp;&emsp;*inline mode*|***inline:&nbsp;0***| If ***inline:&nbsp;1*** and ***dfn:&nbsp;1***, the code for each internal support function used is included in the *dfn* result; ***no*** reference to namespace **⍙Fapl** will be made during the execution of that *dfn*.<br>If ***inline:&nbsp;0*** (default), whenever **∆F** or a *dfn* generated by it is executed, it makes calls to library routines in the namespace **⍙Fapl**, created during the `]load ∆Fapl` process.<br><small>**This option is experimental and may simply disappear one day.**</small> |
| &emsp;'help' || If `'help'` is specified, this amazing doc&shy;ument&shy;ation is displayed. |
<div>Table 6b. <strong>∆F Option Details</strong></div>


- **Default options:** If the left argument `⍺` is omitted, the options default to

    | Option Style | Defaults |
    | :--- | :--- |
    | *Positional style* |`0 0 0 1 0`|
    | *Keyword style*    |`(dfn: 0, debug: 0, box: 0, auto: 1, inline: 0)`|

- **Positional style options:** If the left argument `⍺` is a simple integer vector or scalar, or an empty numeric vector `⍬`, the options are 
  
      5↑ ⍺, 0 0 0 1 0↑⍨ 5-⍨ ≢⍺ 
    Trailing elements are ignored.
- **Keyword style options:** If the left argument is a namespace,
it is assumed to contain the options in (APL Array Notation) keyword form,<br>&emsp;&emsp;e.g. `(debug: 1 ◇ auto: 0)`;  
    Keyword options are new for Dyalog 20. They are sometimes clearer and more convenient than positional keywords.
- **Help option:** If the left argument `⍺` starts with `'help'` (case ignored), this help information is displayed. In this case only, the right argument to **∆F** is ignored.
- Otherwise, an error is signaled.

## ∆F Return Value

- Unless the ***dfn*** option is selected, **∆F** always returns a character matrix of at least one row and zero columns, `1 0⍴0`, on success. If the 'help' option is specified, **∆F** displays this information, returning `1 0⍴0`.
- If the ***dfn*** option is selected, **∆F** always returns a standard Dyalog dfn on success.
- On failure of any sort, an informative APL error is signaled.

## ∆F F‑string Building Blocks

The first element in the right arg to ∆F is a character vector, an *f‑string*,
which contains one or more **Text** fields, **Code** fields, and **Space** fields in any combination.

- **Text** fields consist of simple text, which may include any Unicode characters desired, including newlines. 
  - Newlines (actually, carriage returns, `⎕UCS 13`) are normally entered via the sequence `` `◇ ``. 
  - Additionally, literal curly braces can be added via `` `{ `` and `` `} ``, so they are distinct from the simple curly braces used to begin and end **Code** fields and **Space** fields. 
  - Finally, to enter a single backtick `` ` `` just before the special
symbols `{`, `}`, `◇`, or `` ` ``, enter ***two*** backticks ` `` `; if preceding any ordinary 
symbol, a ***single*** backtick will suffice.
  - If **∆F** is called with an empty string, `∆F ''`, it is interpreted as containing a single 0-length **Text** field, returning a matrix of shape `1 0`.
- **Code** fields are run-time evaluated expressions enclosed within
  simple, unescaped curly braces `{ }`, *i.e.* those not preceded by a backtick (see the previous paragraph). 
  - **Code** fields are, under the covers, Dyalog *dfns* with some extras. 
  - For escape sequences, see **Escape Sequences** below.
- **Space** fields appear to be a special, _degenerate_, form of **Code** fields, consisting of a single pair of simple (unescaped) curly braces `{}` with zero or more spaces in between. 
  - A **Space** field with zero spaces is a ***null*** **Space** field; while it may separate any other fields, its typical use is to separate two adjacent **Text** fields.
  - Between fields, **∆F** adds no automatic spaces; that spacing is under user control.

## Code Field Shortcuts

**∆F** **Code** fields may contain various shortcuts, intended to be concise and expressive tools for common tasks. **Shortcuts** are valid in **Code** fields only *outside* **Quoted strings**. 

**Shortcuts** include:

| Shortcut<div style="width:100px"></div> | Name<div style="width:150px"></div>      | Meaning |
| :----- | :---------- | :----- |
| **\`A**, **%** | Above | `[⍺] % ⍵`. Centers array `⍺` above array `⍵`.<br>If omitted, `⍺←''`, *i.e.* a blank line. |
| **\`B** | Box | `` `B ⍵ ``. Places `⍵` in a box. `⍵` is any array. |
| **\`C** | Commas | `` `C ⍵ ``. Adds commas to `⍵` after every 3rd digit of the integer part of `⍵`, right-to-left. `⍵` is a vector of num strings or numbers. |
| **\`D** | Date-Time | Synonym for **\`T**. |
| **\`F**, **$** | ⎕FMT | `[⍺] $ ⍵`. Short for `[⍺] ⎕FMT ⍵`. (See APL doc&shy;ument&shy;ation). |
| **\`J** | Justify | `` [⍺] `J ⍵ ``. Justify each row of object `⍵` as text:<br>&emsp;&emsp;*left*: ⍺="L"; *center*: ⍺="C"; *right* ⍺="R".<br>You may use `¯1`\|`0`\|`1` in place of `"L"`\|`"C"`\|`"R"`. If omitted, `⍺←'L'`. <small>*Displays numbers with the maximum precision available.*</small> |
| **\`L**, **£** | Session Library<br><span class="red"><small>**EXPERIMENTAL!**</small></span> | `£`. `£` denotes a private library (namespace) local to the **∆F** runtime environ&shy;ment into which functions or objects (including name&shy;spaces) may be placed (e.g. via `⎕CY`) for the duration of the *APL* session. <small>Outside of simple assignments, **∆F** will attempt to copy undefined objects from workspace `dfns` or from directory **./MyDyalogLib** (with file extensions **.aplf**, **.aplo**, **.apla**, *etc.*). *See [Session Library Shortcut: Details](#session-library-shortcut-details) below.*</small>|
| **\`Q** | Quote | `` [⍺]`Q ⍵ ``. Recursively scans `⍵`, putting char. vectors, scalars, and rows of higher-dimensional strings in APL quotes, leaving other elements as is. If omitted, `⍺←''''`. |
| **\`T** | Date-Time | `` [⍺]`T ⍵ ``. Displays timestamp(s) `⍵` according to date-time template `⍺`. `⍵` is one or more APL timestamps `⎕TS`. `⍺` is a date-time template in `1200⌶` format. If omitted, `⍺← 'YYYY-MM-DD hh:mm:ss'`. |
| **\`W** | Wrap <span class="red"><small>**EXPERIMENTAL!**</small></span>    | `` [⍺]`W ⍵ ``. Wraps the rows of simple arrays in ⍵ in decorators `0⊃2⍴⍺` (on the left) and `1⊃2⍴⍺` (on the right). If omitted, `⍺←''''`. <small>_See details below._</small> |
| **\`⍵𝑑𝑑**, **⍹𝑑𝑑** | Omega Shortcut (<small>EXPLICIT</small>) | A shortcut of the form `` `⍵𝑑𝑑 `` (or `⍹𝑑𝑑`), to access the `𝑑𝑑`**th** element of `⍵`, *i.e.* `(⍵⊃⍨ 𝑑𝑑+⎕IO)`. <small>_See details below._</small>|
| **\`⍵**, **⍹** | Omega Shortcut (<small>IMPLICIT</small>) | A shortcut of the form `` `⍵ `` (or `⍹`), to access the **_next_** element of `⍵`. <small>_See details below._ <small>|
| **→**<br>**↓** *or* **%** | Self-documenting **Code** Fields <small>(SDCFs)</small>| `→`/`↓` (synonym: `%`) signal that the source code for the **Code** field appears before/above its value. Surrounding blanks are significant. <small>*See [SDCFs](#self-documenting-code-fields-sdcfs) in __Examples__ for details.*</small> |
<div>Table 6c. <strong>Code Field Shortcuts</strong></div>

<br>

## Escape Sequences For Text Fields and Quoted Strings

 
**∆F** **Text** fields and **Quoted strings** in **Code** fields may include
a small number of escape sequences, beginning with the backtick `` ` ``. 
Some sequences are valid in **Text** fields *only*, but not in Quoted strings:



| Escape Sequence | What It Inserts | Description | Where Special |
| :-------------: | :-------------: | :---------: | :----:  | 
|     **\`◇**     |    *newline*    |   ⎕UCS 13   | Both|
|    **\`\`**     |        `        |  backtick   | Both|
|     **\`{**     |        {        | left brace  | Text fields only |
|     **\`}**     |        }        | right brace | Text fields only |
<div>Table 6d. <strong>Escape Sequences</strong></div>


Other instances of the backtick character in **Text** fields or **Quoted strings** in **Code** fields will be treated literally, _i.e._
sometimes a backtick is just a backtick. 

## Quoted Strings in Code Fields 

As mentioned in the introduction, **Quoted strings** in **Code** fields allow several delimiting quote styles:

- **double-quotes**<br>
  `∆F '{"like «this» one"}'` or `∆F '{"like ''this'' one."}'`,
- **double angle quotation marks**,<br>
  `∆F '{«like "this" or ''this''.»}'`,  
as well as  
-  APL's tried-and-true embedded **single-quotes**,<br>
  `∆F '{''shown like ''''this'''', "this" or «this».''}'`.


If you wish to include a traditional delimiting quote (` ' ` or ` " `) or the closing quote of a quote pair (`«`&ensp;`»`) within the **Quoted string**, you must double it. 
You may *not* use an escape sequence (e.g. `` `" ``) for this purpose. 


| Closing Quote | Example | Result |
| :----:        | :---    | :---   |
| `"` | `∆F '{"like ""this"" example"}'`| `like "this" example` |
|  `»` |   `∆F '{«or «this»» one»}'` | `or «this» one`|
|  `'` |     `∆F '{''or ''''this'''' one''}'` | `or 'this' one`|
<div>Table 6e. <strong>Closing Quotes</strong></div>


Note that the opening quote ` « ` is treated as an ordinary character within the string. The clumsiness of the standard single quote ` ' ` examples is due to the fact that the single quote is the required delimiter for the outermost (APL-level) string. 


## Omega Shortcut Expressions: Details

1.  **⍹** is a synonym for **\`⍵**. It is Unicode character `⎕UCS 9081`. Either expression is valid only in **Code** fields and outside **Quoted strings**.
2.  **\`⍵** or **⍹** uses an "_omega index counter_" (**OIC**) which we'll represent as **Ω**, common across all **Code** fields, which is initially set to zero, `Ω←0`. (**Ω** is just used for explication; don't actually use this symbol)
3.  All **Omega** shortcut expressions in the *f‑string* are evaluated left to right and are ⎕IO-independent.
4.  **\`⍵𝑑𝑑** or **⍹𝑑𝑑** sets the _OIC_ to 𝑑𝑑, `Ω←𝑑𝑑`, and returns the expression `(⍵⊃⍨Ω+⎕IO)`. Here **𝑑𝑑** must be a _non-negative integer_ with at least 1 digit.
5.  Bare **\`⍵** or **⍹** (*i.e.* with no digits appended) increments the _OIC_, `Ω+←1`, _before_ using it as the index in the expression `(⍵⊃⍨Ω+⎕IO)`.
6.  The _f‑string_ itself (the 0-th element of **⍵**) is always accessed as `` `⍵0 `` or `⍹0`. The omega with _implicit index_ always increments its index _before_ use, *i.e.*  starting by default with `` `⍵1 `` or `⍹1`.
7.  If an element of the dfn's right argument **⍵** is accessed at runtime via any means, shortcut or traditional, that element **_must_** exist.

<div class="test-feature">


## Wrap Shortcut: Details

1. Syntax: `` [⍺←''''] `W ⍵ ``.
2. Let `L←0⊃2⍴⍺` and `R←1⊃2⍴⍺`.
3. Wrap each row `X′` of the simple arrays `X` in `⍵` (or the entire array `X` if a simple vector or scalar) in decorators `L` and `R`: `L,(⍕X′),R`.
4. `⍵` is an array of any shape and depth.`L`and `R`are char. vectors or scalars or `⍬` (treated as `''`).
5. If there is one scalar or enclosed vector `⍺`, it is replicated _per (2) above_.
6. By default,`⍺← ''''`,*i.e.* APL quotes will wrap the array ⍵, row by row, whether character, numeric or otherwise.


## Session Library Shortcut: Details

1. If 
an object `£.name` is referenced, but not yet defined in `£`, an attempt is made to copy it to `£` from workspace `dfns` and/or from  files **name.aplf** (for functions), **name.aplo** (for operators), *etc.* 
in files in the (user-settable) search path,

    &emsp;&emsp;**./** and **./MyDyalogLib/**, 

&emsp;&emsp;*unless* it is being assigned (via `←`). It will be available for the duration of the session.

1. In the case of a simple assignment (`£.name←...`), the object assigned must be new or
of a compatible *APL* class with its existing value, else a domain error will be signaled. 

1. Modified assignments of the form `£.name+←...` are allowed and treated as in the first case.

### Session Library Shortcut: Filetypes of Source Files



| <br>Filetype |<br>Action| APL Class<br>⎕NC |Key APL<br>Service|Available<br>by Default?|Type <br>Enforced?|
|:-----:|:---------:|:---:|:---:|:----:|:----:|
| aplf | Fixes function| 3 | ⎕FIX | yes | no |
| aplo | Fixes operator | 4 | ⎕FIX | yes | no |
| apln | Fixes namespace | 9 | ⎕FIX | yes | no |
| apla | Assigns APLAN Array| 2, 9 | *assignment* | yes| yes | 
| json | Fixes  namespace from JSON5| 9 | ⎕JSON | yes | yes |  
| txt  | Assigns char. vectors | 2 | *assignment* | yes | yes | 
| *other* | Fixes object | 3, 4, 9 | ⎕FIX | <span class="red">no</span> | no |
<div>Table 6f. <strong>Library Filetypes: Meaning</strong></div>

### Session Library Shortcut: Parameters 

The Session Library shortcut (`£` or `` `L ``) is deceptively simple, but
the code to support 
it is a tad complex. 
The complex library code runs only at `]load` time, with a modest runtime
performance impact&mdash;
if the **auto** parameter is enabled.
If the **auto** parameter is *disabled,* the runtime impact of the feature is more modest still; if *not* used, there is no runtime impact.

There are parameters, optionally tailored via an APL Array Notation parameter file **.&ThinSpace;∆F** (in the current file directory).  Parameters include: 

-  **auto**: the ability to turn on or off any automatic loading
of object definitions from the **dfns** workspace or files; 
-  **path**: what directories to search for the object definitions; and so on.

The parameter file 
is briefly documented *below*. 

<details open><summary class="summary">&ensp;<em>Show/Hide Default APLAN £ibrary Parameter File</em> <big><strong>. ∆F</strong></big></summary>

```apl
(
   ⍝ Default .∆F (APLAN) Parameter File                           
   ⍝ Items not to be (re)set by user should be omitted/commented out.              
   ⍝ Exceptions: 
   ⍝ [1-2] auto and verbose can each be set to null to signal 
   ⍝       that their value should come from the ∆Fapl globals LIB_AUTO or VERBOSE.
   ⍝ [3]   prefix, which if null is the same as [''], i.e. 0-length string prefix.
       
   ⍝ ∆F global variables LIB_AUTO and VERBOSE are set in ∆Fapl.dyalog.
   ⍝ Their usual values are LIB_AUTO← 1 ◇ VERBOSE← 0
   ⍝ The values are explained here:
   ⍝   LIB_AUTO:  1   We want to get library objects from files and/or workspaces,
   ⍝                  using the default or user-specified path.
   ⍝   LIB_AUTO:  0   We don't want to use the LIB_AUTO feature.
   ⍝   VERBOSE:   1   Will display loadtime and runtime msgs, both library-related
   ⍝                  and general.  The debug ∆F option will also display limited 
   ⍝                  runtime msgs.
   ⍝   VERBOSE:   0   Will only display error or important warning msgs.
       
   ⍝ auto:
   ⍝   If 0, user must load own objects; nothing is automatic.                 
   ⍝   If 1, dfns and files searched in sequence set by path (q.v.). 
   ⍝   If ⎕NULL, inherit setting from the LIB_AUTO global 
     auto:  ⎕NULL   
       
   ⍝ verbose: 
   ⍝    If 0, be quiet;  if 1, be verbose.  
   ⍝    If ⎕NULL, inherit setting from VERBOSE global. 
     verbose: ⎕NULL
                                                          
   ⍝ path: The dirs and/or workspaces  to search.  
   ⍝       For a directory, use character vectors
   ⍝           ⊂'MyOnlyDir'      or    ('MyOnlyDir' ◇ )
   ⍝           'Dir1' 'Dir2'     or    ('Dir1' ◇ 'Dir2')
   ⍝       For a workspace, use a single enclosed char vec or a vector of char vectors 
   ⍝       Examples of workspace specs:  
   ⍝            ('dfns'◇)  ('MyDyalogLib/mathfns'◇)  ('dfns' ◇ 'mathfns')
     path: ( './MyDyalogLib' ◇ ('dfns'◇) ◇ '.' )   
                   
   ⍝ prefix: vector of char vectors to prefix to each name, when searching directories.
   ⍝         Ignored for workspaces.
   ⍝         ⍬ is equiv. to (⊂'') or (''◇). 
   ⍝         If the name presented is 'mydfn'
   ⍝         The following 
   ⍝              prefix: ('∆F_' ◇ 'MyLib/')
   ⍝              suffix: ('aplf' ◇)  
   ⍝         will match: 
   ⍝             '∆F_mydfn.aplf' and 'MyLib/mydfn.aplf'   
     prefix: ⍬ 
                               
   ⍝ suffix: at least one suffix is required. The '.' is prepended for you!  
   ⍝         Ignored for workspaces.  
   ⍝         By default,  the generic filetype 'dyalog' and user-defined filetypes
   ⍝         are not enabled.   
     suffix: ('aplf' ◇ 'aplo' ◇ 'apln' ◇ 'apla' ◇ 'json' ◇ 'txt')    
                   
   ⍝  Internal Runtime (hidden) Parameters                                               
     _readParmFi: 0                       ⍝ 0 (zero):  Haven't read .∆F yet. 1 afterwards.     
     _fullPath:   ⍬                       ⍝ ⍬ (zilde): Generated from path and prefixes.  
)  
``` 

</details>

---

</div> 
</details> 

# Appendices
 
<details open><summary class="summary">&ensp;Show/Hide <em>Appendices</em></summary>

## Appendix I: Un(der)documented Features 

### ∆F Option for Dfn Source Code
If `options[0]` is `¯1`, then **∆F** returns a character vector that contains the source code for the *dfn* that would have been returned via the ***dfn*** option, `options[0]=1`. 
If ***debug*** is also set, newlines from `` `◇ `` are shown as visible `␤`. However, since this option *returns* the code string, the ***debug*** option won't also *display* the code string. 

### ∆F Help's Secret Variant
`∆F 'help'` has a secret variant: `∆F 'help-narrow'`. 
With this variant, the help
session will start up with a narrower screen *without* side notes. If the user widens the
screen, the side notes will appear, as in the default 
case: `∆F 'help'`.


## Appendix II: Python f‑strings

<div style="line-height: 1.3;">

&emsp; Python f-strings, introduced in Python 3.6, are a modern and elegant way to format strings by embedding expressions directly inside string literals. You create an f-string by prefixing a string with the letter 'f' or 'F', and then you can include any Python expression inside curly braces within the string. When the string is evaluated, these expressions are executed and their results are automatically converted to strings and inserted at that position.
<br>&emsp; For example, the Python expression&ensp;<strong>`f"The sum of {a} and {b} is {a + b}"`</strong>&ensp;would evaluate the addition and embed the result directly in the string. This combination of simplicity, power, and performance has made f-strings the preferred string formatting approach in modern Python code. *[Claude (AI). Response to Python f-strings query [edited]. Claude.ai. Anthropic, October 19, 2025.]*
</div>

*See* 

<a id="displayText" href="javascript:linkAlert();"><span class="linkNote">https:\//docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals</span></a>.

</div>
</div>


</details>

<!-- Put a set of navigation tools at a fixed position at the bottom of the Help screen
-->
<div class="doc-footer">
⍠⍠⍠&emsp;
<a href="#top">Top</a>
&nbsp;&nbsp;&nbsp;
<a href="#table-of-contents">Contents</a> 
&nbsp;&nbsp;&nbsp;  
<a href="#f-examples-a-primer">Examples</a>
&nbsp;&nbsp;&nbsp; 
<a href="#f-syntax-and-other-information">Syntax</a>
&nbsp;&nbsp;&nbsp; 
<a href="#appendices">Appendices</a>
&nbsp;&nbsp;&nbsp; 
<a href="#copyright">Bottom</a>
&nbsp;&nbsp;&nbsp; 
⍠⍠⍠
<!--  
  ⍠⍠⍠ 
-->
</div>

---

<br>
<span id="copyright" style="font-family:cursive;">
Copyright <big>©</big> 2025 Sam the Cat Foundation. [20251103T164445]
</span>
<br> 
</div> <!-- End div for right-margin-bar --> 

<!-- a hidden modal expression -->
<div id="pAlertMsg" class="pAlertMsg">
  <span id="pAlertPfx"  style="font-size: 50px;">
  </span> 
  <span id="pAlertText" 
        style="font-weight: bold; font-size: 20px;font-family: Tahoma,  sans-serif;">
  </span>
</div>

<!-- (C) 2025 Sam the Cat Foundation -->
