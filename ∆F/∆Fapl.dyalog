⍝ ∆Fapl.dyalog $UPDATE_TIME = "2025-11-14T20:21:14" 
⍝:Section CORE 

:Namespace ⍙Fapl   
  ⎕IO ⎕ML ⎕PP←0 1 34            ⍝ Namespace scope. User code is executed in caller space (⊃⎕RSI) 

⍝ GENERAL GLOBAL VARIABLES 
  DEBUG← 0                      ⍝ DEBUG: If 1, turns off error trapping in ∆F
  VERBOSE← 0                    ⍝ VERBOSE: Compile-time and run-time verbosity flag
⍝ VARIABLES FOR ∆F OPTIONS: Positional and keyword 
  OPTS_KW←   'dfn' 'verbose' 'box' 'auto' 'inline'        ⍝ In order 
  OPTS_DEF←  0 0 0 1 0     
  OPTS_N←    ≢OPTS_DEF 
⍝ SESSION LIBRARY (£ or `L) VARIABLES
⍝ LIB_LOAD:  1   We want to use the SESSION LIBRARY autoload.
⍝            0   We don't want to use SESSION LIBRARY autoload.
  LIB_LOAD←  1     
  LIB_SOURCE←  '∆F/∆Fapl_Library.dyalog'  ⍝ Library shortcuts (£,  `L) utilities.
⍝ HELP-related globals             
  HELP_HTML←   '∆F/∆F_Help.html'          ⍝ Called from 'help' option. Globally set here

⍝ ============================   ∆F (User Function)   ==============================
⍝ === Copied into ## as ∆F ===
⍝ ∆F: 
⍝    result← {opts←⍬} ∇ f-string [args]
⍝ This function must be independent of ⎕IO, ⎕ML, etc., since it will be promoted out of ⍙Fapl.
⍝ ¨⎕THIS¨ will be hardwired as ∆F is promoted out of ⍙Fapl.
⍝ This has to be a tradfn, since it may return a dfn (with 1=⊃opts)
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
⍝   On execution (default mode), "hides" local vars, ¨opts¨ and ¨args¨, from embedded ⎕NL, etc.
⍝   This avoids them showing on ⎕NL or related calls.
⍝ BEGIN ====================   ∆F (User Function)   ==============================
  ∇ result← {opts} ∆F args                             ⍝ For doc, see ∆F in ∆Fapl.dyalog.
    :Trap 0/⍨ ~⎕THIS.DEBUG  
    ⍝ Get options-- pos'l (fast), keyword (legacy is slow), help (who cares)              
      :If 900⌶0                                        ⍝ default options   
          opts← ⎕THIS.OPTS_DEF 
      :ElseIf 11 83∊⍨ ⎕DR opts                         ⍝ positional (bool or small int)
          opts,←  ⎕THIS.OPTS_DEF↑⍨ 0⌊⎕THIS.OPTS_N-⍨ ≢opts  ⍝ Append any omitted opts.
      :ElseIf 9=⎕NC 'opts'                             ⍝ Keywords via APL Array Notation
          opts← ⎕THIS.GetKWOpts opts                   ⍝    Cvt keyword opts => pos'l opts
      :ElseIf 0= 80|⎕DR opts ⋄ :AndIf '('=⊃opts        ⍝ Legacy (<Dyal 20) keywords via APLAN string
          opts← ⎕THIS.GetKWOptsLegacy opts             ⍝    Cvt keyword opts => pos'l opts
      :Else                                          
          result← ⎕THIS.Special opts ⋄ :Return            ⍝ 'help' or error! 
      :EndIf                                           ⍝ default: positional parameters
      args← ,⊆args
    ⍝ Determine output mode and execute
      :Select ⊃opts    
      :Case  0       ⍝ Execute fstring
          result← opts ((⊃⎕RSI){ ⍺⍺⍎ ⍺ ⎕THIS.FmtScan ,⊃⍵⊣ ⎕EX 'opts' 'args'}) args    
      :Case  1       ⍝ Return dfn incorporating fstring   
          ⎕EX '∆Fdfn'⊣ ⎕SHADOW '∆Fdfn'               ⍝ Give returned dfn a mnemonic name...                                          
          result← ∆Fdfn← (⊃⎕RSI)⍎ opts ⎕THIS.FmtScan ,⊃args
      :Case ¯1       ⍝ Return dfn source code incorporating fstring                               
          result← opts ⎕THIS.FmtScan ,⊃args            
      :Else          ⍝ Special or an error         
          result← ⎕THIS.Special opts  
      :EndSelect   
    :Else 
      ⎕SIGNAL ⊂⎕DMX.('EM' 'EN' 'Message' ,⍥⊂¨('∆F ',EM) EN Message) 
    :EndTrap 
   ⍝ (C) 2025 Sam the Cat Foundation
  ∇
