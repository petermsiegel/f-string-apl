:Namespace ⍙FLoader 

∇ msg← Load (what where) ; ns; whS
   whS← ⍕where
   ns← ⎕SE.SALT.Load what,' -t=',whS 
  :IF 9=⎕NC 'ns' ⋄ :AndIf 3=ns.##.⎕NC '∆F'
      msg← ⎕← 'Loaded ',what,' into ',whS,' as ',(⍕ns),' and ',(⍕ns.##),'.∆F'
  :EndIf 
  :If ~(' ',whS,' ')(~(1∘∊⍷))' ',⎕PATH,' '
      ⎕PATH,← ' ',whS 
  :EndIf   
∇
 Load '∆F/∆Fapl' ⎕THIS.##

:EndNamespace 

