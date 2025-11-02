:Namespace ⍙Floader
⍝ ∆F Utility and Library Loader...
⍝ Note: This namespace can be safely expunged after loading.
  ⎕IO ⎕ML← 0 1 
  ∇ msg← Load (what where) ; ns 
    :Trap 22 
      ns← ⎕SE.SALT.Load what,' -t=',where
      :IF 9=⎕NC 'ns' ⋄ :AndIf 3=ns.##.⎕NC '∆F'
          msg← '>>> Loaded fn "∆F" into ',where,' with library (ns) "','"',⍨ ⍕ns 
      :Else 
          msg← '!!! Load failed to load "',what,'" into target ns "','"',⍨ where
      :EndIf 
      :If (~(1∘∊⍷))/ ' ',¨' ',⍨¨where ⎕PATH     ⍝ Append (⍕where) ⎕PATH if not already in ⎕PATH
          ⎕PATH,← where,⍨ ' '/⍨ 0≠≢ ⎕PATH 
      :EndIf 
    :Else
       msg← '!!! Load failed: Can''t find "',what,'" or its components!'
    :EndTrap 
  ∇
  ⎕← Load '∆F/∆Fapl' (⍕⎕THIS.##)
:EndNamespace 