⍝ END ====================   ∆F (User Function)   ==============================


⍝ Minor Utilities for ∆F above
⍝ GetKWOpts: Keyword options (Dyalog 20)
⍝    ∇ ns
⍝    ns: A ns, typically generated from APL Array Notation using (kw: val ...) 
  GetKWOpts← {   
      kw← () ⎕NS ⍵ 
      kw ⎕VGET (↑OPTS_KW) OPTS_DEF 
  }

⍝ GetKWOptsLegacy: Keyword options (pre-Dyalog 20).
⍝    ∇ str@CV
⍝    str: An APL Array Notation-format string
  GetKWOptsLegacy← { 
      0::   'Invalid user option format' ⎕SIGNAL ⎕EN 
        ∆NS← { ⍺⊣ ⍵ ⍺.{ ⍎⍵,'←⍺⍺.',⍵ ⋄ ⍺⍺ }¨⍵.⎕NL¯2 }
        ∆VG← { (↓⊃⍵)⍺.{ 0=⎕NC ⍺: ⍎ ⍺,'←⍵' ⋄ ⎕OR ⍺ }¨⊃⌽⍵ }
      kw← (⎕NS⍬) ∆NS AN2Apl ⍵ 
      kw ∆VG (↑OPTS_KW) OPTS_DEF    
  }
