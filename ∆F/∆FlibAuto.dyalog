:Namespace libUtil 
⍝ libUtil (namespace): Handles £ and `L shortcuts. 
⍝ This has options that can be tailored via a file .∆F in the current directory.
⍝ ∘ The "default" location for user routines is:
⍝     dfns workspace, then MyDyalogLib in the current directory.
⍝   This can be changed to an arbitrary list, along with the file types searched for.
⍝   See SetParmDefaults below.
⍝ ∘ The "user" namespace referenced by £ and `L equivalently is
⍝   ûLib, which is established at ]Load time.
⍝
⍝ Auto:
⍝ The main workhorse is Auto, the only function called from the main scan 
⍝ routines CF_SF and CF_Esc. 

⍝ Auto: Runtime routine:  Auto with helper function ⍙Auto
⍝   Our task is to find nm in £.nm...[←] and find src code for it.
⍝   Does NOT affect the string being scanned. Only used for its ⎕CY or ⎕FIX side effect.
⍝ Auto: u@nsNm←  dbg@B ∇ s@CV, 
⍝  s starts 1 char after £ or `L. 
⍝  See steps below. 
⍝ Returns: ulNm (@CV), no matter what.  
  ∇ u← dbg Auto s
    u← ulNm                                            ⍝ Return ulNm no matter what!
    :If 0=≢ s                                          ⍝ Empty str? Done
    :OrIf '.'≠⊃s← NoLB s                               ⍝ No dot after £? Done
    :OrIf ~⍙A∊⍨ ⊃s← 1↓s                                ⍝ Word after dot not APL name? Done
    :OrIf 0≠ulNs.⎕NC nm← s↑⍨ t← +/∧\s∊ ⍙AD             ⍝ Not a valid APL name? Done
    :OrIf '←'= ⊃NoLB t↓s                               ⍝ Is simple assignment? Done
    :Else 
        ulNs dbg parms ⍙LoadObj nm                    ⍝ Else, try to find and load the obj. named.
    :EndIf 
  ∇ 

  ⍝ ⍙LoadObj: 
  ⍝     (1|0)@B← ulŃ@ulNs dbg@B parms@ns ∇ nm@CVS 
  ⍝ Find <nm> in search directories (parms.path) and dfns workspace, according to parameters <parms>.
  ⍝ If parms.dfnsOrder is 'first', try the dfns w/s first. If 'last', try last. If 'skip', skip.
  ⍝ Called by ⍙Auto (above).
  ⍝    (1|0)← ulNs dbg parms ∇ nm 
  ⍝ Returns SHY 1 (succ) or SHY 0 (fail), having established <nm> in ulNs (ulNs) on success.
  ⍙LoadObj← { 
      ulNs dbg parms←⍺ ⋄ nm← ⍵ 
    ⍝ ∆WS: Search for name ⍺ in ws ⍵. On success, 1 nm; on failure, 0 nm
      ∆WS← { 11:: 0 ⍬ ⋄ 1 ('ws:',⍵)⊣ ⍺ ulNs.⎕CY ⍵ }

    ⍝ ∆FI:  Search for full names ⍵, where simple name is ⍺
    ⍝       If it doesn't find a file ending (before suffixes) with name ⍵, failure.
    ⍝       If it finds a file with name ⍵ and the ⎕FIX succeeds, success.
    ⍝       Otherwise, failure.
    ⍝ Returns: On success, (1 where_found); on failure, 0 ⍬.
      ∆FI← { 0=≢ ⍵: 0 ⍬ ⋄ fi←⊃⍵ ⋄ 22 11:: 0 ⍬
        ~⎕NEXISTS fi: ⍺ ∇ 1↓⍵ ⋄ (⊂⍺)∊ 2∘ulNs.⎕FIX ⊃⍵: 1 ('file:',fi) ⋄ 0 ⍬ 
      }

    ⍝ ∆Scan for name ⍵ in each file/wsid spec of parms._fullPath 
    ⍝     ok@B where@S← nm@S ∇ path@NsV 
    ⍝ If we see an array, it's a workspace. Call ∆WS nm  (⊃spec)
    ⍝ Otherwise, call ∆FI nm spec sfx 
      ∆Scan← { 0= ≢ ⍵: 0 ⍬ ⋄ nm path← ⍺ ⍵ ⋄ cur← ⊃path
        1< |≡cur: ∇ { ⊃ret← nm ∆WS ⍵: ret ⋄ nm ⍺⍺ 1↓path} ⊃cur  ⍝ a workspace
          ff← ,(⊂cur)∘.,(⊂nm,'.')∘.,parms.suffix             
        ⊃ret← nm ∆FI ff: ret ⋄ nm ∇ 1↓path                       ⍝ a file
      }

    ⍝ An optional message. Returns the return code ⍺
      Msg← ulNs { 
        ~⍵⍵: ⍺ ⋄ (nm where)← ⍵ ⋄ msg← ⍺⊃ 'Could not copy ' 'Copied '
        ⍺ ⊣ ⎕← 'DEBUG INFO: ',msg, '"', nm, '" into', ⍺⍺, (0≠≢ where)/ 'from ','"',where,'"' 
      } (parms.verbose∨ dbg)

    ⍝ Executive for ⍙LoadObj 
      ok where← nm ∆Scan parms._fullPath 
     1: _← ok Msg nm where  

  }
  
  ⍝ Internal util. and constants for Auto 
  ⍝ NoLB: Non-leading blanks; ⍙A: valid initials of APL nms; ⍙AD: valid chars of APL nms. 
    NoLB← { ⍵↓⍨ +/∧\' '=⍵}
    ⍙A← { ⍺←'' ⋄ 0=≢⍵: ⍺~'⍺⍵∇' ⋄ ¯1=⎕NC ⊃⍵: ⍺ ∇ 1↓⍵ ⋄ (⍺,⊃⍵) ∇ 1↓⍵ }⎕AV  
    ⍙AD← ⍙A, ⎕D                                       

⍝ SetParmDefaults: Load time routine
⍝   Sets parameters 
⍝        ⍵.auto, ⍵.verbose, ⍵.path, ⍵.prefix, ⍵.suffix,⍵._readParmFi, and ⍵.dfnsOrder.
⍝   If ⍵.auto← 0 after SetParmDefaults & LoadParmFi, 
⍝       then no more processing is done and Auto is a nop.
⍝   If ⍵.dfnsOrder←'skip' the dfns w/s isn't checked.
⍝   If ⍵.path←⍬ or ⍵.suffix←⍬, no files are checked.  
  SetParmDefaults← { 
    ⍝ These are the default JSON settings. User can override in "profile" ./.∆F 
    ⍝ To replace with APL-style {...} ⎕NS when v.20 arrives. 
      DefParms← {  
       ⍝  // Default .∆F (JSON5) Parameter File                           
       ⍝  // Items not to be (re)set by user should be omitted/commented out.              
       ⍝  // Exceptions: 
       ⍝  // [1-2] auto and verbose can each be set to null to signal 
       ⍝  //       that their value should come from the ∆Fapl globals LIB_AUTO or VERBOSE.
       ⍝  // [3]   prefix, which if null is the same as [""], i.e. 0-length string prefix.
       ⍝       
       ⍝  // ∆F global variables LIB_AUTO and VERBOSE are set in ∆Fapl.dyalog.
       ⍝  // Their usual values are LIB_AUTO← 1 ⋄ VERBOSE← 0
       ⍝  // The values are explained here:
       ⍝  //   LIB_AUTO:  1   We want to get library objects from files and/or workspaces,
       ⍝  //                  using the default or user-specified path.
       ⍝  //   LIB_AUTO:  0   We don't want to use the LIB_AUTO feature.
       ⍝  //   VERBOSE:   1   Will display loadtime and runtime msgs, both library-related and general.
       ⍝  //                  The debug ∆F option will also display limited runtime msgs.
       ⍝  //   VERBOSE:   0   Will only display error or important warning msgs.
       ⍝       
       ⍝  // auto:
       ⍝  //   If 0, user must load own objects; nothing is automatic.                 
       ⍝  //   If 1, dfns and files searched in sequence set by dfnsOrder. 
       ⍝  //         See path for directory search sequence.                        
       ⍝  //   If null, the value is set from LIB_AUTO global 
       ⍝     auto:  null,   
       ⍝       
       ⍝  // verbose: 
       ⍝  //    If 0 (quiet), if 1 (verbose).  
       ⍝  //    If null, value is set from VERBOSE global. 
       ⍝     verbose: null,  
       ⍝                                                          
       ⍝  // path: The dirs and/or workspaces  to search.  
       ⍝  //       For a directory, use a string:  
       ⍝  //           "MyDyalogLib"
       ⍝  //       For a workspace, use a single string in a list:  
       ⍝  //           ["dfns"] or ["MyDyalogLib/mathfns"]
       ⍝     path: [ ".", "./MyDyalogLib", ["dfns"], ],  
       ⍝                   
       ⍝  // prefix: literal string to prefix to each name, when searching directories.
       ⍝  //         Ignored for workspaces.
       ⍝  //         [] is equiv. to [""]. 
       ⍝  //         Example given name "mydfn" and {prefix: ["∆F_", "MyLib/"], suffix: ["aplf"]}  
       ⍝  //         ==> ["∆F_mydfn.aplf", "MyLib/mydfn.aplf"]   
       ⍝     prefix: [], 
       ⍝                               
       ⍝  // suffix: at least one suffix is required. The "." is prepended for you!  
       ⍝  //         Ignored for workspaces.    
       ⍝     suffix: ["aplf", "aplo", "dyalog"],     
       ⍝                   
       ⍝  //  Internal Runtime (hidden) Parameters                                               
       ⍝     _readParmFi: 0,                     // 0: Haven't read .∆F yet. 1 afterwards.     
       ⍝     _fullPath:   [],                    // Generated from path and prefixes.                                                                              
      }
      1: _←1⊣  'parms' ⎕NS ⎕JSON⍠ jOpts⊣∊(⎕UCS 13),⍨¨'{',1↓'^ *⍝' ⎕R ''⊣⎕NR'DefParms' 
  }
⍝ LoadParmFi: Load time routine
⍝ Loads parameter file ⍵ (if it exists) into namespace ⍺
⍝   If parms.verbose in the parameter file is null or omitted, the default (##.VERBOSE) will be used.
  LoadParmFi← { 
      ⎕PW←100 ⋄ parmFi← ⍵  
    ⍝ CShow: Cond'lly show all json parameters in 'parms' EXCEPT internal ones starting with '_'
      CShow← { ⍵.verbose: ⍬⊣ ⎕← ⎕JSON⍠ jOpts⊢ ⍵.(⎕NS { ⍵/⍨ '_'≠⊃¨⍵} ⎕NL -2) ⋄ ⍬ } 
    ⍝ Fi2Json: Update parameters from parm file.
      Fi2Json← { ~⎕NEXISTS ⍵: ⍬ ⋄ parms._readParmFi← 1 ⊣ 'parms' ⎕NS ⎕JSON⍠ jOpts⊢ ⊃⎕NGET ⍵} 
    ⍝ ∆IfNull: Replace null or [], where required. 
      ∆IfNull← {(⍬∘≡∨⎕NULL∘≡)⍺.⎕OR ⊃⍵: ⍺⍎'←⊃⌽⍵',⍨⊃⍵ ⋄ ⍬}¨ 
    ⍝ GenFullPath parms.path 
      GenFullPath←{ ⍺←⍬ ⋄ 0=≢⍵: ⍺ ⋄ p← ⊃⍵
        1<|≡p: (⍺, ⊂p) ∇ 1↓⍵               ⍝ workspace
          (⍺, ,(⊂p)∘., '/'∘.,parms.prefix) ∇ 1↓⍵   ⍝ file 
      }  
      _← Fi2Json parmFi       
      _← parms ∆IfNull('verbose' ##.VERBOSE)('auto' ##.LIB_AUTO)('prefix' (⊂''))
      _← CShow parms 
    ~parms.auto: 0⊣ ⎕FX 'Auto←{' 'ulNm}'                         ⍝ auto=0: Auto => nop.
      parms._fullPath← GenFullPath parms.path 
    0≡≢ parms._fullPath: 0⊣ ⎕FX 'Auto←{' 'ulNm}'   ⊣ parms.auto← 0  ⍝ No path: Auto => nop.
      1: _← 1
  } 
  jOpts← ('Dialect' 'JSON5')('Compact' 0)('Null' ⎕NULL)

⍝ Loadtime: user library initialization
  ulNm← ⍕ulNs← ##.ûLib     ⍝ ulNs, ulNm: user library reference and name.
  _← ulNs.⎕DF '£=[',ulNm,']'

⍝ Load Runtime Parameters!
  SetParmDefaults ⍬
  LoadParmFi '.∆F'

:EndNamespace   ⍝ libUtil