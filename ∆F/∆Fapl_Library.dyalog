⍝ ∆Fapl_LibSC.dyalog $UPDATE_TIME = "2025-11-14T20:21:14" 
:Namespace libUtil 

⍝ libUtil (namespace): Handles £ and `L shortcuts.
⍝ See EXECUTIVE at bottom...
⍝   LinkUserLib: Allows libUtil to access the user Library shortcut namespace
⍝   LoadParms:   Loads default (internal) and user parameters, optionally displaying them.

⍝ Utility used by ∆F when it sees £ or `L. 
⍝   Auto:
⍝     The top-level runtime workhorse is Auto, the only function 
⍝     called from the main scan routines CF_SF and CF_Esc. 

⍝ ===================================================================================
⍝ Auto: Runtime routine:   
⍝ ∘ Our task is to find nm in £.nm...[←] and ⎕CY or ⎕FIX src code for it.
⍝ ∘ Does NOT affect the string being scanned. Only used for its ⎕CY or ⎕FIX side effect.
⍝ Auto: u@nsNm←  verbose@B ∇ s@CV, 
⍝    s starts 1 char after £ or `L. 
⍝    extern: ulNm, ulNs  
⍝  See steps below. 
⍝ Returns: ulNm (the stringified library namespace), no matter what.  
  ∇ u← Auto (s verbose auto) ;t 
    u← ulNm                                            ⍝ Return ulNm no matter what!
    :If   ~auto                                        ⍝ Disable auto mode if auto=0.
    :OrIf 0=≢ s                                        ⍝ Empty str? Done
    :OrIf '.'≠⊃s← NoLB s                               ⍝ No dot after £? Done
    :OrIf ~⍙A∊⍨ ⊃s← NoLB 1↓s                           ⍝ Word after '.' start of APL name? Done
    :OrIf 0≠ulNs.⎕NC nm← s↑⍨ t← +/∧\s∊ ⍙AD             ⍝ Word isn't an APL name? Done
    :OrIf '←'= ⊃NoLB t↓s                               ⍝ It's a simple assignment? Done
    :Else 
        ulNs verbose parms ⍙LoadObj nm                     ⍝ Else, try to find and load the obj. named.
    :EndIf 
  ∇ 

  ⍝ ShowPath:  See 'path' special call in ##.Special. 
  ShowPath← { ⊃1 ##.Apl2AN parms._fullPath } 

  ⍝ ======================================================================================
  ⍝ ⍙LoadObj: Find nm in £.nm or `L.nm and try to load its definition into ulNs from path.
  ⍝     (1|0)@B← ulNs@ulNs verbose@B parms@ns ∇ nm@CVS 
  ⍝ Find <nm> in search directories (parms.path) and dfns workspace, according to parameters <parms>.
  ⍝ Called by ⍙Auto (above).
  ⍝    (1|0)← ulNs verbose parms ∇ nm 
  ⍝ Returns SHY 1 (succ) or SHY 0 (fail), having established <nm> in ulNs (ulNs) on success.
  ⍙LoadObj← { 
    ⍝ ⍙LoadObj utilities, followed by the executive...

    ⍝ FixFromWS: Search for name ⍺ in ws ⍵. On success, 1 'ws:⍵'; on failure, 0 ⍬
      FixFromWS← { 11:: rcNF ⍬ ⋄ rcOK ('ws:',⍵)⊣ ⍺ ulNs.⎕CY ⍵ }
    ⍝ SubScanFiles: 
    ⍝  Search a list of full filenames ⍵ ending in simple name ⍺ (before suffixes).
    ⍝      If a) it finds a file with name ⍵, 
    ⍝         b) the ⎕FIX succeeds, and
    ⍝         c) the name ⍺ is among the names returned in the ⎕FIX, 
    ⍝            returns success: 1 ('file:', fi).
    ⍝  Otherwise, return not found.
      SubScanFiles← {  
        (0=≢ ⍵): rcNF ⍬ 
        22 11:: rcER ⍬ ⋄ nm← ⍺ ⋄ fi← ⊃⍵ ⋄ 
        ~⎕NEXISTS fi: ⍺ ∇ 1↓⍵ 
        rcER≠ rc← nm SCF_FixByType fi: rc ('file:',fi) ⋄ rcER ⍬ 
      }
    ⍝ SCF_FixByType:  nm ∇ fi.  Fix based on the suffix (filetype) of ⍵
    ⍝ ∘ The nameclass distinctions are currently NOT enforced for
    ⍝   the first three suffixes, but it's trivial to do.
    ⍝ ∘ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed. 
      SCF_FixByType← { nm fi←⍺ ⍵   
          '.aplf' '.aplo' '.apln'∊⍨ ⊂5↑fi: rcER rcOK⊃⍨ (⊂nm)∊ 2 ulNs.⎕FIX fi 
            SetNm ← nm∘{ulNs⍎⍺,'←⍵'}
        '.apla'≡¯5↑fi: rcOK⊣ SetNm ##.Apl2AN ⊃⎕NGET  fi 1 
        '.txt' ≡¯4↑fi:  rcOK⊣ SetNm ⊃⎕NGET fi 1  
            jOpts← ('Dialect' 'JSON5')('Compact' 0)('Null' ⎕NULL)                                     
        '.json'≡¯5↑fi: rcOK⊣ SetNm ⎕JSON⍠jOpts ⊃⎕NGET fi 1  
      ⍝ All other suffixes, including .dyalog or a user-defined suffix.
      ⍝ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed. 
            rcER rcOK⊃⍨ (⊂nm)∊ 2 ulNs.⎕FIX fi            
      }
    ⍝ SubScanWS:   nm path _SubScanWS subpath
    ⍝    nm: name to find      path: ScanPath's current (outer) path 
    ⍝    ScanPath: see below   subp: the list of workspaces
    ⍝    Returns rcOK, rcNF, rcER or result from recursive call to ScanPath
      SubScanWS← { (nm path) subp← ⍺ ⍵
        0=≢ subp: nm ScanPath 1↓path ⋄ ret← nm FixFromWS ⊃subp
        rcNF≠⊃ret: ret ⋄ nm path ∇ 1↓subp 
      }
    ⍝ ScanPath: Recursively scan the path for name ⍵ in each file or wsid 
    ⍝   spec in parms._fullPath 
    ⍝     rcOK@B where@S← nm@S ∇ path@NsV    
    ⍝   If we see a array (with a single string), it's a workspace: 
    ⍝     call and return result from FixFromWS nm  (⊃spec). 
    ⍝   Otherwise, 
    ⍝     call and return result from ∆FI nm spec sfx.
      ScanPath← {  
        0= ≢ ⍵: rcNF ⍬ ⋄ nm path← ⍺ ⍵ ⋄ cur← ⊃path
        ⍝ If cur is a vector of (0 or more) char vectors, each is assumed to be a workspace id.
        ⍝ When done, having returned rcNF, recursively continue ScanPath.
        ⍝ Otherwise (rcOK or rcER), return from ScanPath.
        1< |≡cur: nm path SubScanWS cur                ⍝ VCV means one or more workspaces.        
          ff← ,(⊂cur)∘.,(⊂nm,'.')∘.,parms.suffix       ⍝ cur is a CV. Generate ff, list of files.  
        rcNF≠⊃ret← nm SubScanFiles ff: ret 
          nm ∇ 1↓path                       
      }
    ⍝ ActReturn: Show optional action, then return.
    ⍝ If (~ parms.verbose∨ verbose), exit quietly, unless ⍺ is an error.
    ⍝ Otherwise, exit with a msg based on ⍺.
      ActReturn← ulNs { 
        (~⍵⍵)∧ ⍺≠rcER: ⍺ ⋄ (nm where)← ⍵ ⋄ dest← ⍕⍺⍺ 
        ⍺=rcOK: ⍺ ⊣ ⎕← '∆F: Copied "', nm, '" into ',dest, (0≠≢ where)/ ' from ','"',where,'"'
        ⍺=rcNF: ⍺ ⊣ ⎕← '∆F: Object "',nm,'" not found on search path.'    
          11 ⎕SIGNAL⍨ 'Error occurred when copying object "',nm,'" into ',dest  
      } (parms.verbose∨ verbose)
      
    ⍝ Executive for ⍙LoadObj 
      ulNs verbose parms←⍺ ⋄ nm← ⍵ 
      rcOK rcNF rcER← 1 0 ¯1       ⍝ Return codes: OK, Not Found, Error
      rc where← nm ScanPath parms._fullPath 
    1: _← rc ActReturn nm where  
  } ⍝ ⍙LoadObj 

  ⍝ Utilities and constants  
  ⍝ NoLB: Non-leading blanks; ⍙A: valid initials of APL nms; ⍙AD: valid chars of APL nms. 
    NoLB← { ⍵↓⍨ +/∧\' '=⍵} 
    ⍙A← { ⍺←'' ⋄ 0=≢⍵: ⍺~'⍺⍵∇' ⋄ ¯1=⎕NC ⊃⍵: ⍺ ∇ 1↓⍵ ⋄ (⍺,⊃⍵) ∇ 1↓⍵ }⎕AV  
    ⍙AD← ⍙A, ⎕D  

