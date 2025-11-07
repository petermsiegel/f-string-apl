:Namespace  
⍝ ∆F Utility and Library Loader...
⍝ Note: This is an UNNAMED namespace, so its name won't clutter the target namespace, 
⍝ while it loads (ns) ⍙Fapl and (file) ∆F via ]load ∆F. 
  ∇ {rc}← Load (what where) ; CheckPath; CGood; Err11; Err22
    CheckPath← #.⎕PATH∘{s←' ' ⋄ (1∊⍷)/ s,¨s,⍨¨⍵ ⍺: '' ⋄ 0=≢ ⍺: ⍵ ⋄ s, ⍵ }∘⍕
    CGood← {⍺: ⎕←'>>> Created fn="',⍵,'.∆F" and ns="',⍵,'.⍙Fapl"' ⋄ 1: _←0 }
    Err11← {1: ⎕←↑3⍴⊂'!!! Load error: Could not create fn="',⍵,'.∆F" and/or ns="',⍵,'.⍙Fapl"'}∘⍕ 
    Err22← {1: ⎕←↑3⍴⊂'!!! Load error: Could not create fn="',⍵,'.∆F" and/or ns="',⍵,'.⍙Fapl"'}∘⍕

    ⎕DF ∊'.∆F + ' '.⍙Fapl',⍨¨ ⊂⍕where                     ⍝ The return value from ⎕FIX or ]LOAD
    :Trap 11 22 
        where.⎕FIX 'file://',what                          
        :If 9 3∨.≠ where.⎕NC↑ '⍙Fapl' '∆F'                 ⍝ Sanity check.  
            Err11 where ⋄ :Return 
        :EndIf 
        where.⍙Fapl.VERBOSE CGood where 
        #.⎕PATH,← CheckPath where 
        rc← 1  
    :Case 11 ⋄ Err11 where
    :Case 22 ⋄ Err22 where 
    :EndTrap 
  ∇
  ⎕IO ⎕ML ⎕PW← 0 1 120 
  Load '∆F/∆Fapl.dyalog' ⎕THIS.## 
:EndNamespace 
