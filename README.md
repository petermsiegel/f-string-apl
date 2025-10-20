<div class="right-margin-bar"> 

<br>
<div class="pMarquee">
<em><strong>∆F</strong></em> is a function for Dyalog APL that 
interprets <em>f‑strings</em>, a concise, yet powerful way to display multiline APL text, arbitrary APL expressions, and multi&shy;dimensional objects using extensions to 
<em>dfns</em> and other familiar tools.
</div>

# Table of Contents  

<details>     <!-- option: open -->
<summary class="summary">&ensp;Show/Hide <em>Table of Contents</em></summary>
<span style="font-size: 90%;">

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
  - [Omega Shortcuts (Implicit)](#omega-shortcuts-implicit)
  - [Shortcuts With Individual Expressions](#shortcuts-with-individual-expressions)
  - [A Shortcut for Dates and Times (Part I)](#a-shortcut-for-dates-and-times-part-i)
  - [A Shortcut for Dates and Times (Part II)](#a-shortcut-for-dates-and-times-part-ii)
  - [The Quote Shortcut](#the-quote-shortcut)
  - [The Wrap Shortcut (Experimental)](#the-wrap-shortcut-experimental)
  - [Precomputed f‑strings with the ***DFN*** Option](#precomputed-fstrings-with-the-dfn-option)
- [∆F Syntax and Other Information](#f-syntax-and-other-information)
  - [∆F Call Syntax Overview](#f-call-syntax-overview)
  - [∆F Call Syntax Details](#f-call-syntax-details)
  - [∆F Options](#f-options)
  - [∆F Return Value](#f-return-value)
  - [∆F f‑string Building Blocks](#f-fstring-building-blocks)
  - [Code Field Shortcuts](#code-field-shortcuts)
  - [Escape Sequences For Text Fields and Quoted Strings](#escape-sequences-for-text-fields-and-quoted-strings)
  - [Quoted Strings in Code Fields](#quoted-strings-in-code-fields)
  - [Omega Shortcut Expressions: Details](#omega-shortcut-expressions-details)
  - [Wrap Shortcut: Details (Experimental)](#wrap-shortcut-details-experimental)
- [Appendices](#appendices)
  - [Appendix I: Undocumented Options](#appendix-i-undocumented-options)
  - [Appendix II: Python f‑strings](#appendix-ii-python-fstrings)

---

</span>
</details>

# Installing and Running **∆F** in Dyalog APL

<details>            <!-- option: open -->
<summary class="summary">&ensp;Show/Hide <em>Installing and Running <bold>∆F</bold></em>
</summary>

## Installing **∆F**

1. On Github, search for <mark>"f‑string-apl"</mark>. 
   - During the test phase, go to <mark>github.com/petermsiegel/f‑string-apl</mark>. 
2. Copy the files **∆Fapl.dyalog** and **∆F_Help.html** into your current working directory [^1] . 
3. Then, from your Dyalog session (typically `#` or `⎕SE`), enter:<br>
  `]load ∆Fapl [-target=`**_myns_**`]` 
   1. Each time it is called, the `]load` will create function **∆F** and namespace **⍙Fapl** in the active namespace (or **_myns_**).
      1. **⍙Fapl** contains utilities used by **∆F** and, once`]load`ed, ***should not*** be moved. 
      2. **∆F** *may* be relocated; it will refer to **⍙Fapl** in its original location.
   2. If **∆F_Help.html** is available at `]load` time, it will be copied into **⍙Fapl** (or a message will note its absence).

Now, **∆F** is available in the active namespace (or **_myns_**), along with **⍙Fapl**. 

## Running **∆F** (After It's Been Installed)

1. `]load ∆Fapl` (see above), ensuring that **∆F** and **⍙Fapl** are accessible from the current namespace.  
2. Call `∆F` with the desired argument(s) and [options](#f-call-syntax-details). **∆F** is `⎕IO`- and `⎕ML`-independent. 

---

</details>

# Overview  

<details open><summary class="summary">&ensp;Show/Hide <em>Overview</em></summary>

[^2]  
Inspired by [Python f‑strings](#appendix-ii-python-fstrings), **∆F** includes a variety of capabilities to make it easy to evaluate, format, annotate, and display related multi&shy;dimensional information. 

**∆F** *f‑strings* include: 

- The abstraction of 2-dimensional character ***fields***, generated one-by-one from the user's specifications and data, then aligned and catenated into a single overall character matrix result;
  
[^3] 

- **Text** fields, supporting multiline Unicode text within each field, with the sequence `` `◇ `` (**backtick** + **statement separator**) generating a newline, <small>`⎕UCS 13`</small>; 

- **Code** fields, [^4] allowing users to evaluate and display APL arrays of any dimensionality, depth and type in the user environment, arrays passed as **∆F** arguments, as well as arbitrary APL expressions based on full multi-statement dfn logic.Each **Code** field must return a value, simple or otherwise, which will be catenated with other fields and returned from **∆F**;

  **Code** fields also provide a number of concise, convenient extensions, such as:

  - **Quoted strings** in **Code** fields, with several quote styles:

    - **double-quotes**<br>
      `∆F '{"like this"}'` or `` ∆F '{"on`◇""three""`◇lines"} ``,
    - **double angle quotation marks**,[^5] <br>
      `∆F '{«with internal quotes like "this" or ''this''»}'`, not to mention   
    -  APL's tried-and-true embedded **single-quotes**,<br>
      `∆F '{''shown ''''right'''' here''}'`.

  - Simple shortcuts[^6]  for

    - **format**ting numeric arrays, **\$** (short for **⎕FMT**): `∆F '{"F7.5" $ ?0 0}'`,
    - putting a **box** around a specific expression, **\`B**: `` ∆F'{`B ⍳2 2}' ``,
    - placing the output of one expression **above** another, **%**: `∆F'{"Pi"% ○1}'`,
    - formatting **date** and **time** expressions from APL timestamps (**⎕TS**) using **\`T** (combining&nbsp;**1200⌶** and **⎕DT**): `` ∆F'{"hh:mm:ss" `T ⎕TS}' ``,
    - _and more_;

  - Simple mechanisms for concisely formatting and displaying data from
    - user arrays or arbitrary code: <br>`tempC←10 110 40`<br>`∆F'{tempC}'` or `∆F'{ {⍵<100: 32+9×⍵÷5 ◇ "(too hot)"}¨tempC }'`,
      <br>
    - arguments to **∆F** that follow the format string:<br>`` ∆F'{32+`⍵1×9÷5}' (10 110 40) ``,<br> where `` `⍵1 `` is a shortcut for `(⍵⊃⍨1+⎕IO)` (here `10 110 40`),
    - _and more_;

- **Space** fields, providing a simple mechanism both for separating adjacent **Text** fields and inserting (rectangular) blocks of any number of spaces between any two fields, where needed;

  - one space: `{ }`; five spaces: `{     }`; or even, zero spaces: `{}`;
  - 1000 spaces? Use a code field instead: `{1000⍴""}`.

- Multiline (matrix) output built up field-by-field, left-to-right, from values and expressions in the calling environment or arguments to **∆F**;

  - After all fields are generated, they are concatenated (after appropriate vertical alignment) to form a single character matrix: ***the return value from*** **∆F**. 

[^7]   
**∆F** is designed for ease of use, _ad hoc_ debugging, fine-grained formatting and informal user interaction, built using Dyalog functions and operators.

<details>     <!-- option: open -->
<summary class="summary">&ensp;Recap: <em>The Three Field Types</em></summary><br>  


   | Field Type | Syntax | Examples | Displaying |
   |:------------:|:--------:|:---------:|:---------:|
   | **Text** | *Unicode text* | `` abc`◇def `` | 2-D Text  |
   | **Code** | `{`*dfn code plus*`}` | `{(32+9×÷∘5)degC}`<br> `{↑"one" "two"}` | Arbitrary APL<br>expressions via dfns |
   | **Space** | `{`<big>␠ ␠ ␠</big>`}` | `{  }` `{}`| Spacing & separation |
<div>
Table 3a. <strong>The Three Field Types</strong>
</div> 

<br>
</details>
</details> 

# Displaying ∆F **Help** in APL 

[^8] 
<span style="font-size: 130%;">👉 </span>To display this **HELP** information, type: `∆F⍨ 'help'`.

# ∆F Examples: A Primer

<details>            <!-- option: open -->
<summary class="summary">&ensp;Show/Hide <em>Examples: A Primer</em></summary>


Before providing information on **∆F** syntax and other details, *let's start with some examples*…

First, let's set some context for the examples. (You can set these however you want.)  

[^9] 
```
   ⎕IO ⎕ML← 0 1        
```


## Code Fields

Here are **Code** fields with simple variables. 

[^10] 
```
   name← 'Fred' ◇ age← 43
   ∆F 'The patient''s name is {name}. {name} is {age} years old.'
The patient's name is Fred. Fred is 43 years old.
```


**Code** fields can contain arbitrary expressions. With default options, **∆F** always
returns a single character matrix.
Here **∆F** returns a matrix with 2 rows and 32 columns. 

[^11] 
```
   tempC← ⍪35 85
   ⍴⎕← ∆F 'The temperature is {tempC}{2 2⍴"°C"} or {32+tempC×9÷5}{2 2⍴"°F"}'
The temperature is 35°C or  95°F.
                   85°C    185°F
2 32                
```

Here, we assign the *f‑string* to an APL variable, then call **∆F** twice!

[^12] 
```
   ⎕RL← 2342342                 
   names← 'Mary' 'Jack' 'Tony' ◇ prize← 1000
   f← 'Customer {names⊃⍨ ?≢names} wins £{?prize}!'
   ∆F f
Customer Jack wins £80!
   ∆F f
Customer Jack wins £230!
```

Isn't Jack lucky, winning twice in a row!

<details><summary class="summary">&ensp;View a fancier example...</summary>

``` 
 ⍝ Be sure everyone wins something.
   ∆F '{ ↑names }{ ⍪3⍴⊂"wins" }{ "£",⍕⍪?prize⍴⍨ ≢names }'
Jack wins £509
Mary wins £332
Ted  wins £589
```

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

[^13] 
And this is the same example with *identical* output, but built using two **Code** fields 
separated by a **Text** field with a single space.

[^14] 
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

[^15] 
```
   fNm←  'John' 'Mary' 'Ted'
   lNm←  'Smith' 'Jones' 'Templeton'
   addr← '24 Mulberry Ln' '22 Smith St' '12 High St'
   
   ∆F '{↑fNm} {↑lNm} {↑addr}'
John Smith     24 Mulberry Ln
Mary Jones     22 Smith St
Ted  Templeton 12 High St
```

[^16] 

Here's a slightly more interesting code expression, using `$` (a shortcut for `⎕FMT`)
to round Centigrade numbers to the nearest whole degree and Fahrenheit numbers to the nearest tenth of a degree.

```
   C← 11.3 29.55 59.99
   ∆F 'The temperature is {"I2" $ C}°C or {"F5.1"$ 32+9×C÷5}°F'
The temperature is 11°C or  52.3°F
                   30       85.2
                   60      140.0
```

## The Box Shortcut  
We now introduce the **Box** shortcut `` `B ``. Here we place boxes around key **Code** fields in this same example.

```
   C← 11.3 29.55 59.99
   ∆F '`◇The temperature is {`B "I2" $ C}`◇°C or {`B "F5.1" $ 32+9×C÷5}`◇°F'
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
we can place a box around ***each*** field (*regardless* of type) by setting **∆F**'s *third* option, **Box** [mode](#f-call-syntax-details), [^17] to `1`:

```
   C← 11.3 29.55 59.99
       ↓¯¯¯ Box mode
   0 0 1 ∆F '`◇The temperature is {"I2" $ C}`◇°C or {"F5.1" $ 32+9×C÷5}`◇°F'
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

<details><summary class="summary">&ensp;Peek</summary>


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
[^18] 
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

[^19] 
[^20] 
The expression `` `⍵0 `` always refers to the *f‑string* itself. Try this yourself.


```
   ∆F 'Our string {`⍵0↓} is {≢`⍵0} characters'
```

<details><summary class="summary">&ensp;Peek</summary>

```
   ∆F 'Our string {`⍵0↓} is {≢`⍵0} characters'
Our string                  `⍵0↓                  is 38 characters
           Our string {`⍵0↓} is {≢`⍵0} characters                 
``` 

</details>

## The Format Shortcut

[^21] 

> Let's add commas to some very large numbers using the **⎕FMT** shortcut `$`.

We can use Dyalog's built-in formatting specifier "C" with shortcut `$` 
to add appropriate commas to the temperatures!

[^22] 
```
⍝  The temperature of the sun at its core in degrees C.
   sun_core← 15E6                   ⍝ 15000000 is a bit hard to parse!
   ∆F 'The sun''s core is at {"CI10" $ sun_core}°C or {"CI10" $ C2F sun_core}°F'
The sun's core is at 15,000,000°C or 27,000,032°F
```

## The Shortcut for Numeric Commas 

[^23] 
The shortcut for *Numeric* **Commas**  `` `C `` adds commas every 3 digits (from the right) to one or more numbers or numeric strings.It has an advantage over the `$` (Dyalog's `⎕FMT`) specifier: it doesn't require you to guesstimate field widths.


Let's use the `` `C `` shortcut to add the commas to the temperatures!

[^24] 
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

[^25]  
> Self-documenting Code fields (SDCFs) are a useful debugging tool.

What's an SDCF? An SDCF allows whatever source code is in a **Code** field to be automatically displayed literally along with the result of evaluating that code.


The source code for a **Code** field can automatically be shown in **∆F**'s output—

- to the *left* of the result of evaluating that code; or,
- centered *above* the result of evaluating that code. 

All you need do is enter

- a right arrow <big>`→`</big> for a **horizontal** SDCF, or
- a down arrow <big>`↓`</big> (or <big>`%`</big>)[^26]  for a **vertical** SDCF,

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

[^27] 
Here's a useful feature. Let's use the shortcut `%` to display one expression centered above another; 
it's called **Above** and can *also* be expressed as `` `A ``. 

[^28] 
```
   ∆F '{"Employee" % ⍪`⍵1} {"Age" % ⍪`⍵2}' ('John Smith' 'Mary Jones')(29 23)
Employee    Age
John Smith  29
Mary Jones  23
```

## Omega Shortcuts (Implicit)  

> The _next_ best thing: the use of `` `⍵ `` in **Code** field expressions…

We said we'd present the use of **Omega** shortcuts with implicit indices `` `⍵ `` in **Code** fields. The expression `` `⍵ `` selects the _next_ element of the right argument `⍵` to **∆F**, defaulting to `` `⍵1 `` when first encountered, *i.e.* if there are **_no_** `` `⍵ `` elements (*explicit* or *implicit*) to the **_left_** in the entire *f‑string*. If there is any such expression (*e.g.* `` `⍵5 ``), then `` `⍵ `` points to the element after that one (*e.g.* `` `⍵6 ``). If the item to the left is `` `⍵ ``, then we simply increment the index by `1` from that one.

**Let's try an example.** Here, we display arbitrary 2-dimensional expressions, one above the other. 
`` `⍵ `` refers to the **_next_** argument in sequence, left to right, starting with `` `⍵1 ``, the first, *i.e.* `(⍵⊃⍨ 1+⎕IO)`. 
So, from left to right `` `⍵ `` is `` `⍵1 ``, `` `⍵2 ``, 
and `` `⍵3 ``. 

[^29] 
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

<details><summary class="summary">&ensp;Peek: Shortcuts are just Functions</summary>

While not for the faint of heart, the expression above can be recast as this somewhat hard to read alternative: 

``` 
   ∆F '{%/ `B∘⍳¨ `⍵1 `⍵2}' (2 2)(3 3)
```

</details

> There are loads of other examples to discover.

## A Shortcut for Dates and Times (Part I)  

[^30] 
**∆F** supports a simple **Date-Time** shortcut `` `T `` built from **1200⌶** and **⎕DT**. It takes one or more Dyalog `⎕TS`-format timestamps as the right argument and a date-time specification as the (optional) left argument. Trailing elements of a timestamp may be omitted (they will each be treated as `0` in the specification string).

Let's look at the use of the `` `T `` shortcut to show the current time (now).

[^31] 

```
   ∆F 'It is now {"t:mm pp" `T ⎕TS}.'
It is now 8:08 am.
```


Here's a fancier example[^32] .
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
expression `` `⍵1 ``, whose argument [^33]  is passed in parentheses.

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

[^34] 
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

<details><summary class="summary">&ensp;Peek to see the example with `iv` defined.</summary>

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

<details><summary class="summary">&ensp;Take a peek at the <bold>∆F</bold> output.</summary>

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
[^35] 

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
</div>

## Precomputed f‑strings with the <span style="font-size: 80%;">***DFN***</span> Option

[^36]  
The default returned from **∆F** is always (on success) a character matrix. That can be expressed schematically via expression *(a),* shown here: 

    (a) 0 ∆F… 


However, if the initial [∆F Options](#f-call-syntax-details)(**_DFN_**) is `1`, as in *(b),*

    (b) 1 ∆F… 
    
then [^37] 
**∆F** returns a **dfn** that, *when called later*, will return precisely the same character expression as for *(a)*.
This is most useful when you are making repeated use of an *f‑string*, since the overhead for analyzing the *f‑string* contents _once_ will be amortized over all the calls.


Let's explore an example where getting the best performance for a heavily
used **∆F** string is important. 

First, let's grab `cmpx`, so we can compare the performance…

```
   'cmpx' ⎕CY 'dfns'
```

Now, let's proceed. Here's the code:

```
   C← 11 30 60

⍝ Here's our ∆F String t
   t←'The temperature is {"I2" $ C}°C or {"F5.1" $ F← 32+9×C÷5}°F'

⍝  Let's precompute a dfn T, given ∆F String t.
⍝  It has everything needed to generate the output
⍝  (except any external variables or additional arguments referenced).
   T←1 ∆F t

⍝  Compare the performance of the two formats…
⍝  The precomputed version is about 17 times faster, in this run.
   cmpx '∆F t' 'T ⍬'
∆F t → 1.7E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕
 T ⍬ → 1.0E¯5 | -94% ⎕⎕
```

> Before we get to syntax and other information…

Finally, we want to show you that
[^38] 
the _dfn_ returned from `1…∆F…` can retrieve argument(s) passed on the right side of **∆F**, using the very same omega shortcut expressions (`` `⍵1 ``, etc.) as described above. 


As a variation on the example above, let's share the centigrade value,
not as a *variable*, but as the *first argument* to **∆F** (*i.e.* `` `⍵1` ``).

```
   t←'The temperature is {"I2" $ `⍵1}°C or {"F5.1" $ F← 32+9×`⍵1÷5}°F'
   T← 1 ∆F t

   ∆F t 35
The temperature is 35°C or 95.0°F

   T 35
The temperature is 35°C or 95.0°F

   cmpx '∆F t 35' 'T 35'
∆F t 35 → 1.7E¯4 |   0% ⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕⎕
   T 35 → 8.9E¯6 | -95% ⎕⎕
```


---

Below, we summarize key information you've already gleaned from the examples.

</details>


# ∆F Syntax and Other Information

<details>        <!-- option: open -->       
<summary class="summary">&ensp;Show/Hide <em>Syntax Info</em></summary>

## ∆F Call Syntax Overview

| Call Syntax<div style="width:290px"></div> | Description |
| :----- | :---------- |
| **∆F**&ensp;***f‑string*** | Display an _f‑string_; use the _default_ options. The string may reference objects in the environment or in the string itself. Returns a character matrix. |
| **∆F**&ensp;***f‑string***&ensp;***args*** | Display an _f‑string_; use the _default_ options. Arguments presented _may_ be referred to in the f‑string. Returns a character matrix. |
| ***options***&ensp;**∆F**&ensp;***f‑string***&ensp;[***args***] | Display an _f‑string_; control the result with _options_ specified (see below). <br>If *DFN* (see below) is `0` or omitted, returns a character matrix.<br>If *DFN* is `1`, returns a dfn that will display such a matrix (given an identical system state). |
| 'help'&ensp;**∆F**&ensp;' ' | Display help info and examples for **∆F**. The _f‑string_ is not examined. |
| **∆F**⍨'help' | Display help info and examples for **∆F**. |
<div>Table 6a. <strong>∆F Call Syntax Overview</strong></div>

<br>

## ∆F Call Syntax Details

| Element<div style="width:290px"></div> | Description |
| :----- | :---------- |
| **_f‑string_** | a format string, a single character vector. |
| **_args_** | elements of ⍵ after the *f‑string*, each of which can be accessed in the *f‑string* via an **Omega** shortcut (`` `⍵𝑑𝑑 ``, *etc.*) or an ordinary *dfn* `⍵` expression. |
| ***options***:&nbsp;*mode* | `options←` <span class="red">[</span> <span class="red">[</span> `0` <span class="red">[</span> `0` <span class="red">[</span> `0` <span class="red">[</span> `0` <span class="red">]</span>     <span class="red">]</span>     <span class="red">]</span>     <span class="red">]</span>     &nbsp;<span class="red">**\|**</span> `'help'` <span class="red">]</span> |
| &emsp;***options[0]***:<br>&emsp;&emsp;  ***DFN*** *output mode* | If `1`: **∆F** returns a dfn, which (upon execution) produces the same output as the default mode.<br>If `0` (default): **∆F** returns a char. matrix. |
| &emsp;***options[1]***:<br>&emsp;&emsp; ***DBG*** *(debug) mode* | If `1`: Renders newline characters from `` `◇ `` as the visible `␤` character. Displays the source code that the *f‑string* **_actually_** generates; if **_DFN_** is also `1`, this will include the embedded *f‑string* source (accessed as `` `⍵0 ``).  After the source code is displayed, it will be executed or converted to a *dfn* and returned (see the ***DFN*** option above).<br>If `0` (default): Newline characters from `` `◇ `` are rendered normally as carriage returns, `⎕UCS 13`; the ***DFN*** source code is not displayed.      |
| &emsp;***options[2]***:<br>&emsp;&emsp; ***BOX*** *mode*         | If `1`: Each field (except a null **Text** field) is boxed separately.<br>If `0` (default): Nothing is boxed automatically. Any **Code** field expression may be explicitly boxed using the **Box** shortcut, `` `B ``.<br><small>**Note**: ***BOX*** mode can be used both with ***DFN*** and default output mode.</small> |
| &emsp;***options[3]***:<br>&emsp;&emsp;***INLINE*** *mode*       | If `1` and the ***DFN*** option is set: The code for each internal support function used is included in the *dfn* result; ***no*** reference to namespace **⍙Fapl** will be made during the execution of that *dfn*.<br>If `0` (default): Whenever **∆F** or a *dfn* generated by it is executed, it makes calls to library routines in the namespace **⍙Fapl**, created during the `]load ∆Fapl` process.<br><small>**Note:** This option is experimental and may simply disappear one day.</small> |
| &emsp;'help' | If `'help'` is specified, this amazing documentation is displayed. |
| **_result_** | If `0=⊃options`, the result is always a character matrix.<br>If `1=⊃options`, the result is a dfn that, _when executed in the same environment with the same arguments_, generates that same character matrix. <br><small>**Note**: If an error is signalled, no result is returned.</small> |
<div>Table 6b. <strong>∆F Call Syntax Details</strong></div>


<br>

## ∆F Options 

- If the left argument `⍺` is omitted, the options default to `4⍴0`.
- If the left argument `⍺` is a simple integer vector or scalar, or an empty numeric vector `⍬`, the options are `4↑⍺`; subsequent elements are ignored;
- If the left argument `⍺` starts with `'help'` (case ignored), this help information is displayed. In this case only, the right argument to **∆F** is ignored.
- Otherwise, an error is signaled.

## ∆F Return Value

- Unless the **DFN** option is selected, **∆F** always returns a character matrix of at least one row and zero columns, `1 0⍴0`, on success. If the 'help' option is specified, **∆F** displays this information, returning `1 0⍴0`.
- If the **DFN** option is selected, **∆F** always returns a standard Dyalog dfn on success.
- On failure of any sort, an informative APL error is signaled.

## ∆F f‑string Building Blocks

The first element in the right arg to ∆F is a character vector, an *f‑string*,
which contains one or more **Text** fields, **Code** fields, and **Space** fields in any combination.

- **Text** fields consist of simple text, which may include any Unicode characters desired, including newlines. Newlines (actually, carriage returns, `⎕UCS 13`) are normally entered via the sequence `` `◇ ``. Additionally, literal curly braces can be added via `` `{ `` and `` `} ``, so they are distinct from the simple curly braces used to begin and end **Code** fields and **Space** fields. Finally, a single backtick escape can be entered into a **Text** field by entering two such characters together ` `` `.
  - If **∆F** is called with an empty string, `∆F ''`, it is interpreted as containing a single 0-length **Text** field, returning a matrix of shape `1 0`.
- **Code** fields are run-time evaluated expressions enclosed within
  simple, unescaped curly braces `{}`, *i.e.* those not preceded by a back-tick (see the previous paragraph). **Code** fields are, under the covers, Dyalog *dfns* with some extras. For escape sequences, see **Escape Sequences** below.
- **Space** fields appear to be a special, _degenerate_, form of **Code** fields, consisting of a single pair of simple (unescaped) curly braces `{}` with zero or more spaces in between. 
  - A **Space** field with zero spaces is a ***null*** **Space** field; while it may separate any other fields, its typical use is to separate two adjacent **Text** fields.
  - Between fields, **∆F** adds no automatic spaces; that spacing is under user control.

## Code Field Shortcuts

**∆F** **Code** fields may contain various shortcuts, intended to be concise and expressive tools for common tasks. **Shortcuts** are valid in **Code** fields only *outside* **Quoted strings**. 

**Shortcuts** include:

| Shortcut<div style="width:100px"></div> | Name<div style="width:150px"></div>      | Meaning |
| :----- | :---------- | :----- |
| **\`A**, **%** | Above | `[⍺] % ⍵`. Centers array `⍺` above array `⍵`. If omitted, `⍺←''`, *i.e.* a blank line. |
| **\`B** | Box | `` `B ⍵ ``. Places `⍵` in a box. `⍵` is any array. |
| **\`C** | Commas | `` `C ⍵ ``. Adds commas to `⍵` after every 3rd digit of the integer part of `⍵`, right-to-left. `⍵` is a vector of num strings or numbers. |
| **\`D** | Date-Time | Synonym for **\`T**. |
| **\`F**, **$** | ⎕FMT | `[⍺] $ ⍵`. Short for `[⍺] ⎕FMT ⍵`. (See APL documentation). |
| **\`Q** | Quote | `` [⍺]`Q ⍵ ``. Recursively scans `⍵`, putting char. vectors, scalars, and rows of higher-dimensional strings in APL quotes, leaving other elements as is. If omitted, `⍺←''''`. |
| **\`T** | Date-Time | `` [⍺]`T ⍵ ``. Displays timestamp(s) `⍵` according to date-time template `⍺`. `⍵` is one or more APL timestamps `⎕TS`. `⍺` is a date-time template in `1200⌶` format. If omitted, `⍺← 'YYYY-MM-DD hh:mm:ss'`. |
| **\`W** | Wrap <span class="red"><small>**EXPERIMENTAL!**</small></span>    | `` [⍺]`W ⍵ ``. Wraps the rows of simple arrays in ⍵ in decorators `0⊃2⍴⍺` (on the left) and `1⊃2⍴⍺` (on the right). If omitted, `⍺←''''`. _See details below._ |
| **\`⍵𝑑𝑑**, **⍹𝑑𝑑** | Omega Shortcut (<small>EXPLICIT</small>) | A shortcut of the form `` `⍵𝑑𝑑 `` (or `⍹𝑑𝑑`), to access the `𝑑𝑑`**th** element of `⍵`, *i.e.* `(⍵⊃⍨ 𝑑𝑑+⎕IO)`. _See details below._ |
| **\`⍵**, **⍹** | Omega Shortcut (<small>IMPLICIT</small>) | A shortcut of the form `` `⍵ `` (or `⍹`), to access the **_next_** element of `⍵`. _See details below._ |
| **→**<br>**↓** *or* **%** | Self-documenting **Code** Fields <small>(SDCFs)</small>| `→`/`↓` (synonym: `%`) signal that the source code for the **Code** field appears before/above its value. Surrounding blanks are significant. *See [SDCFs](#self-documenting-code-fields-sdcfs) in __Examples__ for details.* |
<div>Table 6c. <strong>Code Field Shortcuts</strong></div>

<br>

## Escape Sequences For Text Fields and Quoted Strings

[^39]  
**∆F** **Text** fields and **Quoted strings** in **Code** fields may include
a small number of escape sequences, beginning with the backtick `` ` ``. 
Some sequences are valid in **Text** fields *only*, but not in Quoted strings:

[^40] 

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

[^41] 
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

## Wrap Shortcut: Details (Experimental) 

1. Syntax: `` [⍺←''''] `W ⍵ ``.
2. Let `L←0⊃2⍴⍺` and `R←1⊃2⍴⍺`.
3. Wrap each row `X′` of the simple arrays `X` in `⍵` (or the entire array `X` if a simple vector or scalar) in decorators `L` and `R`: `L,(⍕X′),R`.
4. `⍵` is an array of any shape and depth.`L`and `R`are char. vectors or scalars or `⍬` (treated as `''`).
5. If there is one scalar or enclosed vector `⍺`, it is replicated _per (2) above_.
6. By default,`⍺← ''''`,*i.e.* APL quotes will wrap the array ⍵, row by row, whether character, numeric or otherwise.

---

</div> 
</details> 

# Appendices
 
<details><summary class="summary">&ensp;Show/Hide <em>Appendices</em></summary>

## Appendix I: Undocumented Options

1. If `options[0]` is `¯1`, [^42] then **∆F** returns a character vector that contains the source code for the *dfn* that would have been returned via the ***DFN*** option, `options[0]=1`. 
If ***DBG*** is also set, newlines from `` `◇ `` are shown as visible `␤`. However, since this option returns the code string *verbatim*, the ***DBG*** option won't *display* the code string redundantly. 

2. `∆F 'help'` has a secret variant: [^43] `∆F 'help-narrow'`. 
With this variant, the help
session will start up with a narrower screen *without* side notes. If the user widens the
screen, the side notes will appear, as in the default 
case: [^44] `∆F 'help'`.

## Appendix II: Python f‑strings

Python f-strings, introduced in Python 3.6, are a modern and elegant way to format strings by embedding expressions directly inside string literals. You create an f-string by prefixing a string with the letter 'f' or 'F', and then you can include any Python expression inside curly braces within the string. When the string is evaluated, these expressions are executed and their results are automatically converted to strings and inserted at that position.
For example, `f"The sum of {a} and {b} is {a + b}"` would evaluate the addition and embed the result directly in the string. This combination of simplicity, power, and performance has made f-strings the preferred string formatting approach in modern Python code. *[Claude (AI). Response to Python f-strings query [edited]. Claude.ai. Anthropic, October 19, 2025.]*

[^45] 
<span class="seeLinkPre">See <a id="displayText" href="javascript:showAlert(  &quot;Use regular browser to explore link.&quot;, 2000, 0);"><span class="seeLink">https:\//docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals</span></a></span>.

</div>
</div>


</details>

<!-- Put a set of navigation tools at a fixed position at the bottom of the Help screen
-->
<div class="doc-footer">
<button id="toggleDetails" class="button happybutton">Expand All Sections</button>&emsp;
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
<a href="#copyright">Copyright</a>
&nbsp;&nbsp;&nbsp; 
<button onclick="closeWindowNow()" class="button warnbutton">Close Window</span></button>
</div>

---

<br>
<span id="copyright" style="font-family:cursive;" >
Copyright <big>©</big> 2025 Sam the Cat Foundation. [20251019T223041]
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

## Footnotes

[^1]: `User command ]cd` will show you your current working directory.
[^2]: Short for "**formatted string literals**, *f‑strings* were introduced in Python in 2016. **∆F** *f‑strings* and Python's are **not** compatible.
[^3]: In this document, we use the symbol `◇` (`⎕UCS 9671`) to represent the APL *statement separator* (`⎕UCS 8900`), since the latter is displayed _in some browsers_ as a hard-to-read glyph.
[^4]: An **∆F** *f‑string*— including any **Code** fields— is limited to a single, possibly very long, character vector.
[^5]: Also known as *guillemets*, <big>**«**</big> and <big>**»**</big> are Unicode chars `⎕UCS 171 187`.
[^6]: Details on all the [shortcuts](#code-field-shortcuts) are provided later in this document.
[^7]: As a prototype, **∆F** is relatively slow, using an APL recursive scan to analyze the **f‑string**.  For a way to speed up frequently used *f‑strings*, see the [DFN option](#f-call-syntax-details).
[^8]: If `∆F⍨'help'` seems exotic, try: `'help' ∆F ⍬`.
[^9]: All examples in this document assume `⎕IO←0 ◇ ⎕ML←1`.
[^10]: So far, this is like everybody else's *f‑strings*.
[^11]: Now we're taking advantage of APL's array-oriented style.
[^12]: Setting `⎕RL` ensures our random numbers aren't random!
[^13]: We could have used a **Space** field `{ }` here as well.
[^14]: APL mix `↑` is used to convert the names (a vector of character vectors)
to a character matrix.
[^15]: Again, we use APL _mix_ `↑` to generate multiline objects (matrices).
[^16]: We could have used `0⍕⍪` and `1⍕⍪` here, of course. But we wanted to remind you what Dyalog's `⎕FMT` can do. For more, see [below](#the-format-shortcut).
[^17]: **third option**: `⍺[2+⎕IO]`.
[^18]: And `(⍵⊃⍨ 1+⎕IO)` is, of course, equivalent to `((1+⎕IO)⊃⍵)`.
[^19]: `` `⍵0 `` refers to the *f‑string* independent of the the number of elements in the right argument  to **∆F** (*effectively*, `⊆⍵`).
[^20]: We explain the <em>down arrow</em> `↓` before the <em>closing brace</em> `}` under [Self-documenting Code fields](#self-documenting-code-fields-sdcfs) below.
[^21]: `$` (*i.e.* `⎕FMT`) can also be used monadically, but **∆F** will handle that for you in most cases.
[^22]: `C2F← 32+9×÷∘5`
[^23]: Typically, each number or numeric string presented to `` `C `` will represent an integer, but if a real number is presented, only the integer part will have commas added.
[^24]: Cool! OK, not literally.
[^25]: Our SDCFs are based on Python's single type of self-documenting expressions in *f‑strings*, but work somewhat differently. SDCFs are used ***only*** in **Code** fields (_duh_).
[^26]: `%` is the same glyph as for the **Above** shortcut, `%` or `` `A ``, discussed in [the next section](#the-above-shortcut).
[^27]: `%` can be used monadically. In that case, a left argument of `''` (an empty string) is assumed.
[^28]: Remember, `` `⍵1 `` designates the **_first_** argument after the *f‑string* itself, and `` `⍵2 `` the **_second_**.
[^29]: _Easy peasy._
[^30]: The syntax for the Date-Time specifications in the left argument to `` `T `` can be found in the Dyalog documentation under **1200⌶**. For the curious, here's the core *dfn* code actually used by the Date-Time shortcut: <br>&emsp;`⍺←'YYYY-MM-DD hh:mm:ss'`<br>&emsp;`∊⍣(1=≡⍵)⊢⍺(1200⌶)⊢1⎕DT ⊆⍵`
[^31]: The time displayed in practice will be the *true* current time.
[^32]: The power is in the capabilities of `1200⌶` and `⎕DT`.
[^33]: `(2025 1 21)`
[^34]: If a multi&shy;dimensional character array is found, its <em>rows</em> are quoted; if a character vector, it is quoted <em>in toto</em>; else, each character <em>scalar</em> is quoted in isolation.
[^35]: For more, see [Wrap Shortcut: Details](#wrap-shortcut-details-experimental) _below_.
[^36]: **∆F**'s default initial option (left argument) is `0`, so `0 ∆F…` and `∆F…` are equivalent. We discuss all [the options to ∆F](#f-call-syntax-details) below.
[^37]: This assumes the resulting dfn is called with the same arguments in the same calling environment in the same state.
[^38]: The *dfn* returned includes the original *f‑string* text used to generate it,
available as `` `⍵0 ``.
[^39]: See [Quoted Strings in Code Fields](#quoted-strings-in-code-fields)
below on displaying quote characters like `"` in a string.
[^40]: **Both**: *i.e.* **Text** fields and *Quoted Strings* in **Code** fields.
[^41]: Compare these examples:<br>&emsp;**Invalid:**&ensp;<span class="red">∆F&ensp;'{"abc\`"def"}'</span><br>&emsp;**Valid:**&ensp;`` ∆F '{"abc""def"}' ``
[^42]: In simple terms, this option returns the character representation of the
*dfn* returned via the ***DFN*** option.
[^43]: *Or*, `∆F 'help-n'`.
[^44]: *Or*, `∆F 'help-wide'`.
[^45]: <a id="displayText" href="#overview">Return to Overview.</a>
