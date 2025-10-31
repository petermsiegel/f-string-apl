:Namespace ⍙FLoader 

∇ msg← Load (what where) ; ns
   ns← ⎕SE.SALT.Load what,' -t=',⍕where
  :IF 9=⎕NC 'ns' ⋄ :AndIf 3=ns.##.⎕NC '∆F'
      msg← ⎕← 'Loaded ',what,' into ',(⍕where),' as ',(⍕ns),' and ',(⍕ns.##),'.∆F'
  :EndIf 
∇
 Load '∆F/∆Fapl' ⎕THIS.##

:EndNamespace 

