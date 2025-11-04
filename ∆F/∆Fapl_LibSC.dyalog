⍝ ∆Fapl_LibSC.dyalog $UPDATE_TIME = "20251104T074538" 
:Namespace libUtil 
⍝ libUtil (namespace): Handles £ and `L shortcuts. 
⍝ ∘ SetParmDefaults show the default options in APLAN format.  
⍝ ∘ The options may be tailored via a APLAN file in .∆F.
⍝ ∘ The "user" namespace referenced by £ and `L is ûLib, established at ]Load time.
⍝
⍝ Auto:
⍝ The top-level runtime workhorse is Auto, the only function 
⍝ called from the main scan routines CF_SF and CF_Esc. 

⍝ Auto: Runtime routine:   
⍝ ∘ Our task is to find nm in £.nm...[←] and ⎕CY or ⎕FIX src code for it.
⍝ ∘ Does NOT affect the string being scanned. Only used for its ⎕CY or ⎕FIX side effect.
⍝ Auto: u@nsNm←  dbg@B ∇ s@CV, 
⍝  s starts 1 char after £ or `L. 
⍝  See steps below. 
⍝ Returns: ulNm (the stringified library namespace), no matter what.  
  ∇ u← Auto (s dbg auto)
    u← ulNm                                            ⍝ Return ulNm no matter what!
    :If   ~auto                                        ⍝ Disable auto mode if auto=0.
    :OrIf 0=≢ s                                        ⍝ Empty str? Done
    :OrIf '.'≠⊃s← NoLB s                               ⍝ No dot after £? Done
    :OrIf ~⍙A∊⍨ ⊃s← 1↓s                                ⍝ Word after '.' start of APL name? Done
    :OrIf 0≠ulNs.⎕NC nm← s↑⍨ t← +/∧\s∊ ⍙AD             ⍝ Word isn't an APL name? Done
    :OrIf '←'= ⊃NoLB t↓s                               ⍝ It's a simple assignment? Done
    :Else 
        ulNs dbg parms ⍙LoadObj nm                    ⍝ Else, try to find and load the obj. named.
    :EndIf 
  ∇ 

  ⍝ ⍙LoadObj: Find nm in £.nm or `L.nm and try to load its definition into ulNs from path.
  ⍝     (1|0)@B← ulNs@ulNs dbg@B parms@ns ∇ nm@CVS 
  ⍝ Find <nm> in search directories (parms.path) and dfns workspace, according to parameters <parms>.
  ⍝ Called by ⍙Auto (above).
  ⍝    (1|0)← ulNs dbg parms ∇ nm 
  ⍝ Returns SHY 1 (succ) or SHY 0 (fail), having established <nm> in ulNs (ulNs) on success.
  ⍙LoadObj← { 
      ulNs dbg parms←⍺ ⋄ nm← ⍵ 
      OK NOTFND ERR← 1 0 ¯1       ⍝ Possible return codes from Scan functions here.

    ⍝ FixFromWS: Search for name ⍺ in ws ⍵. On success, 1 'ws:⍵'; on failure, 0 ⍬
      FixFromWS← { 11:: NOTFND ⍬ ⋄ OK ('ws:',⍵)⊣ ⍺ ulNs.⎕CY ⍵ }

    ⍝ SubScanFiles: 
    ⍝   Search a list of full filenames ⍵ ending in simple name ⍺ (before suffixes).
    ⍝      If a) it finds a file with name ⍵, 
    ⍝         b) the ⎕FIX succeeds, and
    ⍝         c) the name ⍺ is among the names returned in the ⎕FIX, 
    ⍝            returns success: 1 ('file:', fi).
    ⍝      Otherwise, failure: 0 ⍬.
      SubScanFiles← {  
        0=≢ ⍵: NOTFND ⍬ ⋄ 22 11:: ERR ⍬ ⋄ nm← ⍺ ⋄ fi← ⊃⍵ ⋄ 
        ~⎕NEXISTS fi: ⍺ ∇ 1↓⍵ 
        ERR≠ rc← nm FixByType fi: rc ('file:',fi) ⋄ ERR ⍬ 
      }

    ⍝ FixByType:  nm ∇ fi.  Fix based on the suffix (filetype) of ⍵
      FixByType← { nm fi←⍺ ⍵   
      ⍝ ∘ The nameclass distinctions are currently NOT enforced for
      ⍝   the first three suffixes, but it's trivial to do.
      ⍝ ∘ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed. 
        '.aplf' '.aplo' '.apln'∊⍨ ⊂5↑fi: ERR OK⊃⍨ (⊂nm)∊ 2 ulNs.⎕FIX fi 
            SetNm ← nm∘{ulNs⍎⍺,'←⍵'}
        '.apla'≡¯5↑fi: OK⊣ SetNm ⎕SE.Dyalog.Array.Deserialise ⊃⎕NGET  fi 1 
        '.txt' ≡¯4↑fi:  OK⊣ SetNm ⊃⎕NGET fi 1  
        '.json'≡¯5↑fi: OK⊣ SetNm ⎕JSON⍠jOpts ⊃⎕NGET fi 1  
      ⍝ All other suffixes, including .dyalog or a user-defined suffix.
      ⍝ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed. 
            ERR OK⊃⍨ (⊂nm)∊ 2 ulNs.⎕FIX fi            
      }

    ⍝ ScanPath: Recursively scan the path for name ⍵ in each file or wsid 
    ⍝   spec in parms._fullPath 
    ⍝     OK@B where@S← nm@S ∇ path@NsV    
    ⍝   If we see a array (with a single string), it's a workspace: 
    ⍝     call and return result from FixFromWS nm  (⊃spec). 
    ⍝   Otherwise, 
    ⍝     call and return result from ∆FI nm spec sfx.
      ScanPath← {  
        0= ≢ ⍵: NOTFND ⍬ ⋄ nm path← ⍺ ⍵ ⋄ cur← ⊃path
        ⍝ If cur is a vector of (0 or more) char vectors, each is assumed to be a workspace id.
        ⍝ When done, having returned NOTFND, recursively continue ScanPath.
        ⍝ Otherwise (OK or ERR), return from ScanPath.
          SubScanWS← ∇ {  
            0=≢⍵: nm ⍺⍺ 1↓path ⋄ NOTFND≠⊃ret← nm FixFromWS ⊃⍵: ret ⋄ ∇ 1↓⍵ 
          }
        1< |≡cur: SubScanWS cur            
          ff← ,(⊂cur)∘.,(⊂nm,'.')∘.,parms.suffix             
        NOTFND≠⊃ret← nm SubScanFiles ff: ret 
          nm ∇ 1↓path                       
      }

    ⍝ Action before returning. Returns the return code ⍺ or signal an error.
      Action← ulNs { 
      (~⍵⍵)∧ ⍺≠ERR: ⍺ ⋄ (nm where)← ⍵ ⋄ dest← ⍕⍺⍺ 
      ⍺=OK:     ⍺ ⊣ ⎕← 'DEBUG: Copied "', nm, '" into ',dest, (0≠≢ where)/ ' from ','"',where,'"'
      ⍺=NOTFND: ⍺ ⊣ ⎕← 'DEBUG: Object "',nm,'" not found in search path'    
                11 ⎕SIGNAL⍨ 'DEBUG: Error occurred when copying object "',nm,'" into ',dest  
      } (parms.verbose∨ dbg)

    ⍝ Executive for ⍙LoadObj 
      rc where← nm ScanPath parms._fullPath 
    1: _← rc Action nm where  
  }
  
  ⍝ Minor utility and constants for Auto 
  ⍝ NoLB: Non-leading blanks; ⍙A: valid initials of APL nms; ⍙AD: valid chars of APL nms. 
    NoLB← { ⍵↓⍨ +/∧\' '=⍵}
    ⍙A← { ⍺←'' ⋄ 0=≢⍵: ⍺~'⍺⍵∇' ⋄ ¯1=⎕NC ⊃⍵: ⍺ ∇ 1↓⍵ ⋄ (⍺,⊃⍵) ∇ 1↓⍵ }⎕AV  
    ⍙AD← ⍙A, ⎕D  
    jOpts← ('Dialect' 'JSON5')('Compact' 0)('Null' ⎕NULL)                                     

