" SpellCheck.vim: Work with spelling errors. 
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - SpellCheck/quickfix.vim autoload script. 
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   1.00.003	06-Dec-2011	FIX: Missing :quit in :XitOrSpellCheck. 
"	002	03-Dec-2011	Rename configvar to g:SpellCheck_OnNospell. 
"	001	02-Dec-2011	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_SpellCheck') || (v:version < 700)
    finish
endif
let g:loaded_SpellCheck = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:SpellCheck_OnNospell')
    let g:SpellCheck_OnNospell = function('SpellCheck#AutoEnableSpell')
endif

if ! exists('g:SpellCheck_DefineAuxiliaryCommands')
    let g:SpellCheck_DefineAuxiliaryCommands = 1
endif


"- commands --------------------------------------------------------------------

if g:SpellCheck_DefineAuxiliaryCommands
    command! -bar -bang BDeleteUnlessSpellError     if ! SpellCheck#CheckErrors(0)      | bdelete<bang> | endif
    command! -bar -bang WriteUnlessSpellError       if ! SpellCheck#CheckErrors(0)      | write<bang> | endif
    command! -bar -bang WriteDeleteUnlessSpellError if ! SpellCheck#CheckErrors(0)      | write<bang> | bdelete<bang> | endif
    command! -bar -bang XitUnlessSpellError         if ! SpellCheck#CheckErrors(0)      | write<bang> | quit<bang> | endif

    command! -bar -bang BDeleteOrSpellCheck         if ! SpellCheck#quickfix#List(0, 0) | bdelete<bang> | endif
    command! -bar -bang WriteOrSpellCheck           if ! SpellCheck#quickfix#List(0, 0) | write<bang> | endif
    command! -bar -bang WriteDeleteOrSpellCheck     if ! SpellCheck#quickfix#List(0, 0) | write<bang> | bdelete<bang> | endif
    command! -bar -bang XitOrSpellCheck             if ! SpellCheck#quickfix#List(0, 0) | write<bang> | quit<bang> | endif

    command! -bar -bang UpdateAndSpellCheck         update<bang> | call SpellCheck#quickfix#List(0, 0)
endif

command! -bar -bang SpellCheck  call SpellCheck#quickfix#List(<bang>0, 0)
command! -bar -bang SpellLCheck call SpellCheck#quickfix#List(<bang>0, 1)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
