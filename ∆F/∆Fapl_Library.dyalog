⍝ ∆Fapl_LibSC.dyalog      (UPDATE_TIME: '2025-12-28') 
:Namespace libUtil 
⍝ This namespace handles Library (£ or `L) shortcut automatic loading...
⍝ ∘ See ⍙Fapl for fn ⍙LoadLibAuto, which loads this library.
⍝ ∘ See "Executive" at bottom of file, which calls
⍝   LibUserFull and LoadParms  
⍝ ∘ Local and External variables pointing to the "user" library.
⍝   - libUser  -  the namespace ref itself, by default ⍙Fapl.library (##.library)
⍝   - libUserNm-  the name of libUser
⍝ ===================================================================================
⍝ LibAuto: libStr← ê ∇ str 
⍝    str str starts 1 char after '£' or '`L'. 
⍝    ê: namespace with (r/w:) ê.acache; (r/o:) ê.auto; (read in LoadObj:) ê.verbose 
⍝ Returns: libUserNmP, the library name surrounded by parens, no matter what.
⍝ ∘ Used by ∆F's scan process when it sees £ or `L. 
⍝   ∘ Called from the main scan routines CF_SF and CF_Esc. 
⍝   ∘ In turn calls fn LoadObj when a library name, nm, is being referenced 
⍝     (not set) for the first time.
⍝ Task:
⍝ ∘ find the name string nm in £.nm...[[∘]←] and, if valid and not seen before,
⍝   ∘ (via LoadObj) get source code for it from a file or workspace in our path.
⍝ ∘ Does NOT affect the string ⍵ being scanned. 
⍝ ∘ Is only used for its ⎕CY or ⎕FIX side effect via LoadObj. 
⍝ Note: A name may be in the library w/o having been loaded, e.g. if it's
⍝   in a file with multiple objects (all may be loaded). So we add ANY valid 
⍝   name to the cache, once we see it. (We don't cache invalid names).

  LibAuto←{           
        lib← libUserNmP                               ⍝ Return libUserNmP no matter what!
    ~⍺.auto: lib                                      ⍝ Not auto: return.
        w← (+/∧\' '= ⍵)↓ ⍵                            ⍝     Skip blanks
    '.'≠ ⊃w: lib                                      ⍝ No initial '.':   return.
        w← (+/∧\' '=w)↓ w← 1↓w                        ⍝     Skip some more blanks,
        nm← (p← ⌊/ w⍳ '←∘ ')↑ w                       ⍝     Get the name. 
    (⊂nm)∊ ⍺.acache: lib                              ⍝ Saw it before:    return.
    ¯1=nc← libUser.⎕NC nm: lib                        ⍝ Invalid name:     return.
        ⍺.acache,← ⊂nm                                ⍝     Mark as seen in autocache global.
    0≠ nc: lib                                        ⍝ In libuser:       return. 
    '←'= ⊃(p↓w)~'∘ ': lib                             ⍝ Name to be set:   return.
        lib⊣ libUser ⍺ parms LoadObj nm              ⍝     Try to load obj def, then return.                                       
  }
  
  ⍝ ======================================================================================
  ⍝ LoadObj: Find nm in £.nm or `L.nm and try to load its definition into libUser from path.
  ⍝     (1|0)@B← libUser@ns verbose@B parms@ns ∇ nm@CVS 
  ⍝ Find <nm> in search directories (parms.path) and dfns workspace, according to parameters <parms>.
  ⍝ Called by ⍙Auto (above).
  ⍝    (1|0)← libUser verbose parms ∇ nm 
  ⍝ Returns SHY 1 (succ) or SHY 0 (fail), having established <nm> in libUser (ns) on success.
  LoadObj← { 
  ⍝ LoadObj utilities, followed by the executive...

    ⍝ SubScanFiles:    
    ⍝  ∇ files
    ⍝  extern: nm 
    ⍝ Search a list of full filenames <files> ending in simple name <nm> (before suffixes).
    ⍝ If a) it finds such a file
    ⍝    b) the ⎕FIX succeeds, and
    ⍝    c) the name ⍺ is among the names returned in the ⎕FIX, 
    ⍝ then it returns:
    ⍝    success: 1 ('file:', fi).
    ⍝ Otherwise, returns: rcNF (not found).
    ⍝ Notes:
    ⍝ ∘ The nameclass distinctions, based on suffixes, are currently NOT enforced for
    ⍝   the first three suffixes, but it's trivial to do.
    ⍝ ∘ When ⎕FIX is applied to the file found, <nm> must be among the names listed
    ⍝   as ⎕FIXed or an error (rcEN) is reported.
    ⍝ ∘ Other errors reported as rcER. 
      SubScanFiles← {   
        0= ≢⍵: rcNF ⍬ ⋄ 11 22:: rcER ⍬⊣ errSig⊢←⎕DMX 
        fi← ⊃⍵       
        ~⎕NEXISTS fi: ∇ 1↓⍵ 
        FixByType← { 
          sfx← ⊃⌽⎕NPARTS fi← ⍵  
          ⍝ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed.  
          '.aplf' '.aplo' '.apln'∊⍨ ⊂sfx: rcEN rcOK⊃⍨ (⊂nm)∊ 2 libUser.⎕FIX _FxOpts errFi⊢←fi 
          '.apla'≡ sfx: rcOK⊣ libUser ##.∆VSET ⊂nm (##.AN2Apl ⊃⎕NGET fi 1) 
          '.txt' ≡ sfx: rcOK⊣ libUser ##.∆VSET ⊂nm (⊃⎕NGET fi 1)                                     
          '.json'≡ sfx: rcOK⊣ libUser ##.∆VSET ⊂nm (⎕JSON _JOpts ⊃⎕NGET fi 0)  
          ⍝ All other suffixes, including .dyalog or a user-defined suffix.
          ⍝ When ⎕FIX is applied to ¨fi¨, ¨nm¨ must be among the names listed as ⎕FIXed. 
            rcEN rcOK⊃⍨ (⊂nm)∊ 2 libUser.⎕FIX _FxOpts errFi⊢← fi            
        }
        0≤ rc← FixByType fi: rc ('file:',fi) ⋄ rc ⍬ 
      } 
      _FxOpts← ⍠('FixWithErrors' 0)('Quiet' 1)    
      _JOpts← ⍠('Dialect' 'JSON5')('Compact' 0)('Null' ⎕NULL)     

    ⍝ SubScanWS:     
    ⍝ ret← path ∇ subpath
    ⍝    path:       ScanPath's current (outer) path 
    ⍝    subp:       the list of workspaces
    ⍝ extern: nm:  name to find     
    ⍝ ∘ May call ScanPath to recursively "return" to scanning the outer ¨path¨.   
    ⍝ Returns: 
    ⍝   a) (retcode ('ws:', wsname)), where retcode∊rcOK, rcNF, rcER, or
    ⍝   b) Returns result from recursive call to ScanPath
      SubScanWS← { path subp← ⍺ ⍵
        0=≢subp: ScanPath 1↓path 
        ⍝ FixFromWS: If nm is in workspace ⊃subP, copy it. Otherwise, keep looking.
          FixFromWS← { 11:: rcNF ⍬ ⋄ rcOK ('ws:',⍵)⊣ ⍺ libUser.⎕CY ⍵ }
          ret← nm FixFromWS ⊃subp
        rcNF≠⊃ret: ret ⋄ path ∇ 1↓subp 
      }

    ⍝ ScanPath:
    ⍝ rcOK@B where@S← ∇ path@NsV 
    ⍝ extern: nm  
    ⍝ Recursively scan the path for name ⍵ in each file or wsid 
    ⍝ spec in parms._fullPath   
    ⍝ ∘ If we see a array (with a single string), it's a workspace: 
    ⍝   call and return result from SubScanWS
    ⍝ ∘ Otherwise, 
    ⍝   call and return result from SubScanFiles
      ScanPath← {  
        0= ≢⍵: rcNF ⍬ ⋄ path← ⍵ ⋄ cur← ⊃path
        ⍝ If cur is a vector of (0 or more) char vectors, each is assumed to be a workspace id.
        ⍝ When done, having returned rcNF, recursively continue ScanPath.
        ⍝ Otherwise (rcOK or rcER), return from ScanPath.
        1< |≡cur: path SubScanWS cur                   ⍝ If VCV, => at least 1 workspace.        
          ff← ,(⊂cur)∘.,(⊂nm,'.')∘.,parms.suffix       ⍝ cur is a CV. Generate ff, list of files.  
        rcNF≠⊃ret← SubScanFiles ff: ret 
          ∇ 1↓path                       
      }

    ⍝ Cleanup: Show optional action, then return.
    ⍝ rc← rc verbose dest ∇ srcFi destNs  
    ⍝ extern: nm 
    ⍝ 
    ⍝ If (~v), exit quietly, even if an error occur that we've anticpated.
    ⍝ Otherwise, simply print the errors and then continue normally.
    ⍝ This way, the user can trap errors relating to the missing objects. 
    ⍝ If you want errors to be ⎕SIGNALED, set signalOnErr← 1 at Executive
      Cleanup←  { rc v libE← ⍺ 
       (~v)∧rc=rcOK: rc ⋄ (srcFi dest)← ⍵  
        Ê← { en message← ⍵ 
          libE: ⎕SIGNAL ⊂('EN' en) ('Message' message) 
          v: 0⊣ ⎕← ('∆F ',⎕EM en),': ',message 
          0
        }
      rc=rcOK: rc⊣ ⎕← '∆F: Copied "', nm, '" into £ibrary',(0≠ ≢srcFi)/ ' from ','"',srcFi,'"'
      rc=rcNF: rc⊣ Ê 11 ('Object "',nm,'" not found on search path')   
      rc=rcEN: rc⊣ Ê 11 ('Obj "',nm,'" not present in file "',srcFi,'"') 
               errSig.m1← 'Error loading "',nm,'" into library '
               rc⊣ Ê errSig.(EN (m1,'(',Message,')'))
      }

      errSig← ⍬    ⍝ Used in Cleanup only...
      errFi←''     ⍝ Used in Cleanup only...

    ⍝ Executive for LoadObj 
      libUser ê parms←⍺ 
    ⍝ extern: nm                    ⍝ Used in routines ScanPath & descendants and Cleanup.
      nm← ⍵                         
      ⍝ rcEN: The file loaded ok, but nm wasn't in the loaded file.
      rcOK rcNF rcER rcEN← 1 0 ¯1 ¯2    ⍝ Return codes: OK, Not Found, Error
      rc where← ScanPath parms._fullPath 
    1: _← rc (ê.verbose ∨ parms.verbose) ##.LIB_ERRORS Cleanup where libUser  
  } ⍝ End LoadObj 
  
⍝ ============================================================================
⍝ LoadParmDefaults: Load-time routine
⍝   Sets parameters 
⍝        ⍵.load, ⍵.auto, ⍵.verbose, ⍵.path, ⍵.prefix, ⍵.suffix, etc.
⍝   ⍵.load defaults to ##.AUTOLOAD (which must be 1 or 0).
⍝   If ⍵.load is set to 1 in the .∆F file, then the .∆F file is loaded.
⍝   If not,
⍝       then no more processing is done and Auto does nothing except return libUserNm (lib ns name).
⍝   If ⍵.path←⍬, no files or workspaces are checked. If ⍵.suffix←⍬, only w/ss might be checked.  
  LoadParmDefaults← { 
    ⍝ These are the default APL Array Notation settings: format ok whether Dyalog 20 or earlier.
    ⍝ User can override in ./.∆F, also in APLAN format. 
      ParmDefaults← { 
         (
          ⍝ Default .∆F Parameter File  (APL Array Notation)                          
          ⍝ Items not to be (re)set by user may be omitted/commented out.              
          ⍝ If (load: ⎕NULL), then LIB_AUTO [note 1] is used for load.
          ⍝ If (verbose: ⎕NULL), then VERBOSE [note 1] is used for verbose.
          ⍝ If (prefix: ⎕NULL) or (prefix: ⍬), then (prefix: '' ⋄)     
          ⍝ [note 1] 
          ⍝   ∆F global variables LIB_AUTO and VERBOSE are set in ∆Fapl.dyalog.
          ⍝    Their usual values are LIB_AUTO← 1 ⋄ VERBOSE← 0
          ⍝    See load: and verbose: below for significance.
  
          ⍝ load:
          ⍝   1:     Load the runtime path to search for Session Library £ and `L.
          ⍝   0:     Don't load...
          ⍝   ⎕NULL: Grab value from LIB_AUTO above.
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
            path:  ( 'MyDyalogLib' ⋄ ('dfns'⋄) ⋄ '.' ⋄ )  
                          
          ⍝ prefix: literal string to prefix to each name, when searching directories.
          ⍝     Ignored for workspaces.
          ⍝     ⍬ is equiv. to  ''. 
          ⍝     Example given name 'mydfn' and (prefix: '∆F_' 'MyLib/' ⋄ suffix: ⊂'aplf')  
          ⍝     ==> ('∆F_mydfn.aplf'  'MyLib/mydfn.aplf')   
            prefix: ⍬ 
                                      
          ⍝ suffix: at least one suffix is required. The '.' is prepended for you!  
          ⍝    Not applicable to workspaces. See documentation for definitions.
          ⍝    By default, unknown filetypes are not enabled. 
          ⍝    Generally, place most used definitions first.
            suffix: ('aplf' ⋄ 'apla' ⋄ 'aplo' ⋄ 'apln' ⋄ 'json'⋄ 'txt' ⋄'dyalog')    
                          
          ⍝  Internal Runtime (hidden) Parameters                                               
            _readParmFi: 0                      ⍝ 0 Zero: Haven't read .∆F yet. 1 afterwards.     
            _fullPath:   ⍬                      ⍝ ⍬ Zilde: Generated from path and prefixes.
            _debug:      0                      ⍝ Synonym for verbose (internally)
         )                                                                               
      }
    0::   ##.AN2Apl 1↓¯1↓ ⎕NR'ParmDefaults'         ⍝ Dyalog ≤19
      ParmDefaults ⍬                                ⍝ Dyalog ≥20
  }

