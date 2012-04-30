" ingocollections.vim: Custom utility functions for collections. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	003	17-Jun-2011	Add ingocollections#isort(). 
"	002	11-Jun-2011	Add ingocollections#SplitKeepSeparators(). 
"	001	08-Oct-2010	file creation

function! ingocollections#unique( list )
    let l:itemHash = {}
    for l:item in a:list
	let l:itemHash[l:item] = 1
    endfor
    return keys(l:itemHash)
endfunction 

function! s:add( list, expr, keepempty )
    if ! a:keepempty && empty(a:expr)
	return
    endif
    return add(a:list, a:expr)
endfunction
function! ingocollections#SplitKeepSeparators( expr, pattern, ... )
"******************************************************************************
"* PURPOSE:
"   Like the built-in |split()|, but keep the separators matched by a:pattern as
"   individual items in the result. Also supports zero-width separators like
"   \zs. (Though for an unconditional zero-width match, this special function
"   would not provide anything that split() doesn't yet provide.) 
"
"* ASSUMPTIONS / PRECONDITIONS:
"   None. 
"* EFFECTS / POSTCONDITIONS:
"   None. 
"* INPUTS:
"   a:expr	Text to be split. 
"   a:pattern	Regular expression that specifies the separator text that
"		delimits the items. 
"   a:keepempty	When the first or last item is empty it is omitted, unless the
"		{keepempty} argument is given and it's non-zero.
"		Other empty items are kept when {pattern} matches at least one
"		character or when {keepempty} is non-zero.
"* RETURN VALUES: 
"   List of items. 
"******************************************************************************
    let l:keepempty = (a:0 ? a:1 : 0)
    let l:prevIndex = 0
    let l:index = 0
    let l:separator = ''
    let l:items = []

    while ! empty(a:expr)
	let l:index = match(a:expr, a:pattern, l:prevIndex)
	if l:index == -1
	    call s:add(l:items, strpart(a:expr, l:prevIndex), l:keepempty)
	    break
	endif
	let l:item = strpart(a:expr, l:prevIndex, (l:index - l:prevIndex))
	call s:add(l:items, l:item, (l:keepempty || ! empty(l:separator)))

	let l:prevIndex = matchend(a:expr, a:pattern, l:prevIndex)
	let l:separator = strpart(a:expr, l:index, (l:prevIndex - l:index))

	if empty(l:item) && empty(l:separator)
	    " We have a zero-width separator; consume at least one character to
	    " avoid the endless loop. 
	    let l:prevIndex = matchend(a:expr, '\_.', l:index)
	    if l:prevIndex == -1
		break
	    endif
	    call add(l:items, strpart(a:expr, l:index, (l:prevIndex - l:index)))
	else
	    call s:add(l:items, l:separator, l:keepempty)
	endif
    endwhile

    return l:items
endfunction

function! ingocollections#isort(i1, i2)
"******************************************************************************
"* PURPOSE:
"   Case-insensitive sort function for strings; lowercase comes before
"   uppercase. 
"* ASSUMPTIONS / PRECONDITIONS:
"   None. 
"* EFFECTS / POSTCONDITIONS:
"   None. 
"* INPUTS:
"   i1, i2  Strings. 
"* RETURN VALUES: 
"   -1, 0 or 1, as specified by the sort() function. 
"******************************************************************************
    if a:i1 ==# a:i2
	return 0
    elseif a:i1 ==? a:i2
	" If only differ in case, choose lowercase before uppercase. 
	return a:i1 < a:i2 ? 1 : -1
    else
	" ASCII-ascending while ignoring case. 
	return tolower(a:i1) > tolower(a:i2) ? 1 : -1
    endif
endfunction 

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
