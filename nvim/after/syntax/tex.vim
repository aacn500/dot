" https://tex.stackexchange.com/a/175286
"
syn match texRefZone '\\citeauthor\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite
syn match texRefZone '\\parencite\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite
syn match texRefZone '\\textcite\%([tp]\*\=\)\=' nextgroup=texRefOption,texCite

syn match texAutoref '\\autoref{[^}]\{-}}'hs=s+9,he=e-1 containedin=texStatement contains=@NoSpell