⍝ LoadParmFi: Loadtime routine
⍝ Loads parameter file ⍵ (if it exists) into namespace ⍺
⍝ Note default parameters for special cases (sc) below
  LoadParmFi← { 
      parmFi← ⍵  
    ⍝ ReadParmFi: Update parameters from parm file.
      ReadParmFi← { 
        ~⎕NEXISTS ⍵: ⍬ ⋄ 11:: 0⊣ 11 ⎕SIGNAL⍨ ⎕← ParseÊ ⍵ 
          _← 'parms' ⎕NS ##.AN2Apl ⊃⎕NGET ⍵ 1      ⍝ Merge parm file into internal defaults
          0⊣ parms._readParmFi← 1 
      } 
      ParseÊ← {  
         e1← '∆F: ∆F Load Error: Unable to parse parameter file "',⍵,'".'
         e2← '∆F: ∆F Load Error: Array Notation or parameters may be invalid.'
         e1, (⎕UCS 13), e2     
      }  
    ⍝ GenFullPath:   _parms._fullPath← ∇ parms.path 
      GenFullPath← {
          ⍺←⍬ ⋄ 0=≢⍵: ⍺ ⋄ p← ⊂⊃⍵ 
        2<|≡p: (⍺, p) ∇ 1↓⍵                                         ⍝ workspace
          (⍺, ,p∘., '/'∘.,parms.prefix) ∇ 1↓⍵                       ⍝ file 
      } 
    ⍝ =========================================================================
    ⍝ LoadParmFi main ...
      _← ReadParmFi parmFi  
    ⍝ Handle special-case parameters (⊃¨scp): verbose, load, ..., suffix 
      sc←  ('verbose' ##.VERBOSE) ('load' ##.LIB_AUTO) ('prefix'(,⊂'')) 
      sc,← ('auto' 0)             ('path' ⍬)           ('suffix' ⍬)
    ⍝ If any parm in (⊃¨sc) has value ⎕NULL or ⍬, 
    ⍝ it is replaced by its default shown here in (⊃∘⌽¨sc)
        Val←    parms.⎕OR∘⊃
        IsNull← ⍬∘≡∨⎕NULL∘≡
      _← parms ##.∆VSET sc/⍨ IsNull∘Val¨ sc
    ~parms.load: _← 0⊣ ⎕FX ,⊂'Auto←{libUserNm}'⊣ parms.auto←0  ⍝ auto=0: Auto => nop.
      parms._fullPath← GenFullPath parms.path 
      
    ⍝ If parms._fullPath is not empty, we're done!
    0< ≢parms._fullPath: _← 1 
    ⍝ If parms._fullPath is empty, then turn auto off, since there's nothing to load.
      nolibW← '!!! Warning:  (load: 1) but the search path is empty!'
      _← 0⊣ ⎕FX ,⊂'Auto←{libUserNm}'⊣ parms.auto← 0⊣ (⎕∘←)⍣parms.verbose⊣nolibW       
  } 
  ⍝ _CShow: 
  ⍝ ∘ Cond'lly show all APLAN parameters in 'parms' in alph order 
  ⍝   (⍺⍺=1) compactly, else (⍺⍺=0) multiline.
  ⍝   EXCEPT internal ones starting with '_'
  ⍝ ∘ If ⍺=1, force a display, even if parms.verbose=0.
  ⍝ ∘ Returns: a matrix of parms or (1 0⍴'')
  _CShow← { ⍺←0 ⋄ 0:: 1 0⍴⎕←'∆F: ∆F Load: Error displaying runtime parameters'
    (~⍺)∧~⍵.verbose: _← 1 0⍴''  
      _← ⊂'Library Runtime Parameters (default + user-set):'⊣ ⎕PW← 200
    1: _← ↑⍺⍺ ##.Apl2AN ⍵.(⎕NS {⍵/⍨ '_'≠⊃¨⍵} ⎕NL -2) 
  } 

⍝ ShowPath:  Called via 'path' call in ##.Special. 
  ShowPath← { ⊃1 ##.Apl2AN parms._fullPath } 

⍝ Load user parms
⍝     Load builtin parms? If loadDefaults=1 or 'parms' doesn't yet exist.
⍝     Load user parms?    If loadUserFi=1.
⍝     Show parms?         If isVerbose=1 or if parms.verbose=1
⍝     Show compactly?     If isCompact=1;
⍝ Used at EXECUTIVE below and via 'parms' call in ##.Special.
  ∇ {rc}← LoadParms (loadDefaults loadUserFi isVerbose isCompact)   
    :If  0=⎕NC 'parms'  
    :OrIf loadDefaults 
        'parms' ⎕NS LoadParmDefaults ⍬  
    :EndIf 
    :If loadUserFi 
        LoadParmFi './.∆F'  
    :EndIf               
    rc← isVerbose (isCompact _CShow) parms 
  ∇
⍝   LibUserFull: Point to (empty, but named) user library at load-time.
⍝      actual ref: ##.library, local ref (alias): libUser, local name: libUserNm.
⍝ external: 
⍝      libUser, libUserNm, Auto, parms, ShowPath, LoadParms   ⍝ loaded here...
  ∇ {libNs}← LibUserFull libNs
    ⍝ external: libUserNm libUser 
    libNs.⎕DF ⎕NULL                      ⍝ In case set...
    libUserNmP← '(',')',⍨ libUserNm← ⍕libUser← libNs 
    libUser.⎕DF '£=[',libUserNm,']'
  ∇

⍝ =========================================================================
⍝ EXECUTIVE
  LibUserFull ##.library
  LoadParms 1 1 0 0 
:EndNamespace   ⍝ libUtil
