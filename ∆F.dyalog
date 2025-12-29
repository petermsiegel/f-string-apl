:Namespace  
⍝ ∆F Utility and Library Loader...
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the target namespace, 
⍝ while it loads (ns) ⍙FUtils and (file) ∆F via ]load ∆F. 

  ADD_∆F_TO_PATH← 1                                        ⍝ If 1, adds ∆F to ⎕PATH.
  VERSION← '0.1.1'

  ∇ {rc}← ⍙Load (what where); w   
  ⍝ ⎕DF value is returned by ⎕FIX or ]LOAD
    w← ⍕where 
    ⎕DF w,'.∆F (library: ''',w,'.⍙FUtils'' ⋄ version: ''', VERSION,''')'
    rc← 0 
    :Trap 0 
        :If ~⎕NEXISTS what
            Err22 what ⋄ ErrAll where ⋄ :Return   
        :EndIf 
        where.⎕FIX⍠'FixWithErrors' 0⊢ 'file://',what                        
        :If 9 3∨.≠ where.⎕NC↑ '⍙FUtils' '∆F'                 ⍝ Sanity check.  
            ErrAll where ⋄ :Return   
        :EndIf 
        where.⍙FUtils.VERBOSE CGood ⍕where 
        :If ADD_∆F_TO_PATH 
            ⎕PATH,← ⎕PATH PathAdd ⍕where 
        :EndIf 
        rc← 1  
    :Else
        ErrApl ⎕DMX ⋄ ErrAll where ⋄ :Return 
    :EndTrap 
  ∇
  Err22←  { 1: ⎕←'!!! Load error: file "',⍵,'" does not exist!'}
  ErrApl← { 1: ⎕←'!!! APL ',⍵.EM,': ',d1↑⍨ ' '⍳⍨ d1← 1⊃⍵.DM }
  ErrAll← { 1: ⎕← '!!! Load error: Could not create fn="',⍵,'.∆F" and/or ns="',⍵,'.⍙FUtils"'}⍕
  ∆SE← '(?i)⎕se' ⎕R '⎕SE' 
  PathAdd← {s←' ' ⋄ (1∊⍷)/ s,¨s,⍨¨⍵ ⍺: '' ⋄ 0=≢ ⍺: ⍵ ⋄ s, ⍵ }⍥∆SE
  CGood←   {⍺: ⎕←'>>> Created namespace "',⍵,'.⍙FUtils"' ⋄ 1: _←0 }
  ⎕IO ⎕ML ⎕PW← 0 1 120 
  
  ⍙Load '∆F/∆FUtils.dyalog' ⎕THIS.## 
:EndNamespace 