⍝ ============================================================================
⍝ SetParmDefaults: Load time routine
⍝   Sets parameters 
⍝        ⍵.load, ⍵.auto, ⍵.verbose, ⍵.path, ⍵.prefix, ⍵.suffix, etc.
⍝   ⍵.load defaults to ##.AUTOLOAD (which must be 1 or 0).
⍝   If ⍵.load is set to 1 in the .∆F file, then the .∆F file is loaded.
⍝   If not,
⍝       then no more processing is done and Auto does nothing except return ulNm (lib ns name).
⍝   If ⍵.path←⍬, no files or workspaces are checked. If ⍵.suffix←⍬, only w/ss might be checked.  
  SetParmDefaults← { 
    ⍝ These are the default APL Array Notation settings: format ok whether Dyalog 20 or earlier.
    ⍝ User can override in ./.∆F, also in APLAN format. 
      DefParms← {
         (
          ⍝ Default .∆F (JSON5) Parameter File                           
          ⍝ Items not to be (re)set by user may be omitted/commented out.              
          ⍝ If (load: ⎕NULL), then LIB_LOAD [note 1] is used for load.
          ⍝ If (verbose: ⎕NULL), then VERBOSE [note 1] is used for verbose.
          ⍝ If (prefix: ⎕NULL) or (prefix: ⍬), then (prefix: '' ⋄)     
          ⍝ [note 1] 
          ⍝   ∆F global variables LIB_LOAD and VERBOSE are set in ∆Fapl.dyalog.
          ⍝    Their usual values are LIB_LOAD← 1 ⋄ VERBOSE← 0
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
            path:  ( './MyDyalogLib' ⋄ ('dfns'⋄) ⋄ '.' ⋄ )  
                          
          ⍝ prefix: literal string to prefix to each name, when searching directories.
          ⍝     Ignored for workspaces.
          ⍝     ⍬ is equiv. to  ''. 
          ⍝     Example given name 'mydfn' and (prefix: '∆F_' 'MyLib/' ⋄ suffix: ⊂'aplf')  
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
            _debug:      0                      ⍝ Synonym for verbose (internally)
         )                                                                               
      }
      ##.AN2Apl 1↓¯1↓ ⎕NR'DefParms'  ⍝ Before Dyalog 20
      DefParms ⍬                                         ⍝ Dyalog 20
  }

