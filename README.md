<div class="right-margin-bar"> 
<div class="pMarquee">

**_∆F_** is a function for _Dyalog_ APL that interprets _f‑strings_,
a concise, yet powerful way to display multiline APL text, arbitrary
APL expressions, and multi&shy;dimensional objects using extensions to
_dfns_ and other familiar tools.

</div>

# Table of Contents

<details id="TOC">     <!-- option: open  Set id="TOC" here only. -->
<summary class="summary">&ensp;Show/Hide <em>Table of Contents</em></summary>
<span style="font-size:75%;">

- [Table of Contents](#table-of-contents)
- [Installing, Loading, and Running **∆F**](#installing-loading-and-running-f)
  - [Installing **∆F**](#installing-f)
  - [Loading and Running **∆F**](#loading-and-running-f)
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
  - [Precomputed f‑strings with the **_dfn_** Option](#precomputed-fstrings-with-the-dfn-option)
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
    - [∆F's Library Parameter Option: 'parms'](#fs-library-parameter-option-parms)
  - [Appendix II: Python f‑strings](#appendix-ii-python-fstrings)

---

</span>
</details>

# Installing, Loading, and Running **∆F**

<details open>            <!-- option: open -->
<summary class="summary">&ensp;Show/Hide <em>Installing, Loading, and Running <bold>∆F</bold></em>
</summary>

## Installing **∆F**

1. On Github, search for <mark>"f‑string-apl"</mark>.
   - During the test phase, go to <mark>github.com/petermsiegel/f‑string-apl</mark>.
2. Note your current directory.
3. Copy the file **∆F.dyalog** and directory **∆F** (which contains several files) into the current working directory,
   ensuring they are peers.

&emsp;<span style="font-size: 130%;">👉 </span>Now, **∆F** is available to load and use. Continue in the [next section](#loading-and-running-f).

## Loading and Running **∆F**

1. Confirm that your current directory remains as before.
2. From your Dyalog session, enter: <br>&emsp;`]load ∆F [-target=⎕SE]`
3. If **∆F/∆F_Help.html** is available at `]load` time, it will be copied into **⍙Fapl** (or a message will note the absence of _help_ information).
4. Namespace <code>_⎕SE_.**⍙Fapl**</code> now contains utilities used by **∆F** and, once `]load`ed, **_should not_** be moved. **∆F** always refers to **⍙Fapl** in its _original_ location.
5. By default, the target namespace (<code>_⎕SE_</code>) will be added to the end of `⎕PATH`, if not already defined in ⎕PATH. You may always choose to relocate or assign **∆F** anywhere you want so that it is available.

&emsp;<span style="font-size: 130%;">👉 </span>You may now call `∆F` with the desired [arguments](#f-call-syntax-overview) and [options](#f-option-details).<br>
&emsp;<span style="font-size: 130%;">👉 </span> **∆F** is `⎕IO`- and `⎕ML`-independent.

---

</details>

# Overview

<details open><summary class="summary">&ensp;Show/Hide <em>Overview</em></summary>


Inspired by [Python f‑strings](#appendix-ii-python-fstrings), **∆F** includes a variety of capabilities to make it easy to evaluate, format, annotate, and display related multi&shy;dimensional information.

**∆F** _f‑strings_ include:

- The abstraction of 2-dimensional character **_fields_**, generated one-by-one from the user's specifications and data, then aligned and catenated into a single overall character matrix result;



- **Text** fields, supporting multiline Unicode text within each field, with the sequence `` `◇ `` (**backtick** + **statement separator**) generating a newline, <small>`⎕UCS 13`</small>;

- **Code** fields, allowing users to evaluate and display APL arrays of any dimensionality, depth and type in the user environment, arrays passed as **∆F** arguments, as well as arbitrary APL expressions based on full multi-statement dfn
  logic. Each **Code** field must return a value, simple or otherwise, which will be catenated with other fields and returned from **∆F**;

  **Code** fields also provide a number of concise, convenient extensions, such as:

  - **Quoted strings** in **Code** fields, with several quote styles:

    - **double-quotes**<br>
      `∆F '{"like this"}'` or `` ∆F '{"on`◇""three""`◇lines"} ``,
    - **double angle quotation marks**,<br>
      `∆F '{«with internal quotes like "this" or ''this''»}'`, not to mention
    - APL's tried-and-true embedded **single-quotes**,<br>
      `∆F '{''shown ''''right'''' here''}'`.

  - Simple shortcuts for

    - **format**ting numeric arrays, **\$** (short for **⎕FMT**):<br>`∆F '{"F7.5" $ ?0 0}'`,
    - putting a **box** around a specific expression, **\`B**:<br>`` ∆F'{`B ⍳2 2}' ``,
    - placing the output of one expression **above** another, **%**:<br>`∆F'{"Pi"% ○1}'`,
    - formatting **date** and **time** expressions from APL timestamps (**⎕TS**) using **\`T** (combining&nbsp;**1200⌶** and **⎕DT**): <br>`` ∆F'{"hh:mm:ss" `T ⎕TS}' ``,
    - _and more_;

  - Simple mechanisms for concisely formatting and displaying data from
    - user arrays or arbitrary code:<br>`tempC←10 110 40`<br>`∆F'{tempC}'` or `∆F'{ {⍵<100: 32+9×⍵÷5 ◇ "(too hot)"}¨tempC }'`,
      <br>
    - arguments to **∆F** that follow the format string:<br>`` ∆F'{32+`⍵1×9÷5}' (10 110 40) ``,<br> where `` `⍵1 `` is a shortcut for `(⍵⊃⍨1+⎕IO)` (here `10 110 40`),
    - _and more_;

- **Space** fields, providing a simple mechanism both for separating adjacent **Text** fields and inserting (rectangular) blocks of any number of spaces between any two fields, where needed;

  - one space: `{ }`; five spaces: `{     }`; or even, zero spaces: `{}`;
  - 1000 spaces? Use a **Code** field instead: `{1000⍴""}`.

- Use of 
  _either_ positional options or namespace-style options, based on Array Notation in&shy;tro&shy;duced in Dyalog 20;

- Multiline (matrix) output built up field-by-field, left-to-right, from values and expressions in the calling environment or arguments to **∆F**;

  - After all fields are generated, they are aligned vertically, then concatenated to form a single character matrix: **_the return value from_** **∆F**. 

**∆F** is designed for ease of use, _ad hoc_ debugging, fine-grained formatting and informal user interaction, built using Dyalog functions and operators.

<details open>     <!-- option: open -->
<summary class="summary">&ensp;Recap: <em>The Three Field Types</em></summary> 

------------------------------------------------------- 
  Field               Syntax                      Examples                        Displaying     
  Type         
-----------     --------------------------  ----------------------------------   -----------------------------------
 **Text**          _Unicode text_            `` Cats`◇and`◇dogs! ``                2-D Text               

 **Code**          `{`_dfn code plus_`}`     `{↑"one" "two"}`<br>                   Arbitrary APL Expressions  
                    `{`*shortcuts*`}`        `{"F5.1" $ (32+9×÷∘5)degC}`            <br>via dfns 

 **Space**          `{`<big>␠ ␠ ␠</big>`}`     `{  }` &emsp; `{}`                   Spacing & Field Separation        
-------------------------------------------------------
Table: Table 3a. <strong>The Three Field Types</strong>

<br>
</details> 
</details>

# Displaying ∆F **Help** in APL


<span style="font-size: 130%;">👉 </span>To display this **HELP** information, type: `∆F⍨ 'help'`.

# ∆F Examples: A Primer

<details open>            <!-- option: open -->
<summary class="summary">&ensp;Show/Hide <em>Examples: A Primer</em>
</summary>

Before providing information on **∆F** syntax and other details, _let's start with some examples_…

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

Here, we assign the _f‑string_ to an APL variable, then call **∆F** twice!



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
- The sequence `◇ generates a new line in the current **Text** field.
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

```
⍝                          ↓↓↓
   ∆F 'Cat`◇Elephant`◇Mouse{ }Felix`◇Dumbo`◇Mickey'
Cat      Felix
Elephant Dumbo
Mouse    Mickey
```

## Code Fields (Continued)


And this is the same example with _identical_ output, but built using two **Code** fields
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
We just use the **box** mode option!

While we can't place boxes around text (or space) fields using `` `B ``,
we can place a box around **_each_** field (_regardless_ of type) by setting **∆F**'s [**box** mode](#f-option-details) option, to `1`:

```
   cv← 11.3 29.55 59.99
       ↓¯¯¯ box mode
   0 0 1 ∆F '`◇The temperature is {"I2" $ cv}`◇°C or {"F5.1" $ 32+9×cv÷5}`◇°F'
┌───────────────────┬──┬──────┬─────┬──┐
│                   │11│      │ 52.3│  │
│The temperature is │30│°C or │ 85.2│°F│
│                   │60│      │140.0│  │
└───────────────────┴──┴──────┴─────┴──┘
```

We said you could place a box around every field, but there's an exception.
Null **Space** fields `{}`, _i.e._ 0-width **Space** fields, are discarded once they've done their work of separating adjacent fields (typically **Text** fields), so they won't be placed in boxes.

Try this expression on your own:

```
⍝ (box: 1) ∆F 'abc...mno' in Dyalog 20.
   0 0 1   ∆F 'abc{}def{}{}ghi{""}jkl{ }mno'
```

<details id="pPeek"><summary class="summary">&ensp;Peek at answer</summary>

```
   0 0 1 ∆F 'abc{}def{}{}ghi{""}jkl{ }mno'
┌───┬───┬───┬┬───┬─┬───┐
│abc│def│ghi││jkl│ │mno│
└───┴───┴───┴┴───┴─┴───┘
```

</details>

In contrast, **Code** fields that return null values (like `{""}` above) _will_ be displayed!

## Omega Shortcuts (Explicit)

> Referencing **∆F** arguments after the _f‑string_: **Omega**
> shortcut expressions (like `` `⍵1 ``).

The expression

`` `⍵1 `` is equivalent to `(⍵⊃⍨ 1+⎕IO)`, selecting the first argument after the _f‑string_. Similarly, `` `⍵99 `` would select `(⍵⊃⍨99+⎕IO)`.

We will use `` `⍵1 `` here, both with shortcuts and an externally defined
function `C2F`, that converts Centigrade to Fahrenheit.
A bit further [below](#omega-shortcuts-implicit), we discuss bare `` `⍵ ``
(_i.e._ without an appended non-negative integer).

```
   C2F← 32+9×÷∘5
   ∆F 'The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ C2F `⍵1}°F' (11 15 20)
The temperature is 11°C or 51.8°F
                   15      59.0
                   20      68.0
```

## Referencing the f‑string Itself


The expression `` `⍵0 `` always refers to the _f‑string_ itself. Try this yourself.

```
   bL bR← '«»'                     ⍝ ⎕UCS 171 187
   ∆F 'Our string {bL, `⍵0, bR} has {≢`⍵0} characters.'
```

<details id="pPeek"><summary class="summary">&ensp;Peek at answer</summary>

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


The shortcut for _Numeric_ **Commas** `` `C `` adds commas every 3 digits (from the right) to one or more numbers or numeric strings.It has an advantage over the `$` (Dyalog's `⎕FMT`) specifier: it doesn't require you to guesstimate field widths.

Let's use the `` `C `` shortcut to add the commas to the temperatures!



```
   sun_core← 15E6               ⍝ 15000000 is a bit hard to parse!
   ∆F 'The sun''s core is at {`C sun_core}°C or {`C C2F sun_core}°F.'
The sun's core is at 15,000,000°C or 27,000,032°F.
```

And for a bit of a twist, let's display either degrees Centigrade
or Fahrenheit under user control (`1` => F, `0` => C). Here, we establish
the _f‑string_ `sunFC` first, then pass it to **∆F** with an additional right argument.

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

- to the _left_ of the result of evaluating that code; or,
- centered _above_ the result of evaluating that code.

All you need do is enter

- a right arrow <big>`→`</big> for a **horizontal** SDCF, or
- a down arrow <big>`↓`</big> (or <big>`%`</big>) for a **vertical** SDCF,

as the **_last non-space_** character in the **Code** field,
before the _final_ right brace.

Here's an example of a horizontal SDCF, _i.e._ using `→`:

```
   name←'John Smith' ◇ age← 34
   ∆F 'Current employee: {name→}, {age→}.'
Current employee: name→John Smith, age→34.
```

As a useful formatting feature, whatever spaces are just **_before_**
or **_after_** the symbol **→** or **↓** are preserved **_verbatim_** in the output.

Here's an example with such spaces: see how the spaces adjacent to
the symbol `→` are mirrored in the output!

```
   name←'John Smith' ◇ age← 34
   ∆F 'Current employee: {name → }, {age→ }.'
Current employee: name → John Smith, age→ 34.
```

Now, let's look at an example of a vertical SDCF, _i.e._ using `↓`:

```
   name←'John Smith' ◇ age← 34
   ∆F 'Current employee: {name↓} {age↓}.'
Current employee:  name↓     age↓.
                  John Smith  34
```

To make it easier to see, here's the same result, but with a box around
each field&mdash;using the **Box** [option](#f-option-details), _namespace_ style.

```
⍝  Box all fields
   (box: 1) ∆F 'Current employee: {name↓} {age↓}.'
┌──────────────────┬──────────┬─┬────┬─┐
│Current employee: │ name↓    │ │age↓│.│
│                  │John Smith│ │ 34 │ │
└──────────────────┴──────────┴─┴────┴─┘
```

## The Above Shortcut

> A cut above the rest…


Here's a useful feature. Let's use the shortcut `%` to display one
expression centered above another;
it's called **Above** and can _also_ be expressed as `` `A ``.



```
   ∆F '{"Employee" % ⍪`⍵1} {"Age" % ⍪`⍵2}' ('John Smith' 'Mary Jones')(29 23)
Employee    Age
John Smith  29
Mary Jones  23
```

## Text Justification Shortcut


The Text **Justification** shortcut `` `J `` treats its right argument
as a character array, justifying each line to the left (`⍺="L"`,
the default), to the right (`⍺="R"`), or centered (`⍺="C"`).

If its right argument contains floating point numbers, they will be displayed with the maximum
print precision `⎕PP` available.

```
   a← ↑'elephants' 'cats' 'rhinoceroses'
   ∆F '{"L" `J a}  {"C" `J a}  {"R" `J a}'
elephants      elephants       elephants
cats              cats              cats
rhinoceroses  rhinoceroses  rhinoceroses
```

And what do you think this _f-string_ displays?

```
   ∆F '{¯1 `J `⍵1} {0 `J `⍵1} { 1`J `⍵1  }' (⍪10*2×⍳4)
```

<details id="pPeek"><summary class="summary">&ensp;Peek at answer</summary>

```
   ∆F '{¯1 `J `⍵1} {0 `J `⍵1} { 1`J `⍵1  }' (⍪10*2×⍳4)
1          1          1
100       100       100
10000    10000    10000
1000000 1000000 1000000
```

</details>

## Omega Shortcuts (Implicit)

> The _next_ best thing: the use of `` `⍵ `` in **Code** field expressions…

We said we'd present the use of **Omega** shortcuts with implicit indices `` `⍵ `` in **Code** fields. The expression `` `⍵ `` selects the _next_ element of the right argument `⍵` to **∆F**, defaulting to `` `⍵1 `` when first encountered, _i.e._ if there are **_no_** `` `⍵ `` elements (_explicit_ or _implicit_) to the **_left_** in the entire _f‑string_. If there is any such expression (_e.g._ `` `⍵5 ``), then `` `⍵ `` points to the element after that one (_e.g._ `` `⍵6 ``). If the item to the left is `` `⍵ ``, then we simply increment the index by `1` from that one.

**Let's try an example.** Here, we display arbitrary 2-dimensional expressions,
one above the other.
`` `⍵ `` refers to the **_next_** argument in sequence, left to right,
starting with `` `⍵1 ``, the first, _i.e._ `(⍵⊃⍨ 1+⎕IO)`.
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

Shortcuts often make sense with individual expressions, not just entire **Code** fields. They can be manipulated like ordinary APL functions; since they are just that&mdash; ordinary APL functions&mdash; under the covers.
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


**∆F** supports a simple **Date-Time** shortcut `` `T `` built from **1200⌶** and **⎕DT**. It takes one or more Dyalog `⎕TS`-format timestamps as the right argument and a date-time specification as the  (optional) left argument. Trailing elements of a timestamp may be omitted (they will each be treated as `0` in the specification string).

Let's look at the use of the `` `T `` shortcut to show the current time (now).



```
   ∆F 'It is now {"t:mm pp" `T ⎕TS}.'
It is now 8:08 am.
```

Here's a fancier example.
(We've added the _truncated_ timestamp `2025 01 01` right into the _f‑string_.)

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

And here's an example with a simple, mixed vector (_i.e._ a mix of character and numeric scalars only). We'll call the object `iv`, but we won't disclose its definition yet.

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

Now, we'll show the variable `iv` using the **Quote** `` `Q `` shortcut.

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
where the user may place and manipulate useful objects for the duration
of the ***current*** *APL* session. For example, the user may wish to: 

- have regularly used functions or operators _automatically_ available, _or_
- create objects that might be referred to, monitored, or modified during the session.

### Explicitly Copied Library Objects

In this example, the user wants to generate all primes between 1 and 100 using
two routines, `sieve` and `to`, that reside in the **_dfns_** workspace. To accommodate this,
we could simply copy them in advance, just in case they are needed.

> But there's a better way!

Here we copy both routines from **_dfns_** in real time, only when they are needed.



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
an attempt is made to copy that name into the library either from the **_dfns_** workspace or from a text file; if the name appears to the left-side of a **simple** assigment `←`, it is assumed to exist (as always), _i.e._ is not copied in.

<span style="font-size: 130%;">👉 </span>
If **∆F** is unable to find the item during its search,
a standard _APL_ error will be signaled.

In this next example, we use _for the first time_ the function `pco` from the
`dfns` workspace.

```
    ∆F '{ ⍸ 1 £.pco ⍳100 }'
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
```

<details id="pPeek">
<summary class="summary">&ensp;Peek: Using the <em><strong>debug</strong></em> option</summary>

<span style="font-size: 130%;">👉 </span>
To understand when an object is automatically copied into a £ibrary,
or to see where it's copied from, use **∆F**'s **_debug_** option:



```
   0 1 ∆F '{ ⍸ 1 £.pco ⍳100 }'    ⍝ 0 1 <==> (debug: 1)
DEBUG: Copied "pco" into £=[⎕SE.⍙Fapl.ûLib] from "ws:dfns"
{ ⎕SE.⍙Fapl.M ⌽⍬({⍸ 1 ⎕SE.⍙Fapl.ûLib.pco ⍳100}⍵)}⍵
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97
```

</details>

By default, with _(debug: 0)_, the function is quietly copied in just once this _APL_ session, and is available _without the overhead of additional
copying_.

### Session Variables

> But we can use the Session Library shortcut for arrays as well.



Here is an example where we define a local session variable `ctr`,
a counter of the number of times a particular
statement is executed. Since we define the counter, `£.ctr←0`,
**∆F** makes **_no_** attempt to copy it from the `dfns` workspace or a file.

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
When a _dfn_ created via **∆F** with the **_dfn_** mode set to `1`, any uses of `£` will
require the associated ⍙Fapl namespace to be present. We discuss the **_dfn_** option in the _next_ section!

</div>

## Precomputed f‑strings with the **_dfn_** Option

As shown in Table 5a (below), with _(i)_ the default _dfn_ option set to `0`, the value returned from a successful call to **∆F** is always a character matrix.
However, _(ii)\*\* 
if [*dfn\*](#f-option-details) is set to `1`, then **∆F** returns a **dfn** that&mdash; when called later&mdash; will return the identical character expression.

|        |   <br>Mode    | <center>Positional<br>Parameter</center> | <center>Keyword<br>Parameter</center> |
| :----- | :-----------: | :--------------------------------------- | :------------------------------------ |
| _(i)_  | **_default_** | ` 0 ∆F 'mycode'`                         | `(dfn: 0) ∆F 'mycode'`                |
| _(ii)_ |   **_dfn_**   | ` 1 ∆F 'mycode'`                         | `(dfn: 1) ∆F 'mycode'`                |
Table: Table 5a. <strong>Using the <em>dfn Option</em></strong>


The _dfn_ option is most useful when you are making repeated use of an _f‑string_, since the overhead for analyzing the _f‑string_ contents **_once_** will be amortized over **_all_** the subsequent calls. An **∆F**-derived _dfn_ can also be made standalone, _i.e._ independent of the runtime library, **⍙Fapl**.

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

<details id="pPeek"><summary class="summary">&ensp;Evaluate <code>∆F t</code></summary>

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

<details id="pPeek"><summary class="summary">&ensp;Evaluate <code>T ⍬</code></summary>

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

The precomputed version is at least an <mark>order of magnitude</mark> faster.

Before we get to syntax and other information, we want to show you
that 
the _dfn_ returned when the _dfn_ option is set to `1` can retrieve one or more arguments passed on the right side of **∆F**, using the very same omega shortcut expressions (like `` `⍵1 ``) we've
discussed above.

Let's share the Centigrade values `cv` from our current example,
not as a _variable_, but as the _first argument_ to **∆F**.
We'll access the value as `` `⍵1 ``.

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
∆F t (11 30 60) → 1.6E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕
T ⊂(11 30 60)   → 1.1E¯5 | -94% ⎕⎕⎕
```

The precomputed version again shows a speedup of well over an <mark>order of magnitude</mark> compared to the default version.

---

Below, we summarize key information you've already gleaned from the examples.

</details>

# ∆F Syntax and Other Information

<details open>        <!-- option: open -->       
<summary class="summary">&ensp;Show/Hide <em>Syntax Info</em></summary>

## ∆F Call Syntax Overview



--------------------------------------------------------------------------------------------------
Call Syntax                                                                      Description 
----------------------------------------------------------------                 ------------------------------------------------------------------------------------------------------------------------------------------------------------------
**∆F**&ensp;**_f‑string_**                                                       Display an _f‑string_; use the _default_ options. The string may reference objects in the environment or in the string itself. Returns a character matrix.                                                                                                           

**∆F**&ensp;**_f‑string_**&ensp;**_args_**                                       Display an _f‑string_; use the _default_ options. Arguments presented _may_ be referred to in the f‑string. Returns a character matrix.                                                                                                                             

**_options_**&ensp;**∆F**&ensp;**_f‑string_**&ensp;[***args***]                  Display an _f‑string_; control the result with _options_ specified (see below).<br>If **_dfn_** (see below) is `0` or omitted, returns a character matrix.<br>If **_dfn_** is `1`, returns a dfn that will display such a matrix (given an identical system state).  

'help'&ensp;**∆F**&ensp;' '&ensp;_or_&ensp;**∆F**⍨'help'                          Display help info and examples for **∆F**. The _f‑string_ is not examined.                                                                                                                                                             
 
**_return value_**                                                               _See below._                                                                                                                                                                                                                                            
--------------------------------------------------------------------------------------------------
Table: Table 6a. <strong>∆F Call Syntax Overview</strong>

<br>

## ∆F Option Details

| <br><br>Mode | Positional<br>Option<br>Index | Keyword<br>Option<br><small>(_keyword: default_)<div style="width:90px"></small> | <br><br>Description |                                                                                                                                                                                                                                                                                                                                                                      
| :----------: | :----------------------: | :-------------------------------------: | :------------------------------------------------------------------------------------------- |
|   **Dfn**    |        &emsp;**_[0]_**   |                                 **_dfn:&nbsp;0_**                                 | If **_dfn:&nbsp;1_**, **∆F** returns a dfn, which (upon execution) produces the same output as the default mode.<br>If **_dfn:&nbsp;0_** (default): **∆F** returns a char. matrix.                                                                                                                                                                                                                                                                                                                                                                                               |
|  **Debug**   |        &emsp;**_[1]_**   |                                **_debug:&nbsp;0_**                                | If **_debug:&nbsp;1_**, Renders newline characters from `` `◇ `` as the visible `␤` character. Displays the source code that the _f‑string_ **_actually_** generates; if **_dfn_** is also `1`, this will include the embedded _f‑string_ source (accessed as `` `⍵0 ``). After the source code is displayed, it will be executed or converted to a _dfn_ and returned (see the **_dfn_** option above).<br>If **_debug:&nbsp;0_** (default): Newline characters from `` `◇ `` are rendered normally as carriage returns, `⎕UCS 13`; the **_dfn_** source code is not displayed. |
|   **Box**    |        &emsp;**_[2]_**   |                                 **_box:&nbsp;0_**                                 | If **_box:&nbsp;1_**, each field (except a null **Text** field) is boxed separately.<br>If **_box:&nbsp;0_** (default), nothing is boxed automatically. Any **Code** field expression may be explicitly boxed using the **Box** shortcut, `` `B ``.<br>**NB.** **_box_** mode can be used with settings <strong>`dfn: 1`</strong> _and_ <strong>`dfn: 0`.</strong>                                                                                                                                                                                                               |
|   **Auto**   |        &emsp;**_[3]_**   |                                **_auto:&nbsp;1_**                                 | If **_auto:&nbsp;0_**, user must manually load/create any Session Library objects for use with the £ or `` `L `` shortcuts.<br>If **_auto:&nbsp;1_** (default), honors the default and user-defined settings for `auto`.                                                                                                                                                                                                                                                                                                                                                         |
|  **Inline**  |        &emsp;**_[4]_**   |                               **_inline:&nbsp;0_**                                | If **_inline:&nbsp;1_** and **_dfn:&nbsp;1_**, the code for each internal support function used is included in the _dfn_ result; **_no_** reference to namespace **⍙Fapl** will be made during the execution of that _dfn_.<br>If **_inline:&nbsp;0_** (default), whenever **∆F** or a _dfn_ generated by it is executed, it makes calls to library routines in the namespace **⍙Fapl**, created during the `]load` process for **∆F**.<br>**NB.** This option is experimental and may simply disappear one day.                                                                      |
| **Special**  |         **_'help'_**     |                                      &mdash;                                      | If `'help'` is specified, this amazing doc&shy;ument&shy;ation is displayed.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| **Special**  |         **_'parms'_**    |                                      &mdash;                                      | Updates and displays Session Library (`£` or `` `L ``) pa&shy;ram&shy;eters.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |

Table: Table 6b. <strong>∆F Option Details</strong>

- **Default options:** If the left argument `⍺` is omitted, the options default as shown here.

   ------------------------------------------------------------
          Option
          Style              Defaults
   ----------------- -------------------------------------------------------
     **Positional**     `0 0 0 1 0`

     **Keyword**        `(dfn: 0 ◇ debug: 0 ◇ box: 0 ◇ auto: 1 ◇ inline: 0)`
    ------------------------------------------------------------------------
   
     Table: Table 6c. <strong>∆F Default Options</strong>

- **Positional style options:** If **∆F**'s left argument `⍺` is a simple integer vector (or a scalar), omitted (trailing) elements are replaced by the corresponding elements of the default, `0 0 0 1 0`. _NB. Extra elements are ignored._
- **Keyword style options:** If the left argument is a namespace,
  it is assumed to contain option names (in any order) with their non-default values,<br>&emsp;&emsp;e.g. `(debug: 1 ◇ auto: 0)`;  
   Keyword options are new for Dyalog 20. They are sometimes clearer and more convenient than positional keywords.
- **Help option:** If the left argument `⍺` starts with `'help'` (case ignored), this help information is displayed. In this case, the right argument to **∆F** is ignored.
- **Parms option:** If the left argument `⍺` matches `'parms'` (case ignored), the Session Library parameters are (re-)loaded and displayed. In this case, the right argument to **∆F** is ignored.
- Otherwise, an error is signaled.

## ∆F Return Value

- Unless the **_dfn_** option is selected, **∆F** always returns a character matrix of at least one row and zero columns, `1 0⍴0`, on success. If the 'help' option is specified, **∆F** displays this information, returning `1 0⍴0`. If the 'parms' option is specified, **∆F** shows the Session Library parameters as a character matrix.
- If the **_dfn_** option is selected, **∆F** always returns a standard Dyalog dfn on success.
- On failure of any sort, an informative APL error is signaled.

## ∆F F‑string Building Blocks

The first element in the right arg to ∆F is a character vector, an _f‑string_,
which contains one or more **Text** fields, **Code** fields, and **Space** fields in any combination.

- **Text** fields consist of simple text, which may include any Unicode characters desired, including newlines.
  - Newlines (actually, carriage returns, `⎕UCS 13`) are normally entered via the sequence `` `◇ ``.
  - Additionally, literal curly braces can be added via `` `{ `` and `` `} ``, so they are distinct from the simple curly braces used to begin and end **Code** fields and **Space** fields.
  - Finally, to enter a single backtick `` ` `` just before the special
    symbols `{`, `}`, `◇`, or `` ` ``, enter **_two_** backticks ` `` `; if preceding any ordinary
    symbol, a **_single_** backtick will suffice.
  - If **∆F** is called with an empty string, `∆F ''`, it is interpreted as containing a single 0-length **Text** field, returning a matrix of shape `1 0`.
- **Code** fields are run-time evaluated expressions enclosed within
  simple, unescaped curly braces `{ }`, _i.e._ those not preceded by a backtick (see the previous paragraph).
  - **Code** fields are, under the covers, Dyalog _dfns_ with some extras.
  - For escape sequences, see **Escape Sequences** below.
- **Space** fields appear to be a special, _degenerate_, form of **Code** fields, consisting of a single pair of simple (unescaped) curly braces `{}` with zero or more spaces in between.
  - A **Space** field with zero spaces is a **_null_** **Space** field; while it may separate any other fields, its typical use is to separate two adjacent **Text** fields.
  - Between fields, **∆F** adds no automatic spaces; that spacing is under user control.

## Code Field Shortcuts

**∆F** **Code** fields may contain various shortcuts, intended to be concise and expressive tools for common tasks. **Shortcuts** are valid in **Code** fields only _outside_ **Quoted strings**.

**Shortcuts** include:

| Shortcut<div style="width:75px"></div> |               Name<div style="width:150px"></div>                | Meaning                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| :------------------------------------- | :--------------------------------------------------------------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **\`A**, **%**                         |                              Above                               | `[⍺] % ⍵`. Centers array `⍺` above array `⍵`.<br>If omitted, `⍺←''`, _i.e._ a blank line.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| **\`B**                                |                               Box                                | `` `B ⍵ ``. Places `⍵` in a box. `⍵` is any array.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| **\`C**                                |                              Commas                              | `` `C ⍵ ``. Adds commas to `⍵` after every 3rd digit of the integer part of `⍵`, right-to-left. `⍵` is a vector of num strings or numbers.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| **\`D**                                |                            Date-Time                             | Synonym for **\`T**.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| **\`F**, **$**                         |                               ⎕FMT                               | `[⍺] $ ⍵`. Short for `[⍺] ⎕FMT ⍵`. (See APL doc&shy;ument&shy;ation).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| **\`J**                                |                             Justify                              | `` [⍺] `J ⍵ ``. Justify each row of object `⍵` as text:<br>&emsp;&emsp;_left_: ⍺="L"; _center_: ⍺="C"; _right_ ⍺="R".<br>You may use `¯1`\|`0`\|`1` in place of `"L"`\|`"C"`\|`"R"`. If omitted, `⍺←'L'`. <small>_Displays numbers with the maximum precision available._</small>                                                                                                                                                                                                                                                                                                                                                                                            |
| **\`L**, **£**                         | Session Library<br><span class="red"><small>**EXPERIMENTAL!**</small></span> | `£`. `£` denotes a private library (namespace) local to the **∆F** runtime environ&shy;ment into which functions or objects (including name&shy;spaces) may be placed (e.g. via `⎕CY`) for the duration of the _APL_ session. Outside of simple assignments, **∆F** will attempt to copy undefined objects from, _in order:_<br>&emsp;<small><sup>directory</sup></small>&thinsp;**./MyDyalogLib/** &nbsp;\>&nbsp; <small><sup>_APL_ ws</sup></small>&thinsp;**dfns** &nbsp;\>&nbsp;<small><sup>directory</sup></small>&thinsp;**./**<br><small>_For filetypes and customisation, see [Session Library Shortcut: Details](#session-library-shortcut-details) below._</small> |
| **\`Q**                                |                              Quote                               | `` [⍺]`Q ⍵ ``. Recursively scans `⍵`, putting char. vectors, scalars, and rows of higher-dimensional strings in APL quotes, leaving other elements as is. If omitted, `⍺←''''`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **\`T**                                |                            Date-Time                             | `` [⍺]`T ⍵ ``. Displays timestamp(s) `⍵` according to date-time template `⍺`. `⍵` is one or more APL timestamps `⎕TS`. `⍺` is a date-time template in `1200⌶` format. If omitted, `⍺← '%ISO%'`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **\`W**                                |        Wrap <span class="red"><small>**EXPERIMENTAL!**</small></span>        | `` [⍺]`W ⍵ ``. Wraps the rows of simple arrays in ⍵ in decorators `0⊃2⍴⍺` (on the left) and `1⊃2⍴⍺` (on the right). If omitted, `⍺←''''`. <small>_See details below._</small>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| **\`⍵𝑑𝑑**, **⍹𝑑𝑑**                     |           Omega Shortcut<br>(<small>EXPLICIT</small>)            | A shortcut of the form `` `⍵𝑑𝑑 `` (or `⍹𝑑𝑑`), to access the `𝑑𝑑`**th** element of `⍵`, _i.e._ `(⍵⊃⍨ 𝑑𝑑+⎕IO)`. <small>_See details below._</small>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| **\`⍵**, **⍹**                         |           Omega Shortcut<br>(<small>IMPLICIT</small>)            | A shortcut of the form `` `⍵ `` (or `⍹`), to access the **_next_** element of `⍵`. <small>_See details below._ <small>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| **→**<br>**↓** _or_ **%**              |     Self-documenting **Code** Fields <small>(SDCFs)</small>      | `→`/`↓` (synonym: `%`) signal that the source code for the **Code** field appears before/above its value. Surrounding blanks are significant. <small>_See [SDCFs](#self-documenting-code-fields-sdcfs) in **Examples** for details._</small>                                                                                                                                                                                                                                                                                                                                                                                                                                 |

Table: Table 6d. <strong>Code Field Shortcuts</strong>

<br>

## Escape Sequences For Text Fields and Quoted Strings


**∆F** **Text** fields and **Quoted strings** in **Code** fields may include
a small number of escape sequences, beginning with the backtick `` ` ``.
Some sequences are valid in **Text** fields _only_, but not in Quoted strings:



----------------------------------------------------------------------
  Escape        What<br>        <br>               <br>
 Sequence    It Inserts       Description          Where 
---------  --------------   ---------------    -------------------- 
**\`◇**      _newline_        ⎕UCS 13             Text and Code fields

**\`\`**        \`            backtick            Text and Code fields

**\`{**         {             left brace          Text fields only

**\`}**         }             right brace         Text fields only
----------------------------------------------------------------------
Table: Table 6e. <strong>Escape Sequences</strong>

Other instances of the backtick character in **Text** fields or **Quoted strings** in **Code** fields will be treated literally, _i.e._
sometimes a backtick is just a backtick.

## Quoted Strings in Code Fields

As mentioned in the introduction, **Quoted strings** in **Code** fields allow several delimiting quote styles:

- **double-quotes**<br>
  `∆F '{"like «this» one"}'` or `∆F '{"like ''this'' one."}'`,
- **double angle quotation marks**,<br>
  `∆F '{«like "this" or ''this''.»}'`,  
  as well as
- APL's tried-and-true embedded **single-quotes**,<br>
  `∆F '{''shown like ''''this'''', "this" or «this».''}'`.


If you wish to include a traditional delimiting quote (`'` or `"`) or the closing quote of a quote pair (`«`&ensp;`»`) within the **Quoted string**, you must double it.
You may _not_ use an escape sequence (e.g. `` `" ``) for this purpose.

---------------------------------------------------------------
 Closing           <br>                          <br>
  Quote            Example                          Result
---------  ----------------------------------- -------------------------
`"`          `∆F '{"like ""this"" example"}'`     `like "this" example`

`»`          `∆F '{«or «this»» one»}'`            `or «this» one`

 `'`       `∆F '{''or ''''this'''' one''}'`      `or 'this' one`
---------------------------------------------------------------------------
Table: Table 6f. <strong>Closing Quotes</strong>

Note that the opening quote `«` is treated as an ordinary character within the string. The clumsiness of the standard single quote `'` examples is due to the fact that the single quote is the required delimiter for the outermost (APL-level) string.

## Omega Shortcut Expressions: Details

1.  **⍹** is a synonym for **\`⍵**. It is Unicode character `⎕UCS 9081`. Either glyph is valid only in **Code** fields and outside **Quoted strings**.
2.  **\`⍵** or **⍹** uses an "_omega index counter_" (**OIC**) which we'll represent as **Ω**, common across all **Code** fields, which is initially set to zero, `Ω←0`. (**Ω** is just used for explication; don't actually use this symbol)
3.  All **Omega** shortcut expressions in the _f‑string_ are evaluated left to right and are ⎕IO-independent.
4.  **\`⍵𝑑𝑑** or **⍹𝑑𝑑** sets the _OIC_ to 𝑑𝑑, `Ω←𝑑𝑑`, and returns the expression `(⍵⊃⍨Ω+⎕IO)`. Here **𝑑𝑑** must be a _non-negative integer_ with at least 1 digit.
5.  Bare **\`⍵** or **⍹** (_i.e._ with no digits appended) increments the _OIC_, `Ω+←1`, _before_ using it as the index in the expression `(⍵⊃⍨Ω+⎕IO)`.
6.  The _f‑string_ itself (the 0-th element of **⍵**) is always accessed as `` `⍵0 `` or `⍹0`. The omega with _implicit index_ always increments its index _before_ use, _i.e._ starting by default with `` `⍵1 `` or `⍹1`.
7.  If an element of the dfn's right argument **⍵** is accessed at runtime via any means, shortcut or traditional, that element **_must_** exist.

<details id="pPeek"><summary class="summary">&ensp;View Details on Experimental Features</summary>
<div class="test-feature">



## Wrap Shortcut: Details

1. Syntax: `` [⍺←''''] `W ⍵ ``.
2. Let `L←0⊃2⍴⍺` and `R←1⊃2⍴⍺`.
3. Wrap each row `X′` of the simple arrays `X` in `⍵` (or the entire array `X` if a simple vector or scalar) in decorators `L` and `R`: `L,(⍕X′),R`.
4. `⍵` is an array of any shape and depth.`L`and `R`are char. vectors or scalars or `⍬` (treated as `''`).
5. If there is one scalar or enclosed vector `⍺`, it is replicated _per (2) above_.
6. By default,`⍺← ''''`,_i.e._ APL quotes will wrap the array ⍵, row by row, whether character, numeric or otherwise.



## Session Library Shortcut: Details

1. If 
   an object `£.name` is referenced, but not yet defined in `£`, an attempt is made to copy it to `£` from workspace `dfns` and/or from files **name.aplf** (for functions), **name.aplo** (for operators), _etc._
   in files in the (user-settable) search path, _unless_ it is being assigned (via `←`). It will be available for the duration of the session.

1. In the case of a simple assignment (`£.name←val`), the object assigned must be new or
   of a compatible _APL_ class with its existing value, else a domain error will be signaled.

1. Modified assignments of the form `£.name+←val` are allowed and treated as in the first case.

### Session Library Shortcut: Filetypes of Source Files



|  <br>Filetype   |      <br>Action       | APL Class ⎕NC | Key APL<br>Service | Available<br>by Default? |         Type <br>Enforced?          |
| :-------------: | :---------------------------------: | :------------------: | :----------------: | :-------------------: | :------------------: |
|      aplf       |    Fixes function     |        3         |        ⎕FIX        |            ✔             |       ✔<small> FUTURE</small>       |
|      aplo       |    Fixes operator     |        4         |        ⎕FIX        |            ✔             |       ✔<small> FUTURE</small>       |
|      apln       |       Fixes ns        |        9         |        ⎕FIX        |            ✔             |       ✔<small> FUTURE</small>       |
|      apla       |     Assigns array     |       2, 9       |    _assignment_    |            ✔             |                  ✔                  |
|      json       |  Fixes ns from JSON5  |        9         |       ⎕JSON        |            ✔             |                  ✔                  |
|       txt       | Assigns char. vectors |        2         |    _assignment_    |            ✔             |                  ✔                  |
| dyalog, _other_ |     Fixes object      |     3, 4, 9      |        ⎕FIX        |      <span class="red">✘</span>      | <span class="red">✘<small> NEVER</small></span> |
Table: Table 6g. <strong>Library Filetypes: Meaning</strong>

### Session Library Shortcut: Parameters

The 
Session Library shortcut (`£` or `` `L ``) is deceptively simple, but
the code to support it is a tad complex.
The complex components run only when **∆F** is loaded. If the **auto** parameter is `1`, there is a modest
performance impact at runtime.
If `0`, the runtime impact of the feature is more modest still.

To support the Session Library auto-load process, there are parameters that the user may _optionally_ tailor via an APL Array Notation parameter file **.&ThinSpace;∆F** placed in the current file directory. Parameters include:

- **load:** the ability, when **∆F** is being loaded, to
  define 
  where&mdash; in which files or workspaces&mdash; to find Session Library objects, based on default or user parameters;
- **auto:** allowing **∆F** to automatically load undefined objects of the form `£.obj` or `` `L.obj `` into the Session Library from
  workspaces or files on the search path;
- **verbose:** providing limited information on parameters, object loading, _etc._;
- **path:** listing what directories to search for the object definitions;
- **prefix:** literal character vectors to prefix to each file name during the object search;
- **suffix:** filemodes that indicate the type of object and (potentially) any expected conversion;

The built-in _(default)_ parameter file 
is documented _below_.

<details open><summary class="summary">&ensp;<em>Show/Hide Default £ibrary Parameter File</em> <big><strong>. ∆F</strong></big></summary>

```skip
(
 ⍝ Default .∆F (JSON5) Parameter File
 ⍝ Items not to be (re)set by user may be omitted/commented out.
 ⍝ If (load: ⎕NULL), then LIB_LOAD [note 1] is used for load.
 ⍝ If (verbose: ⎕NULL), then VERBOSE [note 1] is used for verbose.
 ⍝ If (prefix: ⎕NULL) or (prefix: ⍬), then (prefix: '' ◇)
 ⍝ [note 1]
 ⍝   ∆F global variables LIB_LOAD and VERBOSE are set in ∆Fapl.dyalog.
 ⍝    Their usual values are LIB_LOAD← 1 ◇ VERBOSE← 0
 ⍝    See load: and verbose: below for significance.

 ⍝ load:
 ⍝   1:     Load the runtime path to search for Session Library £ and `L.
 ⍝   0:     Don't load...
 ⍝   ⎕NULL: Grab value from LIB_LOAD above.
   load: ⎕NULL

 ⍝ auto:
 ⍝   0: user must load own objects; nothing is automatic.
 ⍝   1: dfns and files (if any) searched in sequence set by dfnsOrder.
 ⍝      See path for directory search sequence.
 ⍝ Note: If (load: 0) or if there are no files in the search path,
 ⍝       auto is set to 0, since nothing will ever match.
   auto: 1

 ⍝ verbose:
 ⍝    If 0 (quiet),
 ⍝    If 1 (verbose).
 ⍝    If ⎕NULL, value is set from VERBOSE (see above).
   verbose: ⎕NULL

 ⍝ path: The file dirs and/or workspaces to search IN ORDER left to right:
 ⍝    e.g. path: [ 'fd1', 'fd2', ['ws1', 'wsdir/ws2'], 'fd3', ['ws3']]
 ⍝    For a file directory, the item must be a simple char vector
 ⍝        'MyDyalogLib'
 ⍝    For workspaces, the item must be a vector of one or more char vectors
 ⍝        (⊂'dfns') or (⊂'MyDyalogLib/mathfns') or ('dfns', 'myDfns')
 ⍝  To indicate we don't want to search ANY files,
 ⍝     best: (load: 0)
 ⍝     ok:   (path: ⎕NULL)
   path:  ( './MyDyalogLib' ◇ ('dfns'◇) ◇ '.' ◇ )

 ⍝ prefix: literal string to prefix to each name, when searching directories.
 ⍝     Ignored for workspaces.
 ⍝     ⍬ is equiv. to  ''.
 ⍝     Example given name 'mydfn' and (prefix: '∆F_' 'MyLib/' ◇ suffix: ⊂'aplf')
 ⍝     ==> ('∆F_mydfn.aplf'  'MyLib/mydfn.aplf')
   prefix: ⍬

 ⍝ suffix: at least one suffix is required. The '.' is prepended for you!
 ⍝    Not applicable to workspaces. See documentation for definitions.
 ⍝    By default, 'dyalog' and unknown filetypes are not enabled.
 ⍝    Generally, place most used definitions first.
   suffix: ('aplf'  'apla'  'aplo'  'apln'  'json' 'txt')

 ⍝  Internal Runtime (hidden) Parameters
   _readParmFi: 0                      ⍝ 0 Zero: Haven't read .∆F yet. 1 afterwards.
   _fullPath:   ⍬                      ⍝ ⍬ Zilde: Generated from path and prefixes.
)
```

</details>

---

</div> 
</details> 
</details>

# Appendices

<details open><summary class="summary">&ensp;Show/Hide <em>Appendices</em></summary>

## Appendix I: Un(der)documented Features

### ∆F Option for Dfn Source Code

If the [**_dfn_** option](#f-option-details) is `¯1`, _equivalently_ `(dfn: ¯1)`,then **∆F** returns a character vector that contains the source code for the _dfn_ returned via `(dfn: 1)`.
If **_debug_** is also set, newlines from `` `◇ `` are shown as visible `␤`. However, since this option _returns_ the code string, the **_debug_** option won't also _display_ the code string.

### ∆F Help's Secret Variant

`∆F⍨'help'` has a secret variant: `∆F⍨'help-narrow'`.
With this variant, the help
session will start up in a narrower window _without_ side notes. If the user widens the
window, the side notes will appear, as in the default
case: `∆F⍨'help'`.

### ∆F's Library Parameter Option: 'parms'

Normally, ∆F £ibrary parameters are established when **∆F** and associated libraries
are loaded (_e.g._ via `]load ∆F -t=⎕SE`). After editing the parameter file **./.∆F,** you may wish to update the active parameters, while maintaining existing user £ibrary session objects, which would otherwise be lost during a `]load` operation. For such an update, use **∆F**'s `'parms'` option.

`∆F⍨ 'parms'` reads the user parameter file **./.∆F,**
updates the *£ibrary* parameters, returning them in alphabetical order along with their values as a single character matrix. No current session objects are affected.

## Appendix II: Python f‑strings

<div style="line-height: 1.3;">

&emsp; Python f-strings, introduced in Python 3.6, are a modern and elegant way to format strings by embedding expressions directly inside string literals. You create an f-string by prefixing a string with the letter 'f' or 'F', and then you can include any Python expression inside curly braces within the string. When the string is evaluated, these expressions are executed and their results are automatically converted to strings and inserted at that position.
<br>&emsp; For example, the Python expression&ensp;<strong>`f"The sum of {a} and {b} is {a + b}"`</strong>&ensp;would evaluate the addition and embed the result directly in the string. This combination of simplicity, power, and performance has made f-strings the preferred string formatting approach in modern Python code. _[Claude. AI-generated response to Python f-strings query [edited]. Claude.ai. Anthropic, October 19, 2025.]_

</div>

_See_
<a id="displayText" href="javascript:linkAlert();"><span class="linkNote">https:\//docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals</span></a>.

</div>
</div>
</details>

<!-- Put a set of navigation tools at a fixed position at the bottom of the Help screen
-->
<div class="doc-footer" style="text-align: left;padding-left:50px;">
<div class="button-container">
<input type="button" value="Back" class="button happy-button" onclick="history.back()"/>
⍠⍠⍠&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="button normal-button" value="Top" onclick="window.location='#top'"/>
<input type="button" class="button normal-button" value="Contents" onclick="window.location='#table-of-contents'"/>
<input type="button" class="button normal-button" value="Examples" onclick="window.location='#f-examples-a-primer'"/>
<input type="button" class="button normal-button" value="Syntax" onclick="window.location='#f-syntax-and-other-information'"/>
<input type="button" class="button normal-button" value="Appendices" onclick="window.location='#appendices'"/> 
<input type="button" class="button normal-button" value="Bottom" onclick="window.location='#copyright'"/>&nbsp;&nbsp;&nbsp;&nbsp;
⍠⍠⍠
</div>
</div>

---

<br>
<span id="copyright" style="font-family:cursive;">
Copyright <big>©</big> 2025 Sam the Cat Foundation. [2025-11-11T20:59:23]
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