⍝ SetParmDefaults: Load time routine
⍝   Sets parameters 
⍝        ⍵.auto, ⍵.verbose, ⍵.path, ⍵.prefix, ⍵.suffix, etc.
⍝   If ⍵.auto← 0 after SetParmDefaults & LoadParmFi, 
⍝       then no more processing is done and Auto does nothing except return ulNm (lib ns name).
⍝   If ⍵.path←⍬, no files or workspaces are checked. If ⍵.suffix←⍬, only w/ss might be checked.  
  SetParmDefaults← { 
    ⍝ These are the default JSON settings. User can override in "profile" ./.∆F 
    ⍝ To replace with APL-style {...} ⎕NS when v.20 arrives. 
      DefParms← {
       ⍝  (
       ⍝   ⍝ Default .∆F (JSON5) Parameter File                           
       ⍝   ⍝ Items not to be (re)set by user should be omitted/commented out.              
       ⍝   ⍝ Exceptions: 
       ⍝   ⍝ [1-2] auto and verbose can each be set to null to signal 
       ⍝   ⍝       that their value should come from the ∆Fapl globals LIB_AUTO or VERBOSE.
       ⍝   ⍝ [3]   prefix, which if null is the same as [''], i.e. 0-length string prefix.
       ⍝       
       ⍝   ⍝ ∆F global variables LIB_AUTO and VERBOSE are set in ∆Fapl.dyalog.
       ⍝   ⍝ Their usual values are LIB_AUTO← 1 ⋄ VERBOSE← 0
       ⍝   ⍝ The values are explained here:
       ⍝   ⍝   LIB_AUTO:  1   We want to get library objects from files and/or workspaces,
       ⍝   ⍝                  using the default or user-specified path.
       ⍝   ⍝   LIB_AUTO:  0   We don't want to use the LIB_AUTO feature.
       ⍝   ⍝   VERBOSE:   1   Will display loadtime and runtime msgs, both library-related and general.
       ⍝   ⍝                  The debug ∆F option will also display limited runtime msgs.
       ⍝   ⍝   VERBOSE:   0   Will only display error or important warning msgs.
       ⍝       
       ⍝   ⍝ auto:
       ⍝   ⍝   If 0, user must load own objects; nothing is automatic.                 
       ⍝   ⍝   If 1, dfns and files searched in sequence set by dfnsOrder. 
       ⍝   ⍝         See path for directory search sequence.                        
       ⍝   ⍝   If null, the value is set from LIB_AUTO global 
       ⍝     auto:  ⎕NULL    
       ⍝       
       ⍝   ⍝ verbose: 
       ⍝   ⍝    If 0 (quiet), if 1 (verbose).  
       ⍝   ⍝    If null, value is set from VERBOSE global. 
       ⍝     verbose: ⎕NULL  
       ⍝                                                          
       ⍝   ⍝ path: The file dirs and/or workspaces to search IN ORDER left to right:
       ⍝   ⍝    e.g. path: [ 'fd1', 'fd2', ['ws1', 'wsdir/ws2'], 'fd3', ['ws3']]
       ⍝   ⍝    For a file directory, the item must be a simple char vector
       ⍝   ⍝        'MyDyalogLib'
       ⍝   ⍝    For workspaces, the item must be a vector of one or more char vectors
       ⍝   ⍝        (⊂'dfns') or (⊂'MyDyalogLib/mathfns') or ('dfns', 'myDfns')
       ⍝     path:  ( '.'  ⋄ './MyDyalogLib' ⋄ ('dfns'⋄))  
       ⍝                   
       ⍝   ⍝ prefix: literal string to prefix to each name, when searching directories.
       ⍝   ⍝     Ignored for workspaces.
       ⍝   ⍝     ⍬ is equiv. to  ''. 
       ⍝   ⍝     Example given name 'mydfn' and (prefix: '∆F_' 'MyLib/' ⋄ suffix: ⊂'aplf')  
       ⍝   ⍝     ==> ('∆F_mydfn.aplf'  'MyLib/mydfn.aplf')   
       ⍝     prefix: ⍬ 
       ⍝                               
       ⍝   ⍝ suffix: at least one suffix is required. The '.' is prepended for you!  
       ⍝   ⍝    Not applicable to workspaces. See documentation for definitions.
       ⍝   ⍝    By default, 'dyalog' and unknown filetypes are not enabled. 
       ⍝   ⍝    Generally, place most used definitions first.
       ⍝     suffix: ('aplf'  'apla'  'aplo'  'apln'  'json' 'txt')    
       ⍝                   
       ⍝   ⍝  Internal Runtime (hidden) Parameters                                               
       ⍝     _readParmFi: 0                      ⍝ 0 Zero: Haven't read .∆F yet. 1 afterwards.     
       ⍝     _fullPath:   ⍬                      ⍝ ⍬ Zilde: Generated from path and prefixes.
       ⍝  )                                                                               
      }
      ⎕SE.Dyalog.Array.Deserialise  1↓¯1↓'^ *⍝' ⎕R ''⊣⎕NR'DefParms' 
  }

