:Namespace  
⍝ ∆F Utility and Library Loader...
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the target namespace, 
⍝ while it loads (ns) ⍙Fapl and (file) ∆F via ]load ∆F. 

  ADD_∆F_TO_PATH← 1                                        ⍝ If 1, adds ∆F to ⎕PATH.

  ∇ {rc}← Load (what where)  
    ⎕DF ∊'.∆F + ' '.⍙Fapl',⍨¨ ⊂⍕where                      ⍝ The return value from ⎕FIX or ]LOAD
    rc← 0 
    :Trap 0 
        :If ~⎕NEXISTS what
            Err22 what ⋄ ErrAll where ⋄ :Return   
        :EndIf 
        where.⎕FIX⍠'FixWithErrors' 0⊢ 'file://',what                        
        :If 9 3∨.≠ where.⎕NC↑ '⍙Fapl' '∆F'                 ⍝ Sanity check.  
            ErrAll where ⋄ :Return   
        :EndIf 
        where.⍙Fapl.VERBOSE CGood where 
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
  ErrAll← { 1: ⎕← '!!! Load error: Could not create fn="',⍵,'.∆F" and/or ns="',⍵,'.⍙Fapl"'}⍕
  ∆SE← '(?i)⎕se' ⎕R '⎕SE' 
  PathAdd← {s←' ' ⋄ (1∊⍷)/ s,¨s,⍨¨⍵ ⍺: '' ⋄ 0=≢ ⍺: ⍵ ⋄ s, ⍵ }⍥∆SE
  CGood←   {⍺: ⎕←'>>> Created fn="',⍵,'.∆F" and ns="',⍵,'.⍙Fapl"' ⋄ 1: _←0 }
  ⎕IO ⎕ML ⎕PW← 0 1 120 
  
  Load '∆F/∆Fapl.dyalog' ⎕THIS.## 
:EndNamespace 