⍝ LoadParmFi: Loadtime routine
⍝ Loads parameter file ⍵ (if it exists) into namespace ⍺
⍝   If parms.verbose in the parameter file is null or omitted, the default (##.VERBOSE) will be used.
  LoadParmFi← { 
      parmFi← ⍵  
    ⍝ ReadParmFi: Update parameters from parm file.
      ReadParmFi← { 
        ~⎕NEXISTS ⍵: ⍬ ⋄ 11:: 0⊣ 11 ⎕SIGNAL⍨ ⎕← ParseÊ ⍵ 
          _← 'parms' ⎕NS ##.AN2Apl ⊃⎕NGET ⍵      ⍝ Merge parm file into internal defaults
          0⊣ parms._readParmFi← 1 
      } 
      ParseÊ← {  
         e1← '∆F: ∆F Load Error: Unable to parse parameter file "',⍵,'".'
         e2← '∆F: ∆F Load Error: Array Notation or parameters may be invalid.'
         e1, (⎕UCS 13),e2     
      }  
    ⍝ GenFullPath:   _parms._fullPath← ∇ parms.path 
      GenFullPath← {
          ⍺←⍬ ⋄ 0=≢⍵: ⍺ ⋄ p← ⊂⊃⍵ 
        2<|≡p: (⍺, p) ∇ 1↓⍵                                         ⍝ workspace
          (⍺, ,p∘., '/'∘.,parms.prefix) ∇ 1↓⍵                       ⍝ file 
      } 
    ⍝ ∆IfNull: Replace null or [], where required. 
      ∆IfNull← { (⍬∘≡∨⎕NULL∘≡)⍺.⎕OR ⊃⍵: ⍺⍎'←⊃⌽⍵',⍨⊃⍵ ⋄ ⍬ }¨ 

    ⍝ Main...
      _← ReadParmFi parmFi  
    ⍝ If parameters are ⎕NULL or ⍬, treat special cases...
      _← parms ∆IfNull('verbose' ##.VERBOSE)('load' ##.LIB_LOAD)
      _← parms ∆IfNull('prefix'(,⊂'')) ('auto' 0) ('path' ⍬) ('suffix' ⍬)
    ~parms.load: _← 0⊣ ⎕FX ,⊂'Auto←{ulNm}'⊣ parms.auto←0  ⍝ auto=0: Auto => nop.
      parms._fullPath← GenFullPath parms.path 
    ⍝ If parms._fullPath is not empty, we're done!
    0< ≢parms._fullPath: _← 1 
    ⍝ If parms._fullPath is empty, then turn auto off, since there's nothing to load.
      nolibW← '!!! Warning:  (load: 1) but the search path is empty!'
      _← 0⊣ ⎕FX ,⊂'Auto←{ulNm}'⊣ parms.auto← 0⊣ (⎕∘←)⍣parms.verbose⊣nolibW       
  } 
  ⍝ CShow: 
  ⍝ Cond'lly show 
  ⍝     all APLAN parameters in 'parms' in alph order EXCEPT internal ones starting with '_'
  ⍝ If ⍺=1, force a display, even if parms.verbose=0.
  ⍝ Returns: a matrix of parms or (1 0⍴'')
  CShow← { ⍺←0 ⋄ 0:: 0⊣⎕←'∆F: ∆F Load: Error displaying runtime parameters'
    (~⍺)∧~⍵.verbose: _← 1 0⍴''  
      _← ⊂'Library Runtime Parameters (default + user-set):'⊣ ⎕PW← 100
    1: _← ↑##.Apl2AN ⍵.(⎕NS {⍵/⍨ '_'≠⊃¨⍵} ⎕NL -2) 
  } 

⍝ Load user parms
⍝     load builtin parms? If defaults or 'parms' doesn't yet exist.
⍝     load user parms?    If user=1.
⍝     show parms?         If parms.verbose is now or if force.
⍝ Used at EXECUTIVE below and in ∆F with the 'parms' option.
  ∇ {rc}← LoadParms (defaults user force)
    :If defaults  ⋄ :OrIf 0=⎕NC 'parms' 
        'parms' ⎕NS SetParmDefaults ⍬  
    :EndIf 
    :If user 
        LoadParmFi './.∆F'  
    :EndIf 
    rc← force CShow parms 
  ∇
⍝   LinkUserLib: Point to (empty, but named) user library at load-time.
⍝      actual ref: ##.ûserLib, local ref (alias): ulNs, local name: ulNm.
  ∇ {uLib}← LinkUserLib uLib
    ulNm← ⍕ulNs← uLib
    _← ulNs.⎕DF '£=[',ulNm,']'
  ∇

⍝ =========================================================================
⍝ EXECUTIVE
  LinkUserLib ##.ûserLib
  LoadParms 1 1 0
:EndNamespace   ⍝ libUtil
