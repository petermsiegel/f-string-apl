⍝:Section CORE 
:Namespace ⍙Fapl   
  ⎕IO ⎕ML ⎕PP←0 1 34            ⍝ Namespace scope. User code is executed in caller space (⊃⎕RSI) 

⍝ GENERAL GLOBAL VARIABLES 
  TRAP_ERRORS← 1                ⍝ TRAP_ERRORS: If 0, turns off error trapping in ∆F
  VERBOSE←     0                ⍝ VERBOSE: Compile-time and run-time verbosity flag
  VERSION←     '0.1.1'          ⍝ Set/updated by ∆F_Publish.dyalog...

⍝ VARIABLES FOR ∆F OPTIONS: Positional and keyword 
  OPTS_KW←    'dfn' 'verbose' 'box' 'auto' 'inline'        ⍝ In order 
  OPTS_DEF←   0     0         0     1      0     
  OPTS_N←     ≢OPTS_DEF 

⍝ SESSION LIBRARY (£ or `L) VARIABLES
⍝ LIB_AUTO:  1   We want to use the SESSION LIBRARY autoload.
⍝            0   We don't want to use SESSION LIBRARY autoload.
  LIB_AUTO←  1     
  LIB_SOURCE←  '∆F/∆Fapl_Library.dyalog'  ⍝ Library shortcuts (£,  `L) utilities.
⍝ HELP-related globals             
  HELP_HTML←   '∆F/∆F_Help.html'          ⍝ Called from 'help' option. Globally set here

⍝ ESCAPE_CHAR: Allows an installation to use a different single-char "escape"
⍝ character in place of "`".  See var. ¨esc¨.
⍝ If ESCAPE_CHAR is omitted or ⍬ (length 0), the default ¨esc¯ "`" is used.
  ESCAPE_CHAR← '`'

⍝ Quote pairs, i.e. beyond double quotes and single quotes.
⍝ QUOTES_SUPPLEMENTAL must consist of 0 or more PAIRS of left AND right quotes.
  QUOTES_SUPPLEMENTAL← 1⍴'«»' '“”'        ⍝ Only '«»'  is "standard" 

⍝ ==================================================================================

⍝ Set char. rendering of ⎕THIS. We may set ⎕THIS.⎕DF later, but ∆THIS will remain as is.
  ∆THIS← ⍕⎕THIS                

⍝ ============================   ∆F (User Function)   ==============================
⍝ ∆F_Src is modified to become ##.∆F, editing __THIS__, __OUTER__.
⍝ ∆F: 
⍝    result← {opts←⍬} ∇ f-string [args]
⍝ ¨⎕THIS¨ will be hardwired as ∆F is promoted out of ⍙Fapl.
⍝ As soon as ∆F starts, it runs substantive back in the ⍙Fapl namespace,
⍝ since it includes a few ⊃ and ↑ functions that are ⎕ML dependent.
⍝ ∆F must be a tradfn, since it may return a dfn (with 1=⊃opts)
⍝
⍝ Actions...
⍝   If opts is not a simple vector with all integer options,
⍝           calls ⎕THIS.Help to display HELP or signal an error.
⍝   With opts an integer vector, examine (⊃opts). 
⍝    If  1: Returns executable dfn CODE generated from the f-string (if valid).                   
⍝    If ¯1: Undocumented option-- returns dfn code in string form. 
⍝           Useful for benchmarking compile-only step using dfns.cmpx.
⍝           (⍎¯1... ∆F ...)args <===> (1... ∆F ...)args 
⍝    If 0 or anything else:
⍝           Handle options (valid and invalid) in ⎕THIS.FmtScan
⍝           Returns matrix RESULT of evaluating the f-string.
⍝ 
⍝   See ⍙Export∆F below for converting ∆F_Src to ∆F and to ##.∆F. 
⍝       It sets __THIS__ and __OUTER__.
⍝   Modify __THIS__ or __OUTER__ at your peril.
⍝ BEGIN ====================   ∆F (User Function)   ==============================
  ∇ result← {opts} ∆F_Src args                               
    :With __THIS__                                       
      :Trap 0/⍨ TRAP_ERRORS                  
        ⍝ Get options (NB. ⎕NC 9 "opts" not autom. visible in :With namespace) 
        :If  900⌶0                                         ⍝ Default opts
          opts←OPTS_DEF 
        :ElseIf 9=__OUTER__.⎕NC 'opts'                     ⍝ Kw opts via AplAN
          opts← __OUTER__.opts ∆VGET (↑OPTS_KW) OPTS_DEF   ⍝   (Extra kw opts not checked)        
        :ElseIf 11 83∊⍨ ⎕DR opts                           ⍝ Positional opts (bool or small int)
          opts,← OPTS_DEF↑⍨ 0⌊OPTS_N-⍨ ≢opts               ⍝   (Trailing opts not checked)
        :Else                                           
          result← Special opts ⋄ :Return                   ⍝ 'help' or error!                                         ⍝ default: positional parameters
        :EndIf 
        (⊃args)←∊⊃args← ,⊆args                             ⍝ If f-string is multiline, flatten!
      ⍝ Determine output mode and execute.
        :Select ⊃opts    
        :Case  0       ⍝ (dfn:  0)    => Execute fstring
          result← opts ((⊃⎕RSI){ ⍺⍺⍎ ⍺ FmtScan ⊃⍵⊣ ⎕EX 'opts' 'args'}) args    
        :Case  1       ⍝ (dfn:  1)    => Return dfn incorporating fstring   
          result← (⊃⎕RSI)⍎ opts FmtScan ⊃args
        :Case ¯1       ⍝ (dfn: ¯1)    => Return dfn source code incorporating fstring                               
          result← opts FmtScan ⊃args            
        :Else          ⍝ 'help', etc. => Give help, etc.      
          result← Special opts 
        :EndSelect   
      :Else 
        ⎕SIGNAL ⊂⎕DMX.('EM' 'EN' 'Message' ,⍥⊂¨('∆F ',EM) EN Message) 
      :EndTrap 
   :EndWith 
  ∇