⍝ LoadParmFi: Load time routine
⍝ Loads parameter file ⍵ (if it exists) into namespace ⍺
⍝   If parms.verbose in the parameter file is null or omitted, the default (##.VERBOSE) will be used.
  LoadParmFi← { 
      parmFi← ⍵  
    ⍝ Fi2APLAN: Update parameters from parm file.
      Fi2APLAN← { 
        ~⎕NEXISTS ⍵: ⍬     
        11:: 0⊣ ⎕← 'ERROR: UNABLE TO PARSE USER PARAMETER FILE "',⍵,'". ARRAY NOTATION MAY BE INVALID.'
          _← 'parms' ⎕NS ⎕SE.Dyalog.Array.Deserialise ⊃⎕NGET ⍵ 
          0⊣ parms._readParmFi← 1 
      } 
    ⍝ ∆IfNull: Replace null or [], where required. 
      ∆IfNull← {(⍬∘≡∨⎕NULL∘≡)⍺.⎕OR ⊃⍵: ⍺⍎'←⊃⌽⍵',⍨⊃⍵ ⋄ ⍬}¨ 
    ⍝ CShow: Cond'lly show all json parameters in 'parms' EXCEPT internal ones starting with '_'
      CShow← { 
        ~⍵.verbose: ⍬ ⋄ ⎕PW←100 ⋄ ⎕← 'Library Runtime Parameters (default + user-set):'
          ⍬⊣ ⎕← ↑0 ⎕SE.Dyalog.Array.Serialise ⍵.(⎕NS {⍵/⍨ '_'≠⊃¨⍵} ⎕NL -2)  
      } 
    ⍝ GenFullPath parms.path 
      GenFullPath←{ ⍺←⍬ ⋄ 0=≢⍵: ⍺ ⋄ p← ⊂⊃⍵
        2<|≡p: (⍺, p) ∇ 1↓⍵                                         ⍝ workspace
          (⍺, ,p∘., '/'∘.,parms.prefix) ∇ 1↓⍵                       ⍝ file 
      }  
    ⍝ Main...
      _← Fi2APLAN parmFi       
      _← parms ∆IfNull('verbose' ##.VERBOSE)('auto' ##.LIB_AUTO)('prefix' (,⊂''))
      _← CShow parms 
    ~parms.auto: 0⊣ ⎕FX ,⊂'Auto←{ulNm}'                             ⍝ auto=0: Auto => nop.
      parms._fullPath← GenFullPath parms.path 
    0=≢ parms._fullPath: 0⊣ ⎕FX ,⊂'Auto←{ulNm}' ⊣ parms.auto← 0     ⍝ No path: Auto => nop.
      1: _← 1
  } 

⍝ Loadtime: user library initialization
  ulNm← ⍕ulNs← ##.ûLib     ⍝ ulNs, ulNm: user library reference and name.
  _← ulNs.⎕DF '£=[',ulNm,']'
⍝ Load Runtime Parameters!
  parms← SetParmDefaults ⍬
  LoadParmFi './.∆F'

:EndNamespace   ⍝ libUtil