⍝ KWAlias:    ns@Ns ∇ (sink1@CV src1@CV)(sink2@CV src2@CV)...
⍝     If src exists, but sink doesn't, replace sink's value with src's value.
  KWAlias← { ⍺.{ >/⍵ ⍺∊ ⎕NL¯2: ⊢⍎⍺,'←',⍵ ⋄ ⍬}/¨⍵ }
 

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
    ⍝ Returns: null. Appends APL code strings to fldsG
    TF← {  
        p← TFBrk ⍵                                     ⍝ esc, lb, or nl only. 
      p= ≢⍵: TFDone ⍺, ⍵                               ⍝ No special chars in ⍵. Process & return.
        pfx c w← (p↑⍵) (p⌷⍵) (⍵↓⍨ p+1) 
      c= esc: (⍺, pfx, nlG TFEsc w) ∇ 1↓ w             ⍝ char is esc. Process & continue.
      ⍝ SKIP: c= nl:  (⍺, pfx, nlG) ∇ w                ⍝ actual nl (⎕UCS 13) => nlG, mirroring esc+⋄ => nlG. 
        CF_SF w⊣ TFDone ⍺, pfx                         ⍝ char is lb. End TF; go to CF_SF.  
    } ⍝ End Text Field Scan 

  ⍝ TFDone: If a text field is not 0-length, place in quotes and add it to fldsG.
  ⍝ Ensure adjacent fields are sep by ≥1 blank.
    TFDone← {0≠ ≢⍵: 0⊣ fldsG,← ⊂sp_sq, sq,⍨ ⍵/⍨ 1+ sq= ⍵ ⋄ ⍬}    

  ⍝ CF_SF: Code and Space Field Scan (monadic only).
  ⍝     res← ∇ str, where str starts just past the leading '{' of the CF.  
  ⍝ Called by TF. 
  ⍝ If it sees /^\s*\}/, it emits SF code (if no spaces) and recurses "back" to TF.
  ⍝ Otherwise, it processes a code field. 
  ⍝ Returns: null. Appends APL code strings to fldsG. Sets/modifies nBracG, cfLenG.
    CF_SF← {                                              
        cfV← w← ⍵                                      ⍝ cfV: Save the CF verbatim. Used in ⍙Scan.
      rb= ⊃w: '' TF 1↓ w                               ⍝ Null SF? No code gen'd. => Done. [FAST]
        w↓⍨← nSp← +/∧\' '= w                           ⍝ Count/skip over (≥0) leading spaces...
      rb= ⊃w: '' TF 1↓ w⊣ fldsG,← ⊂SFCode nSp          ⍝ SF? => Done.
        nBracG cfLenG⊢← 1 nSp                          ⍝ CF => Scan Code Field
        ⍙Scan← {                                       ⍝ Reads cfV above. Modifies cfLenG, nBracG.  
            cfLenG+← 1+ p← CFBrk ⍵
          p= ≢⍵:  ⎕SIGNAL brÊ                          ⍝ Missing "}" => Error. 
            pfx c w← (⍺, p↑⍵) (p⌷⍵) (⍵↓⍨ p+1)          ⍝ Some cases below (marked [１]) are ordered! 
          c= sp:     (pfx, sp) ∇ w↓⍨ cfLenG+← p← +/∧\' '=w ⍝ Handle runs of blanks
         (c= rb)∧ nBracG≤ 1: (TrimR pfx) w             ⍝ [１] Closing "}" => Return... Scan complete! 
          c∊ lb_rb:  (pfx, c) ∇ w⊣ nBracG+← -/c= lb_rb ⍝ [１] Inc/dec nBracG as appropriate
          c∊ qtsL:   (pfx, a)  ∇ w⊣  cfLenG+← c⊣ a w c← CFStr c w  ⍝ Opening quote => CFStr  
          c= dol:    (pfx, scF) ∇ w                    ⍝ $ => ⎕FMT (scF shortcut)
          c= esc:    (pfx, a)  ∇ w⊣ a w← CFEsc w       ⍝ `⍵, `⋄, `A, `B, etc.
          c= omUs:   (pfx, a)  ∇ w⊣ a w← CFOm w        ⍝ ⍹, alias to `⍵ (see CFEsc).
          c= pnd:    (pfx, libUtil.Auto w vG aG) ∇ w             ⍝ £ => our private library
         ~c∊ sdcfCh: ⎕SIGNAL cfLogicÊ 
          p← +/∧\' '=w  
        ⍝ SDCF Detection...       
        ⍝ c is one of '→', '↓', or '%'. 
        ⍝ See if [A] we have a shortcut/APL fn or [B] an indicator of a self-doc code field (SDCF).
        ⍝ [A] We have a Shortcut or APL Fn <<<<<       
        ⍝ Shortcut "above" '%' or APL fns '→'¹ or '↓'. 
        ⍝ [¹] Only a bare → is valid in a dfn stmt, so good luck. 
          (rb≠ ⊃p↓w)∨ nBracG> 1: (pfx, c scA⊃⍨ c= pct) ∇ w  ⍝ Continue CF Scan
        ⍝ [B]: We have a Self-Documenting Code Field (SDCF)  
        ⍝ SDCF: We have matched: /[→↓%]\s*\}/  
        ⍝ '→' places the code str to the left of the result (scM=merge) after evaluating the code str; 
        ⍝ '↓' or its alias '%' puts it above (scA) the result.
            codeStr← AplQt cfV↑⍨ cfLenG+ p              
            (codeStr, (scA scM⊃⍨ c='→'), pfx)(w↓⍨ p+1) ⍝ => Return: Scan complete!  
        }
        a w← '' ⍙Scan w
        '' TF w⊣ fldsG,← ⊂'(', lb, a, rb, '⍵)'         ⍝ Process field & then head to TF
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
        CFSBrk← ⌊/⍳∘(esc qtR)   ⍝ SKIP: nl)            ⍝ See note at <c= nl> below.
        lenW← ¯1+ ≢w                                   ⍝ lenW: length of w outside quoted str.
        ⍙Scan← {   ⍝ Recursive CF Quoted-String Scan. lenW converges on true length.
          0= ≢⍵: ⍺ 
            p← CFSBrk ⍵  
          p= ≢⍵: ⎕SIGNAL qtÊ 
            c c2← 2↑ p↓ ⍵ 
        ⍝ See QSEsc for handling of esc+qtR as esc char plus closing quote (see below)
          c= esc: (⍺, (p↑ ⍵), map) ∇ ⍵↓⍨ lenW-← p+ skip ⊣ map skip← nlG QSEsc c2 qtR 
          ⍝ SKIP: OPTIONAL: actual nl  => nlG, mirroring esc+⋄ => nlG. 
          ⍝ SKIP: c= nl:  (⍺, nlG) ∇ ⍵↓~ lenW-← 1              
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
  ⍝ Returns:  code w                                    ⍝ ** Side Effects: Sets cfLenG, omIxG **
    CFEsc← {                                    
      0= ≢⍵: esc 
        c w← (0⌷⍵) (1↓⍵) ⋄ cfLenG+← 1   
      c∊ om_omUs: CFOm w                               ⍝ Permissively allow `⍹ as equiv to  `⍵ OR ⍹ 
      c='L': (libUtil.Auto w vG aG) w    
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
  ⍝   Modifies cfLenG, omIxG to reflect the # of digits matched and their value.  
    CFOm← { oLen oVal w← IntOpt ⍵
      ×oLen: ('(⍵⊃⍨',')',⍨ '⎕IO+', ⍕omIxG⊢← oVal) w⊣ cfLenG+← oLen 
             ('(⍵⊃⍨',')',⍨ '⎕IO+', ⍕omIxG       ) w⊣ omIxG+← 1
    }
⍝ ===========================================================================
⍝ FmtScan Executive begins here
⍝ ===========================================================================  
    (dfn vG box aG inline) fStr← ⍺ ⍵    
  ⍝ Validate options  (vG and aG are "globals") 
    0∊ 0 1∊⍨ (|dfn),vG box aG inline: ⎕SIGNAL optÊ                   
    DMsg← (⎕∘←)⍣(vG∧¯1≠dfn)                           ⍝ Debug message
    nlG← vG⊃ nl nlVis                                 ⍝ A newline escape (`⋄) maps onto nlVis if debug mode.
  ⍝ User Shortcuts: A, B, C, F, T~D, Q, W.  
  ⍝ Non-user Internal Shortcut Code and dfns: scÐ, Ð;  scM, M.
  ⍝ See ⍙LoadShortcuts for shortcut details and associated variables scA, scB, etc.     
    scA scB scC scÐ scF scJ scM scT scQ scW← inline⊃ scList  
  ⍝  userSCs must be ordered acc. to sc (sc← 'ABCFJLTDQW'). 
  ⍝ See function MapSC and its use.  For £, `L, see namespace libUtil.
  ⍝          `A  `B  `C  `F  `J  `T  `D  `Q  `W 
    userSCs← scA scB scC scF scJ scT scT scQ scW            
 
  ⍝ Pseudo-globals  camelCaseG 
  ⍝    vG-  runtime debug flag. Set above.
  ⍝    aG-     runtime: 
  ⍝                 If 0, disables library autoload mode, overriding the default and .∆F setting.
  ⍝                 If 1, honors default/.∆F setting of parms.auto∊ 0 1.
  ⍝    fldsG-     global field list
  ⍝    omIxG-     omega index counter: current index for omega shortcuts (`⍵, ⍹)  
  ⍝    nBracG-    running count of braces '{' lb, '}' rb
  ⍝    cfLenG-    code field running length (used when a self-doc code field (q.v.) occurs)
    fldsG← ⍬                                           ⍝ zilde
    omIxG← nBracG← cfLenG← 0                           ⍝ zero
  
  ⍝ Start the scan                                     ⍝ We start with a (possibly null) text field, 
    _← '' TF ⍵                                         ⍝ recursively calling CF_SF and (from CF_SF) SF & TF itself, &
                                                       ⍝ ... setting fields ¨fldsG¨ as we go.
  0= ≢fldsG: DMsg '(1 0⍴⍬)', '⍨'/⍨ dfn≠0                 ⍝ If there are no flds, return 1 by 0 matrix
    fldsG← OrderFlds fldsG                             ⍝ We will evaluate fields L-to-R
    code← '⍵',⍨ lb, rb,⍨ fldsG,⍨ box⊃ scM scÐ
  0=dfn: DMsg code                                       ⍝ Not dfn. Emit code ready to execute
    quoted← ',⍨⊂', AplQt fStr                          ⍝ Is dfn (1,¯1): add quoted fmt string (`⍵0)
    DMsg lb, code, quoted, rb                            ⍝ Emit dfn str ready to cvt to dfn in caller
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
  om← '⍵'                                          ⍝ ⍵ not in cfBrklist, since not special. (See `⍵).
  nl nlVis← ⎕UCS 13 9252                           ⍝ 9252 (␤), 9229 (␍)               
⍝ Seq. `⋄ OR `◇ map onto ⎕UCS 13.
⍝ dia2[0]: Dyalog stmt separator 
⍝ dia2[1]: Alternative character that is easier to read in some web browsers. 
  dia2← ⎕UCS 8900 9671                                 ⍝  ⋄ ◇
⍝ lDAQ, rDAQ: LEFT- and RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK, aka guillemets  
  lDAQ rDAQ← '«»'                                      ⍝ ⎕UCS 171 187 
⍝ Order brklist chars roughly by frequency, high to low.       
  cfBrkList← lDAQ,⍨ sp sq dq esc lb rb dol omUs ra da pct pnd← ' ''"`{}$⍹→↓%£' 
  tfBrkList← esc lb   ⍝ SKIP: nl                 
  lb_rb← lb rb ⋄ om_omUs← om omUs ⋄ sp_sq← sp sq ⋄   esc_lb_rb← esc lb rb  
  qtsL qtsR← lDAQ rDAQ,⍨¨ ⊂dq sq                       ⍝ Expected freq hi to lo: dq sq l/rDAQ
  sdcfCh← ra da pct                                    ⍝ self-doc code field chars

⍝ Error constants and fns  
    Ê← { ⍺←11 ⋄ ⊂'EN' ⍺,⍥⊂ 'Message' ⍵ }
  brÊ←         Ê 'Unpaired brace "{"'
  qtÊ←         Ê 'Unpaired quote in code field' 
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

⍝ Apl2AN, AN2Apl:  Deserialise/Serialise APL Array Notation. 
⍝ Apl2AN: Returns CVV.  ⍺=0: each line a separate CV; ⍺=1: using stmt sep ⋄.
  AN2Apl←  ⎕SE.Dyalog.Array.Deserialise
  Apl2AN←  ⎕SE.Dyalog.Array.Serialise

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
⍝ ∘ User flds are effectively executed L-to-R AND displayed in L-to-R order 
⍝   by ensuring there are at least two fields (one null, as needed), 
⍝   reversing their order now (at evaluation time), evaluating each field 
⍝   via APL ⍎ in turn R-to-L, then reversing again at execution time. 
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
⍝ 2. If helpHtml is not defined or if DEBUG=1, HELP_HTML will be read and copied into helpHtml. 
⍝ 3. Displays helpHtml.
  Special← { h← ⎕C⍵
  ⍝ parms: Load any new parms without a ]load. 
  ⍝        Returns display of default and user parms (as mx) in alph order.
    'parms'≡   h: _← libUtil.LoadParms 1 1 1 
    'path' ≡   h: _← libUtil.ShowPath ⍬ 
    'help' ≢ 4↑h: ⎕SIGNAL optÊ 
  ⍝ help, help-wide, or help-narrow?
    h← {  
      22:: ⎕SIGNAL helpFiÊ 
      DEBUG∨ ⍵: ⊢⎕THIS.helpHtml← ⊃⎕NGET HELP_HTML 
        ⎕THIS.helpHtml  
    } 0= ⎕NC 'helpHtml' 
  ⍝ Undocumented: [a] 'help' vs [b] ('help-n[arrow]' (vs 'help-w[ide]')
  ⍝ [a]: screen width 1250, including notes; [b] screen width 1000 w no notes 
    s← 900, 1250 1000⊃⍨ '-n'(1∘∊⍷)⍵
    o← ('HTML'  h) (s,⍨ ⊂'Size') (5 100,⍨ ⊂'Posn') ('Coord' 'ScaledPixel')
    _← 'htmlObj' ⎕THIS.⎕WC 'HTMLRenderer',⍥⊆ o          ⍝ Run HTMLRenderer
    1 0⍴⍬
  } 
⍝:EndSection HELP 

⍝=== Begin LIBRARY Shortcut stubs =======================================================
⍝ See libUtil.LinkUserLib
⍝ ûserLib is the user library.
:Namespace ûserLib
    ⍝⍝⍝⍝⍝ Stub. See ⍙LoadLibAuto
:EndNamespace

⍝ Utilities for "library" shortcut (£, `L) 
⍝ See ⍙LoadLibAuto 
:Namespace libUtil
⍝⍝⍝⍝⍝ This is a stub, pending (optional, but expected) load of ∆Fapl_Library below.
  ∇ {ns}← BareBones
    ns← uLibNm← ⍕##.ûserLib ⋄ Auto← uLibNm⍨  
    parms← ⎕NS ⍬ 
    ShowPath← '⍬'⍨        
    LoadParms← ⍬⍨           
  ∇
  BareBones 
:EndNamespace 
⍝=== End LIBRARY Shortcut stubs =======================================================

⍝:Section Core FIX_TIME_ROUTINES 
⍝ ⍙Promote_∆F: rc← ∇ dest     
⍝ Used internally only at FIX-time:
⍝ ∘ Fix (⎕FX) ∆F into dest, obscuring its local names and hardwiring the location of ⎕THIS. 
  ∇ rc← ⍙Promote_∆F dest ; src; snk  
    src←    '⎕THIS.OPTS_N'     '⎕THIS.OPTS_DEF'   
    snk←   (⍕⎕THIS.OPTS_N)   (⍕⎕THIS.OPTS_DEF)    
    src,←   '⎕THIS'   'result'     'opts'     'args' 
    snk,←   (⍕⎕THIS)  '__∆Frësült' '__∆Föpts' '__∆Färgs' 
    rc← dest.⎕FX src ⎕R snk ⍠ 'UCP' 1⊣ ⎕NR '∆F'
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
⍝          name is (⍕⎕THIS),'.A'
⍝          codeString is the executable dfn in string form.
⍝ At runtime, we'll generate shortcut code "pointers" scA, scB etc. based on flag ¨inline¨.
⍝ Warning: Be sure these can run in user env with any ⎕IO and ⎕ML.
⍝ (Localize them where needed)
  ∇ {ok}← ⍙LoadShortcuts 
    ; XR ;HT 
    XR← ⎕THIS.⍎⊃∘⌽                                   ⍝ XR: Execute the right-hand expression
    HT← '⎕THIS' ⎕R (⍕⎕THIS)                          ⍝ HT: "Hardwire" absolute ⎕THIS. 
    ⎕SHADOW '; sc; scA2; scB2; scC2; scÐ2; scF2; scJ2; scM2; scQ2; scT2; scW2' ~';' 
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
          _,← ' ⍺←⎕UCS 39⋄'                               ⍝ ⍺ defaults to a single quote.
          _,← ' 1<|≡⍵:⍺∘∇¨⍵⋄'                             ⍝ It's not simple ==> handle.
          _,← ' (0=⍴⍴⍵)∧1=≡⍵:⍵⋄'                          ⍝ It's an ⎕OR ==> handle.
          _,← ' (0≠≡⍵)∧326=⎕DR⍵:⍺∘∇¨⍵⋄'                   ⍝ It's heterogeneous: 1 'x' 2 3.  
          _,← ' ⎕ML←1⋄'                                   ⍝ Safe after |≡                                             
          _,← ' ⍺{0=80|⎕DR⍵:⍺,⍺,⍨⍵/⍨ 1+⍺=⍵⋄⍵}⍤1⊢⍵'        ⍝ If a vector/row is char, put in quotes.
          _,  '}'
      }⍬
    Q← XR scQ2← HT   ' ⎕THIS.Q ' qCod 
    T← XR scT2← HT   ' ⎕THIS.T ' '{⎕ML←1⋄⍺←''%ISO%''⋄∊⍣(1=≡⍵)⊢⍺(1200⌶)⊢1⎕DT⊆⍵}'  
    W← XR scW2← HT   ' ⎕THIS.W ' '{⎕ML←1⋄⍺←⎕UCS 39⋄ 1<|≡⍵: ⍺∘∇¨⍵⋄L R←2⍴⍺⋄{L,R,⍨⍕⍵}⍤1⊢⍵}'
  ⍝ Load shortcuts: [internal+external] scList; [external only] nSC, MapSC.
  ⍝ £, `L (niladic) are handled ad hoc.  
    scList← 0 1⊃¨¨ ⊂scA2 scB2 scC2 scÐ2 scF2 scJ2 scM2 scT2 scQ2 scW2 
    nSC← ≢ sc← 'ABCFJTDQW'                   ⍝ sc: User-callable shortcuts  (`A, etc.)
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
  ∇ {ok}← ⍙LoadLibAuto fi 
    :TRAP 22 
        ⎕FIX 'file://',fi
        :If VERBOSE 
            ⎕←'>>> Loaded services for Library shortcut from "',fi,'" into "','"',⍨⍕⎕THIS  
        :EndIf 
        ok← 1 
    :Else
        ok←0 ⋄  LIB_LOAD← 0 
        ⎕← ⎕PW⍴'='
        ⎕←'>>> WARNING: Unable to load services for Library shortcut from "',fi,'" into "','"',⍨⍕⎕THIS 
        ⎕←'>>> NOTE:    £ and `L shortcuts are available without these services (auto: 0).'
        ⎕← ⎕PW⍴'='
    :EndTrap
  ∇
  ∇ {ok}← ⍙NoteGlobals 
  :If VERBOSE 
      ⎕←'>>> ∆F Application-wide Globals: ( DEBUG:',DEBUG,'⋄ VERBOSE:',VERBOSE, '⋄ LIB_LOAD:',LIB_LOAD,')' 
  :EndIf 
  ok← 1 
  ∇ 

⍝ Execute FIX-time routines
  ⍙Promote_∆F ##  
  ⍙LoadShortcuts
  ⍙LoadHelp HELP_HTML
  ⍙LoadLibAuto LIB_SOURCE
  ⍙NoteGlobals 

 
⍝ === END OF CODE ================================================================================
⍝ === END OF CODE ================================================================================
:EndNamespace 
⍝ (C) 2025 Sam the Cat Foundation

⍝:EndSection Core FIX_TIME_ROUTINES 