⍝ END ====================   ∆F (User Function)   ==============================  


⍝ ============================   FmtScan ( top-level routine )   ============================= ⍝
⍝ FmtScan: 
⍝    result← [options|⍬] ∇ f_string
⍝ "Main" function called by ∆F above. See the Executive section below.
⍝ Calls Major Field Recursive Scanners: 
⍝    TF: text, CF_SF: code fields and space fields, CFStr: (code field) quoted strings
  FmtScan← {  
    ⍝ TF: Text Field Scan 
    ⍝     (accum|'') ∇ str
    ⍝ Calls: TF (recursively) and CF_SF (which calls TF in return).
    ⍝ Returns: null. Appends APL code strings to fG
    TF← {  
        p← TFBrk ⍵                                     ⍝ esc, lb, or nl only. 
      p= ≢⍵: TFDone ⍺, ⍵                               ⍝ No special chars in ⍵. Process & return.
        pfx c w← (p↑⍵) (p⌷⍵) (⍵↓⍨ p+1) 
      c= esc: (⍺, pfx, nlG TFEsc w) ∇ 1↓ w             ⍝ char is esc. Process & continue.
        CF_SF w⊣ TFDone ⍺, pfx                         ⍝ char is lb. End TF; go to CF_SF.  
    } ⍝ End Text Field Scan 

  ⍝ TFDone: If a text field is not 0-length, place in quotes and add it to fG.
  ⍝ Ensure adjacent fields are sep by ≥1 blank.
    TFDone← {0≠ ≢⍵: 0⊣ fG,← ⊂sp_sq, sq,⍨ ⍵/⍨ 1+ sq= ⍵ ⋄ ⍬}    

  ⍝ CF_SF: Code and Space Field Scan (monadic only).
  ⍝     res← ∇ str, where str starts just past the leading '{' of the CF.  
  ⍝ Called by TF. 
  ⍝ If it sees /^\s*\}/, it emits SF code (if no spaces) and recurses "back" to TF.
  ⍝ Otherwise, it processes a code field. 
  ⍝ Returns: null. Appends APL code strings to fG. Sets/modifies brG, cfG.
    CF_SF← {                                              
        cfBeg← w← ⍵                                    ⍝ cfBeg: Save the CF verbatim. Used in ⍙Scan.
      rb= ⊃w: '' TF 1↓ w                               ⍝ Null SF? No code gen'd. => Done. [FAST]
        w↓⍨← nSp← +/∧\' '= w                           ⍝ Count/skip over (≥0) leading spaces...
      rb= ⊃w: '' TF 1↓ w⊣ fG,← ⊂SFCode nSp             ⍝ SF? => Done.
        brG cfG⊢← 1 nSp                                ⍝ CF => Scan Code Field
        ⍙Scan← {                                       ⍝ Reads cfV above. Modifies cfG, brG.  
            cfG+← 1+ p← CFBrk ⍵
          p= ≢⍵:  ⎕SIGNAL brÊ                          ⍝ Missing "}" => Error. 
            pfx c w← (⍺, p↑⍵) (p⌷⍵) (⍵↓⍨ p+1)          ⍝ Some cases below (marked [１]) are ordered! 
          c= sp:     (pfx, sp) ∇ w↓⍨ cfG+← p← +/∧\' '=w ⍝ Handle runs of blanks
         (c= rb)∧ brG≤ 1: (TrimR pfx) w                ⍝ [１] Closing "}" => Return... Scan complete! 
          c∊ lb_rb:  (pfx, c) ∇ w⊣ brG+← -/c= lb_rb    ⍝ [１] Inc/dec brG as appropriate
          c∊ qtsL:   (pfx, a) ∇ w⊣  cfG+← c⊣ a w c← CFStr c w  ⍝ Opening quote => CFStr  
          c= dol:    (pfx, d2⊃ scF scS) ∇ w↓⍨ d2←dol=⊃w  ⍝ $ => ⎕FMT,$$ => Serialise 
          c= esc:    (pfx, a)  ∇ w⊣ a w← CFEsc w       ⍝ `⍵, `⋄, `A, `B, etc.
          c= omUs:   (pfx, a)  ∇ w⊣ a w← CFOm w        ⍝ ⍹, alias to `⍵ (see CFEsc).
        ⍝ c= '£':    Auto returns the Library namespace as text after any required loads.
          c= libCh:  (pfx, ⎕THIS libUtil.LibAuto w ) ∇ w  
         ~c∊sdcfCh:  ⎕SIGNAL cfLogicÊ                  ⍝ CFBrk leaked unknown char.
        ⍝ '→', '↓' or '%'. See if a "regular" char/shortcut or self-defining code field        
          brG>1:     (pfx, c scA⊃⍨ c= pct) ∇ w         ⍝ internal dfn => not SDCF
            p← +/∧\' '=w
          rb≠ ⊃p↓w:  (pfx, c scA⊃⍨ c= pct) ∇ w         ⍝ not CF-final '}' => not SDCF
            codeStr← AplQt cfBeg↑⍨ cfG+ p              ⍝ SDCF! Put CF-literal in quotes
           (codeStr, (scA scM⊃⍨ c='→'), pfx) (w↓⍨ p+1) ⍝ Assemble SDCF and return from ⍙Scan.
        }
        a w← '' ⍙Scan w
        '' TF w⊣ fG,← ⊂'(', lb, a, rb, '⍵)'            ⍝ Process field & then head to TF
    } ⍝ End CF_SF (Code/Space Field Scan)
  
  ⍝ SFCode: Generate a SF code string; ⍵ is a pos. integer. (Used in CF_SF above)
    SFCode← ('(',⊢ ⊢,∘'⍴'''')')⍕  

  ⍝ CFStr: CF Quoted String Scan
  ⍝        val←  ∇ qtL fstr 
  ⍝ ∘ Right now, qtL must be ', ", or «, and qtR must be ', ", or ». 
  ⍝ ∘ For quotes with different starting and ending chars, e.g. « » (⎕UCS 171 187).
  ⍝   If « is the left qt, then the right qt » can be doubled in the APL style, 
  ⍝   and a non-doubled » terminates as expected.
  ⍝ Note: See note at <c= nl> below. See also function TF.
  ⍝ Returns val← (the string at the start of ⍵) (the rest of ⍵) ⍝  
    CFStr← { 
        qtL w← ⍵ ⋄ qtR← (qtsL⍳ qtL)⌷ qtsR              ⍝ See above.
        CFSBrk← ⌊/⍳∘(esc qtR)    
        lenW← ¯1+ ≢w                                   ⍝ lenW: length of w outside quoted str.
        ⍙Scan← {   ⍝ Recursive CF Quoted-String Scan. lenW converges on true length.
          0= ≢⍵: ⍺ 
            p← CFSBrk ⍵  
          p= ≢⍵: ⎕SIGNAL qtÊ 
            c c2← 2↑ p↓ ⍵ 
        ⍝ See QSEsc for handling of esc+qtR as esc char plus closing quote (see below)
          c= esc: (⍺, (p↑ ⍵), map) ∇ ⍵↓⍨ lenW-← p+ skip ⊣ map skip← nlG QSEsc c2 qtR             
        ⍝ Closing Quote: 
        ⍝ We know if we got here that c= qtR:  
        ⍝   Now see if c2, the next char, is a second qtR, 
        ⍝    i.e. a string-internal qtR. Only qtR can be doubled (e.g. », not «)
          c2= qtR:  (⍺, ⍵↑⍨ p+1) ∇ ⍵↓⍨ lenW-← p+2      ⍝ Use APL rules for doubled ', ", or »
            ⍺, ⍵↑⍨ lenW-← p                            ⍝ Done... Return
        }
        qS← AplQt '' ⍙Scan w                           ⍝ Update lenW via ⍙Scan, then update w. 
        qS (w↑⍨ -lenW) (lenW-⍨ ≢w)                    ⍝ w is returned sans CF quoted string 
    } ⍝ End CF Quoted-String Scan
    
  ⍝ CFEsc: Handle escapes  in Code Fields OUTSIDE of CF-Quotes.
  ⍝    res← ∇ fstr
  ⍝ Returns:  code w                                   ⍝ ** Side Effects: Sets cfG, omG **
    CFEsc← {                                    
      0= ≢⍵: esc 
        c w← (0⌷⍵) (1↓⍵) ⋄ cfG+← 1   
      c∊ om_omUs: CFOm w                               ⍝ Permissively allow `⍹ as equiv to `⍵ OR ⍹ 
      c='L': (⎕THIS libUtil.LibAuto w) w 
      nSC> p← MapSC c: (p⊃ userSCs) w                  ⍝ userSCs: user shortcuts `[ABFJLTDW]. 
      c∊⍥⎕C ⎕A: ⎕SIGNAL ShortcutÊ c                    ⍝ Unknown shortcut!
        ⎕SIGNAL EscÊ c                                 ⍝ Esc-c has no mng in CF for non-Alph char c.
    } ⍝ End CFEsc 

  ⍝ CFOm:   omCode w← ∇ ⍵ 
  ⍝ ⍵: /\d*/, i.e. optional digits starting right AFTER `⍵ or ⍹ symbols, for 
  ⍝ Returns omCode w:
  ⍝    omCode: the emitted code for selecting from the ∆F right arg (⍵);
  ⍝    w:      ⍵, just past the matched omega expression digits.
  ⍝ Errors Signaled: None. 
  ⍝   IntOpt matches valid digits adjacent to `⍵ or ⍹, if any; otherwise indicates a "bare" `⍵ or ⍹
  ⍝ Side Effects: 
  ⍝   Modifies cfG, omG to reflect the # of digits matched and their value.  
    CFOm← { oLen oVal w← IntOpt ⍵
      ×oLen: ('(⍵⊃⍨',')',⍨ '⎕IO+', ⍕omG⊢← oVal) w⊣ cfG+← oLen 
             ('(⍵⊃⍨',')',⍨ '⎕IO+', ⍕omG       ) w⊣ omG+← 1
    }
⍝ ===========================================================================
⍝ FmtScan Executive begins here
⍝    On entry: options in ⍺ are each @IS; ⍵, if valid, is @CVV or @CV ==> fstr@CV. 
⍝ =========================================================================== 
⍝ Currently, we ignore trailing opts. See [a] if you want to allow.
⍝  OPTS_N≠ ≢⍺: ⎕SIGNAL xtraÊ ⍝      ⍝     [a] Enable statement to disallow trailing opts.
    (dfn vG box aG inline)← OPTS_N↑ ⍺ ⋄ fstr← ⍵               
  ⍝ Validate options. vG [verbose] and aG [auto] are pseudo-globals, per below.
  0∊ 0 1∊⍨ (|dfn),vG box aG inline: ⎕SIGNAL optÊ                   
    VMsg← (⎕∘←)⍣(vG∧¯1≠dfn)                           ⍝ Verbose option message 
  ⍝ User Shortcuts: A, B, C, F, T~D, Q, W.  
  ⍝ Non-user Internal Shortcut Code and dfns: scÐ, Ð;  scM, M.
  ⍝ See ⍙LoadShortcuts for shortcut details and associated variables scA, scB, etc.     
    scA scB scC scÐ scF scJ scM scS scT scQ scW← inline⊃ scList  
  ⍝  userSCs must be ordered acc. to sc (sc← 'ABCFJLTDQW'). 
  ⍝ See function MapSC and its use.  
  ⍝ For £, `L, see namespace libUtil.
  ⍝          `A  `B  `C  `F  `J  `S  `T  `D  `Q  `W 
    userSCs← scA scB scC scF scJ scS scT scT scQ scW            
 
  ⍝ Pseudo-globals  camelCaseG (short names, please) 
  ⍝    vG-  runtime verbosity/debug flag. Set above.
  ⍝    aG-  runtime autoload flag. Set above. 
  ⍝                 If 0, disables library autoload mode, overriding the default and .∆F setting.
  ⍝                 If 1, honors default/.∆F setting of parms.auto∊ 0 1.
  ⍝    acG-         autoload cache char. vector of vectors 
  ⍝    nlG- newline: nl (CR) or nlVis (the visible newline '␤').  
  ⍝    fG-  global field list
  ⍝    omG- omega index counter: current index for omega shortcuts (`⍵, ⍹)  
  ⍝    brG- running count of braces '{' lb, '}' rb
  ⍝    cfG- code field running length (used when a self-doc code field (q.v.) occurs)
    acG← ⍬                                             ⍝ £ibrary shortcut "autoload" cache...
    nlG← vG⊃ nl nlVis                                  ⍝ A newline escape (`⋄) maps onto nlVis if debug mode.
    fG← ⍬                                              ⍝ zilde
    omG← brG← cfG← 0                                   ⍝ zero
  
  ⍝ Start the scan                                     ⍝ We start with a (possibly null) text field, 
  ⍝                                                    ⍝ If ⍵ has multiple lines, concat them.
    _← '' TF fstr                                      ⍝ recursively calling CF_SF and (from CF_SF) SF & TF itself, &
                                                       ⍝ ... setting fields ¨fG¨ as we go.
  0= ≢fG: VMsg '(1 0⍴⍬)', '⍨'/⍨ dfn≠0                  ⍝ If there are no flds, return 1 by 0 matrix
    fG← OrderFlds fG                                   ⍝ We will evaluate fields L-to-R
    code← '⍵',⍨ lb, rb,⍨ fG,⍨ box⊃ scM scÐ
  0=dfn: VMsg code                                     ⍝ Not dfn. Emit code ready to execute
    quoted← ',⍨⊂', AplQt fstr                          ⍝ Is dfn (1,¯1): add quoted fmt string (`⍵0)
    VMsg lb, code, quoted, rb                          ⍝ Emit dfn str ready to cvt to dfn in caller
  } ⍝ FmtScan 
⍝ === End of FmtScan ========================================================  

⍝ ===========================================================================  
⍝                            ***   CONSTANTS ***
⍝ ===========================================================================  

⍝ Simple char constants
⍝ Note: we handle two kinds of quotes: 
⍝     std same-char quotes, 'this' and "this", with std APL-style doubling.
⍝     left- and right-quotes, «like this», where only the right-quote doubling is needed
⍝     (i.e. any number of literals « can be in a «» string.)
⍝ The use of double angle quotation marks is an amusement. No good use AFAIK.
  om← '⍵'                                              ⍝ ⍵ not in cfBrklist, since not special. (See `⍵).
  nl nlVis← ⎕UCS 13 9252                               ⍝ 9252 (␤), 9229 (␍)   
⍝ esc: Set default value and installation-wide user alternative.
⍝ If global ESCAPE_CHAR is omitted or is ⍬, the default is used.
     SetEscape← { 0=⎕NC ⍵: ⍺ ⋄ 0=≢w←⎕OR ⍵: ⍺ ⋄ 1=≢w: w ⋄ ⍺⊣ ⎕←↑3⍴⊂'>>> INVALID ',⍵}
  esc← '`' SetEscape 'ESCAPE_CHAR' 
⍝ Basic quote chars
  dq sq← '"'''
⍝ Other basic characters
  sp lb rb dol omUs ra da pct libCh← ' {}$⍹→↓%£' 
⍝ Seq. `⋄ OR `◇ map onto ⎕UCS 13.
⍝ dia2[0]: Dyalog stmt separator 
⍝ dia2[1]: Alternative character that is easier to read in some web browsers. 
  dia2← ⎕UCS 8900 9671   
⍝ qtsL qtsR:
⍝    Generate left and right quote pairs... Double-quote first for efficiency.
⍝    See QUOTES_SUPPLEMENTAL
  qtsL qtsR← (dq,¨2⍴sq) { 0=≢⍵: ⍺ ⋄ ⍺,¨ ↓⍉↑,⊆⍵ } QUOTES_SUPPLEMENTAL                                  ⍝  ⋄ ◇
⍝ Order brklist chars roughly by frequency, high to low.       
  cfBrkList← sp dq sq esc lb rb dol omUs ra da pct libCh, ∊qtsL 
  tfBrkList←  esc lb                 
  lb_rb← lb rb ⋄ om_omUs← om omUs ⋄ sp_sq← sp sq ⋄   esc_lb_rb← esc lb rb  
  sdcfCh← ra da pct                                    ⍝ self-doc code field chars

⍝ Error constants and fns  
    Ê← { ⍺←11 ⋄ ⊂'EN' ⍺,⍥⊂ 'Message' ⍵ }
  brÊ←         Ê 'Unpaired brace "{"'
  qtÊ←         Ê 'Unpaired quote in code field' 
  xtraÊ←     5 Ê 'Extra options were supplied' 
  cfLogicÊ←    Ê 'A logic error has occurred processing a code field'
  optÊ←        Ê 'Invalid option(s) in left argument. For help: ∆F⍨''help'''
  ShortcutÊ←   Ê {'Sequence "`',⍵,'" does not represent a valid shortcut.'}
  EscÊ←        Ê {'Sequence "`',⍵,'" is not valid in code outside strings. Did you mean "',⍵,'"?'}
  helpFiÊ←  22 Ê 'Help file "',HELP_HTML,'" not found in current directory'

⍝ =========================================================================
⍝ Utilities (fns/ops) for FmtScan above.
⍝ These have NO side effects, so need not be in the scope of FmtScan. 
⍝ =========================================================================
⍝ See also CFSBrk
  TFBrk← ⌊/⍳∘tfBrkList
  CFBrk← ⌊/⍳∘cfBrkList

  TrimR←  ⊢↓⍨-∘(⊥⍨sp=⊢)                                ⍝ { ⍵↓⍨ -+/∧\⌽⍵= sp}
⍝ IntOpt: Does ⍵ start with a valid sequence of digits (a non-neg integer)? 
⍝ Returns 2 integers and a string: 
⍝   [0] len of sequence of digits (pos integer) or 0, 
⍝   [1] the integer value found or 0, 
⍝   [2] ⍵ after skipping the prefix of digits, if any.
⍝ If [0] is 0, then there was no prefix of digits. If there was, then it will be >0.
  IntOpt← { wid← +/∧\ ⍵∊⎕D ⋄ wid (⊃⊃⌽⎕VFI wid↑ ⍵) (wid↓ ⍵) }  ⍝ Idiom +/∧\

⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝⍝⍝ Code for Dyalog 20 services compatible with Dyalog 19...
  IS_LEGACY← { 2:: 1 ⋄  ⎕VSET⍣0⊢ 0 }⍬            ⍝ If ⎕VSET doesn't exist, it's legacy!
  ⍙Legacy← { VERBOSE: ⍵⊣ ⎕← 'NB. Legacy Fallback [',']',⍨1↓∊'.',¨⌽2↑1↓⎕SI  ⋄ ⍵ }
⍝ AN2Apl:   Use Array.Deserialise if prior to Dyalog 20.
  AN2Apl← { 
    IS_LEGACY: ⎕SE.Dyalog.Array.Deserialise ⍙Legacy ⍵
      Dfn⊢ ⎕FX 'Dfn←{'⊂⍛, ⍵, ⊂'} '    ⍝ Let APL do the work...
  }
⍝ Apl2AN: Currently, still Array.Serialise...
  Apl2AN←  ⎕SE.Dyalog.Array.Serialise
⍝ ∆VGET, ∆VSET- ⎕VGET, ⎕VSET or simulation of needed functionality for pre-Dyalog 20.
  ∆VGET← { IS_LEGACY: (↓⊃⍵) ⍺.{ 0≠⎕NC ⍺: ⎕OR ⍺ ⋄ ⍵ }¨⍙Legacy ⊃⌽⍵ ⋄ ⍺ ⎕VGET ⍵ }
  ∆VSET← { IS_LEGACY: ⍺.{ ⍎(⊃⍵),'←⊃⌽⍵'}¨⍵ ⍙Legacy ⍵ ⋄ ⍺ ⎕VSET ⍵ } 
  ⍝ ∆IfNull: Replace ⎕NULL or ⍬, where required. Calls ∆VSET for pre-Dyalog 20.
  ∆IfNull←{ ⍺ ∆VSET ⍵/⍨ (⍬∘≡∨⎕NULL∘≡)∘⍺.⎕OR∘⊃¨⍵ }
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

⍝ AplQt:  Created an APL-style single-quoted string.
  AplQt←  sq∘(⊣,⊣,⍨⊢⊢⍤/⍨1+=)                           ⍝ { sq, sq,⍨ ⍵/⍨ 1+ sq= ⍵ }

⍝ Escape key Handlers: TFEsc QSEsc   (CFEsc, with side effects, is within FmtScan)
⍝ *** No side effects *** 
⍝ TFEsc: nl ∇ fstr, where 
⍝    nl: current newline char;  fstr: starts with the char after the escape
⍝ Returns: the escape sequence.                        ⍝ *** No side effects ***
  TFEsc← { 0= ≢⍵: esc ⋄ c← 0⌷⍵ ⋄ c∊ dia2: ⍺ ⋄ c∊ esc_lb_rb: c ⋄ esc, c } 
  ⍝ QSEsc: [nl] ∇ c2 qtR, where 
  ⍝         nl is the current newline char;
  ⍝         c2 is the char AFTER the escape char,
  ⍝         qtR  is the current right quote char.
  ⍝ c2= qt: esc+qtR is treated as escape followed by end of quote str, i.e. APL rules.
  ⍝        esc+qtR is NOT treated as qtR+qtR, as if C-language (etc.) rules.
  ⍝ Returns map and len, where
  ⍝         map is whatever the escape seq or char maps onto (possibly itself), and
  ⍝        len is 1 if it used JUST the escape, and 2 if it used c2.
  ⍝ *** No side effects in caller ***
  QSEsc← { nl← ⍺ ⋄ c2 qtR← ⍵ ⋄ c2∊ dia2: nl 2 ⋄ c2= qtR: esc 1 ⋄ c2= esc: c2 2 ⋄ (esc, c2) 2 }     

⍝ OrderFlds
⍝ ∘ User flds are effectively executed L-to-R AND displayed in L-to-R order: 
⍝   ∘ ensure there are at least two fields (one null, as needed), 
⍝   ∘ reverse the ¨field¨ order now,
⍝      ∘  evaluate each field via APL ⍎ R-to-L, as normal, then 
⍝   ∘ reverse the ¨result¨  at execution time to achieve apparent L-to-R evaluation.

  OrderFlds← '⌽',(∊∘⌽,∘'⍬') 
⍝:EndSection CORE

⍝:Section HELP 
⍝ Special: Provides help info and other special info. 
⍝ Called with this syntax, where ⍺ stands for the options listed below.
⍝       '⍺' ∆F anything  OR  ∆F⍨'⍺
⍝ Special options (⍺):
⍝       'help'  or variants 'help-n[arrow]', 'help-w[ide]'
⍝       'parms'
⍝ (1 0⍴⍬)← ∇ ⍵
⍝ 1. If ⍵ is not special (any case, truncating after key letters), an error is signaled.
⍝ 2. If helpHtml is not defined, HELP_HTML will be read and copied into helpHtml. 
⍝ 3. Displays helpHtml.
  Special← { val← ⎕C⍵
  ⍝ parms: Load any new parms without a ]load. 
  ⍝        Returns display of default and user parms (as mx) in alph order.
    2≠ ⎕NC 'val': ⎕SIGNAL optÊ
    'parms'≡   val: _← libUtil.LoadParms 'defaults userFi verbose'
    'path' ≡   val: _← libUtil.ShowPath ⍬ 
    'help' ≢ 4↑val: ⎕SIGNAL optÊ 
  ⍝ help, help-wide, or help-narrow?
      h← {  
        22:: ⎕SIGNAL helpFiÊ 
        ⍵: ⊢⎕THIS.helpHtml← ⊃⎕NGET HELP_HTML 
          ⎕THIS.helpHtml  
      } 0= ⎕NC 'helpHtml' 
  ⍝ Undocumented: [a] 'help' vs [b] ('help-n[arrow]' (vs 'help-w[ide]')
  ⍝ [a]: screen width 1250, including notes; [b] screen width 1000 w no notes 
      SCREEN_SIZES← (900 1000) (900 1350)
      s← SCREEN_SIZES⊃⍨ ~'-n'(1∘∊⍷)⍵
      o← ('HTML'  h) (s,⍨ ⊂'Size') (15 35,⍨ ⊂'Posn') ('Coord' 'ScaledPixel')    
      { 
        0::  ⍵⊣ 3500⌶ h                                   ⍝ Ride, if HTMLRenderer fails...
          ⍵⊣ 'htmlObj' ⎕THIS.⎕WC 'HTMLRenderer',⍥⊆ o      ⍝ HTMLRenderer
      } 1 0⍴⍬   
  }        
  
⍝:EndSection HELP 

⍝=== Begin LIBRARY Shortcut stubs =======================================================
⍝ See libUtil.LinkUserLib
⍝ library is the user library.
:Namespace library
    ⍝⍝⍝⍝⍝ Minimal contents, pending ⍙LoadLibAuto.
  ⍝ Inherit key sys vars from the # namespace.
    ⎕IO ⎕ML ⎕PW ⎕PP ⎕CT ⎕DCT ⎕FR← #.(⎕IO ⎕ML ⎕PW ⎕PP ⎕CT ⎕DCT ⎕FR)     
:EndNamespace

⍝ Utilities for "library" shortcut (£, `L) 
⍝ See ⍙LoadLibAuto 
:Namespace libUtil
⍝⍝⍝⍝⍝ This is a local stub, pending (optional, but expected) load of ∆Fapl_Library below.
  ∇ {libNs}←  LibUserSimple libNs 
    ⍝ external in the stub... 
    ⍝   libUser, Auto, ShowPath, LoadParms
    ⍝ external loaded from ∆Fapl_Library.dyalog:
    ⍝   libUser, Auto, parms, ShowPath, LoadParms 
      ⎕THIS.libUser← libNs
      libNs.⎕DF ⎕NULL 
      libNs.⎕DF '£=[',(⍕libNs),' ⋄ auto:0]'
      Auto← (⍕libNs)⍨  
      parms← ⎕NS ⍬ 
      ShowPath← '⍬'⍨        
      LoadParms← ⍬⍨       
  ∇
⍝ Set name and ref for library here
  LibUserSimple ##.library
:EndNamespace

⍝=== End LIBRARY Shortcut stubs =======================================================

⍝:Section Core FIX_TIME_ROUTINES 
⍝ ⍙Export∆F : rc← keepCm ∇ dest
⍝ Used internally only at FIX-time:
⍝ On execution (default mode), ⍙Export∆F creates ∆F in location specified as <dest>.
⍝  - Not in ns ⎕THIS, we "promote the fn to target namespace,
⍝    ∘ obscure (mangle) local vars: ¨result¨ ¨opts¨ and ¨args¨
⍝    ∘ sets __OUTER__. to ##.
⍝    ∘ sets __THIS__ to refer to this namespace (i.e. ...⍙Fapl)
⍝  - In ns ⎕THIS:
⍝    ∘ sets '__OUTER__.' to  ''
⍝  - All
⍝    ∘ removes comments and comment lines if noCm=1
  ∇ ok← keepCm ⍙Export∆F destNs ; keepCm; src; snk; Apply2; Cm ; CpyR; NoBL 
    s←   ('∆F_Src' '∆F')   ('__THIS__' ∆THIS)  
    s,← ⊂('__OUTER__\.' ('##.' ''⊃⍨ destNs=⎕THIS)) 
    s,←  ('result' 'rësültF')('opts' 'öptsF') ('args' 'ärgsF')
  ⍝ 
    Apply2← { src snk← ↓⍉↑⍺ ⋄ src ⎕R snk⍠ 'UCP' 1 ⊢ ⍵} 
    Cm←     {⍺: ⍵ ⋄ '''[^'']*''' '(^\s*)?⍝.*$' ⎕R '\0' ''⊢ ⍵ }    
    CpyR←   ,∘(⊂'⍝ (C) 2025 Sam the Cat Foundation.  Version: ',VERSION)
    NoBL←   {⍵/⍨ 0≠≢¨⍵}
    ok← 0≠1↑0⍴ destNs.⎕FX CpyR NoBL keepCm∘Cm s∘Apply2 ⎕NR '∆F_Src' 
    :If ok 
      (⎕∘←)⍣VERBOSE⊢ '>>> Created function ',(⍕destNs),'.∆F' 
    :Else 
      ⎕←'>>> LOGIC ERROR ON LOAD: There was an error applying ⍙Export∆F.' 
    :EndIf 
  ∇

⍝ ⍙LoadShortcuts:   ∇     (niladic) 
⍝ At ⎕FIX time, load the run-time library names and code for user Shortcuts
⍝ and similar code (Ð, display, is used internally, so not a true user shortcut).
⍝ The library entries created in ∆Fapl are: 
⍝  ∘  for shortcuts:    A, B, C, F, Q, T, W     ⍝ T supports `T, `D
⍝  ∘  used internally:  M, Ð.
⍝ A (etc): a dfn
⍝ scA (etc): [0] local absolute name of dfn (with spaces), [1] its code              
⍝ Abbrev  Descript.       Valence     User Shortcuts   Notes
⍝ A       [⍺]above ⍵      ambi       `A, %             Center ⍺ above ⍵. ⍺←''.  Std is %
⍝ B       box ⍵           ambi       `B                Put ⍵ in a box.
⍝ C       commas          monadic    `C                Add commas to numbers every 3 digits R-to-L
⍝ Ð       display ⍵       dyadic                       Var Ð only used internally...
⍝ F       [⍺]format ⍵     ambi       `F, $             ⎕FMT.   Std is $
⍝ J       [⍺] justify ⍵   ambi       `J                justify rows of ⍵. ⍺←'l'. ⍺∊'lcr' left/ctr/rght.
⍝ -       [⍺] library ⍵   niladic     £, `L            handled ad hoc.
⍝ M       merge[⍺] ⍵      ambi                         Var M only used internally...
⍝ Q       quote ⍵         ambi       `Q                Put only text in quotes. ⍺←''''
⍝ T       ⍺ date-time ⍵   dyadic     `T, `D            Format ⍵, ⎕TS date-time(s), acc. to ⍺.
⍝ W       [⍺1 ⍺2]wrap ⍵   ambi       `W                Wrap ⍵ in decorators, ⍺1 ⍺2.  ⍺←''''. See doc.
⍝
⍝ For A, B, C, D, F, J, M, Q, T, W; all like A example shown here:
⍝     A← an executable dfn in this namespace (⎕THIS).
⍝     scA2← name codeString, where
⍝          name is ∆THIS,'.A'
⍝          codeString is the executable dfn in string form.
⍝ At runtime, we'll generate shortcut code "pointers" scA, scB etc. based on flag ¨inline¨.
⍝ Warning: Be sure these can run in user env with any ⎕IO and ⎕ML.
⍝ (Localize them where needed)
⍝ NOTE: We are creating multiline objects using the old method for compatibility with Dyalog 19 etc.
  ∇ {ok}← ⍙LoadShortcuts 
    ; XR ;HT 
    XR← ⎕THIS.⍎⊃∘⌽                                   ⍝ XR: Execute the right-hand expression
    HT← '⎕THIS' ⎕R ∆THIS                             ⍝ HT: "Hardwire" absolute ⎕THIS. 
    ⎕SHADOW '; sc; scA2; scB2; scC2; scÐ2; scF2; scJ2; scM2; scS2; scQ2; scT2; scW2' ~';' 
    A← XR scA2← HT   ' ⎕THIS.A ' '{⎕ML←1⋄⍺←⍬⋄⊃⍪/(⌈2÷⍨w-m)⌽¨f↑⍤1⍨¨m←⌈/w←⊃∘⌽⍤⍴¨f←⎕FMT¨⍺⍵}' 
    B← XR scB2← HT   ' ⎕THIS.B ' '{⎕ML←1⋄⍺←0⋄⍺⎕SE.Dyalog.Utils.disp⊂⍣(1≥≡⍵),⍣(0=≡⍵)⊢⍵}' 
      ⎕SHADOW 'cCod' 
      cCod← { ⍝ ⎕THIS.C:  [⍺] ∇ ⍵
              ⍝ ⍺: [nseq@3 [sep@',']]  - inserts <sep> every <nseq> chars from right
              ⍝    nseq may be a number (>0) or a single digit char('0'..'9').
              ⍝    sep may be 0 or more characters. 
              ⍝        Backslashes are treated as text, not escapes, but "`⋄" is here a ⎕UCS 13.
              ⍝ ⍵: any combination of numbers (¯123244.4234) and numeric strings "¯2905224.444E¯5"
            _←  '{'
            _,←   'def←3'',''⋄⍺←def⋄ n s←⍺,def↑⍨0⌊2-⍨≢⍺⋄'
            _,←   'n←⍕n⋄s←{⍵≡⍥,''&'':''\&''⋄⍵/⍨1+''\''=⍵}s⋄' 
            _,←   '⎕IO ⎕ML←0 1⋄'
            _,←   'w←{1<⍴⍴⍵: ∇⍤1⊢⍵⋄'
            _,←      '1<|≡⍵: ∇¨⍵⋄3 5 7∊⍨80|⎕DR ⍵: ∇⍕¨⍵⋄'
            _,←      '''[.Ee].*$'' (''(?<=\d)(?=(\d{'',n,''})+([-¯.Ee]|$))'')⎕R''&'' ('''',s,''&'')⊢⍵'
            _,←   '}⍵⋄'
            _,←   '1=≢w: ⊃w ⋄ w'
            _,← '}'
            _   
      }⍬
    C← XR scC2← HT   ' ⎕THIS.C ' cCod 
    Ð← XR scÐ2← HT   ' ⎕THIS.Ð ' ' 0∘⎕SE.Dyalog.Utils.disp¯1∘↓'                           
    F← XR scF2←      ' ⎕FMT '    ' ⎕FMT ' 
      ⎕SHADOW 'jCod'
      jCod← { ⍝ Justify: Left "L", Center "C"), Right justify "R" (ignore case).
          _← '{'
          _,←   '⎕PP←34⋄⍺←''L''⋄B←{+/∧\'' ''=⍵}⋄'
          _,←   'w⌽⍨(1⎕C⍺){'
          _,←         '⍺∊''L''¯1:B ⍵⋄'
          _,←         '⍺∊''C'' 0:⌈0.5×⍵-⍥B⌽⍵⋄'
          _,←         '⍺∊''R'' 1:-B⌽⍵⋄'
          _,←         '⍳¯1'         ⍝ Signal a DOMAIN ERROR if we fall through
          _,←   '}w←⎕FMT⍵'
          _, '}' 
      } ⍬
    J← XR scJ2← HT   ' ⎕THIS.J '   jCod  
  ⍝ £, `L: Not here-- handled ad hoc...     
    M← XR scM2← HT   ' ⎕THIS.M '   '{⎕ML←1⋄⍺←⊢⋄⊃,/((⌈/≢¨)↑¨⊢)⎕FMT¨⍺⍵}'                     
      ⎕SHADOW 'qCod'
      qCod← {
          _←  '{'
          _,←  '⍺←⎕UCS 39⋄'            ⍝  (⎕UCS 39)≡qt    ⍝ ⍺ defaults to a single quote.
          _,←  '1<|≡⍵:⍺∘∇¨⍵⋄'                             ⍝ It's not simple ==> handle.
          _,←  '(0=⍴⍴⍵)∧1=≡⍵:⍵⋄'                          ⍝ It's an ⎕OR ==> handle.
          _,←  '(0≠≡⍵)∧326=⎕DR⍵:⍺∘∇¨⍵⋄'                   ⍝ It's heterogeneous: 1 'x' 2 3.  
          _,←  '⎕ML←1⋄'                                   ⍝ Safe after |≡                                             
          _,←  '⍺{0=80|⎕DR⍵:⍺,⍺,⍨⍵/⍨ 1+⍺=⍵⋄⍵}⍤1⊢⍵'        ⍝ If a vector/row is char, put in quotes.
          _,  '}'
      }⍬
    Q← XR scQ2← HT   ' ⎕THIS.Q ' qCod 
    ⍝ S: If S sees a DOMAIN (11) or NONCE ERROR (16), Serialise is probably balking at seeing 
    ⍝    a function, operator, or other unserialisable object (e.g. in a namespace)
    ⍝ NB: Array.Serialise returns an enclosed char vec. if ⍺=1; we disclose it.
    ⎕SHADOW 'sCod'
    sCod←  '{'
    sCod,←   '⎕ML←1⋄11 16 6::⍵⋄⍺←0⋄'     ⍝ 6 is a bug in Array.Serialise (∆XR).
    sCod,←   '1=≢s←⍺⎕SE.Dyalog.Array.Serialise⍵:⊃s⋄'
    sCod,←   '⍪s'
    sCod,← '}'
    S← XR scS2← HT   ' ⎕THIS.S '  sCod 
    T← XR scT2← HT   ' ⎕THIS.T ' '{⎕ML←1⋄⍺←''%ISO%''⋄∊⍣(1=≡⍵)⊢⍺(1200⌶)⊢1⎕DT⊆⍵}'  
    W← XR scW2← HT   ' ⎕THIS.W ' '{⎕ML←1⋄⍺←⎕UCS 39⋄ 1<|≡⍵: ⍺∘∇¨⍵⋄L R←2⍴⍺⋄{L,R,⍨⍕⍵}⍤1⊢⍵}'
  ⍝ Load shortcuts: [internal+external] scList; [external only] nSC, MapSC.
  ⍝ £, `L (niladic) are handled ad hoc.  
    scList← 0 1⊃¨¨ ⊂scA2 scB2 scC2 scÐ2 scF2 scJ2 scM2 scS2 scT2 scQ2 scW2 
    nSC← ≢sc← 'ABCFJSTDQW'                   ⍝ sc: User-callable shortcuts  (`A, etc.)
    MapSC←  sc∘⍳ 
    ok← 1 
  ∇
  ∇ {ok}← ⍙LoadHelp hfi;e1; e2 
  ⍝ Loading the help html file...
    :Trap 22 
        ⎕THIS.helpHtml← ⊃⎕NGET hfi
        :IF VERBOSE ⋄ ⎕← '>>> Loaded Help Html File "',hfi,'"' ⋄ :EndIf  
        ok← 1 
    :Else 
        e1← '>>> WARNING: When loading ∆Fapl, the help file "',hfi,'" was not found in current directory.'
        e2← '>>> WARNING: ∆F help will not be available without user intervention.'
        e1,(⎕UCS 13),e2
        ok← 0 
    :EndTrap 
  ∇
  ∇ {load}← ⍙LoadLibAuto ( fi load )
    ; _ 
    _← ' from "',fi,'" into "','"',⍨∆THIS 
    :If ~load 
        ⎕←'>>> NOTE: Based on settings, Library autoload services were not loaded',_
        ⎕←'>>> NOTE: £ and `L shortcuts are available without them (auto: 0).'
        :Return 
    :EndIf 
    :TRAP 22 
        ⎕FIX 'file://',fi
        :If VERBOSE 
            ⎕←'>>> Loaded services for Library shortcut (£)',_  
        :EndIf 
    :Else
        load← 0 
        ⎕← ⎕PW⍴'='
        ⎕←'>>> WARNING: Unable to load Library autoload services',_
        ⎕←'>>> NOTE:    £ and `L shortcuts are available without them (auto: 0).'
        ⎕← ⎕PW⍴'='
    :EndTrap
  ∇
  ∇ {ok}← ⍙ShareNotesIfVerbose  ; _ 
  :If VERBOSE 
      _← '>>> ∆F Application-wide Globals: '
      ⎕← _, '(', ')',⍨ ∊'TRAP_ERRORS:' TRAP_ERRORS '⋄ VERBOSE:' VERBOSE '⋄ LIB_AUTO:' LIB_AUTO
  :EndIf 
  ok← 1 
  ∇ 

⍝ Execute FIX-time routines
    0 ⍙Export∆F¨ ##   
    ⍙LoadShortcuts
    ⍙LoadHelp HELP_HTML
    LIB_AUTO← ⍙LoadLibAuto LIB_SOURCE LIB_AUTO
    ⍙ShareNotesIfVerbose 

⍝ === END OF CODE ================================================================================
⍝ === END OF CODE ================================================================================
:EndNamespace 
⍝ (C) 2025 Sam the Cat Foundation

⍝:EndSection Core FIX_TIME_ROUTINES 
