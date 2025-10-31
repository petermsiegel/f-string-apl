:Namespace ∆F_Loader 
∇ msg← Load (what where) ; nm
  nm← ⎕SE.UCMD 'load ',what,' -t=',where
  msg← ⎕← 'Loaded ',what,' into ',where,' as ',⍕nm
∇

 Load '∆F/∆Fapl' '⎕SE'
 
:EndNamespace 
  
