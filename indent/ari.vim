
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetARIIndent()
setlocal indentkeys=!^F,o,O,0),0},=~end

"if exists("*GetARIIndent")
"  finish
"endif

function! GetARIIndent()

  let offset = &sw

  let lnum = prevnonblank(v:lnum - 1)
  "let lnum = prevnonblank(14)
  let last_line = RemoveVhdlComment(getline(lnum))
  while strlen(last_line) == 0
    if lnum == 0
      return 0
    endif
    let lnum = prevnonblank(lnum - 1)
    let last_line = RemoveVhdlComment(getline(lnum))
  endwhile

  if lnum == 0
    return 0
  endif

  let curr_line = RemoveVhdlComment(getline(v:lnum))
  "let curr_line = RemoveVhdlComment(getline(15))
  let ind = indent(lnum)

  " Indent rules
  if last_line =~ '^\s*\<\(hierarchy\|info\)\>'

  elseif last_line !~ ';\s*$'
    " unterminated line
    let ind = ind + offset
  endif

  " Dedent rules

  if curr_line =~ '^\s*\(\<end\>\|\}\)'
    let ind = ind - offset
  endif

  return ind

endfunction

function! RemoveVhdlComment(line)
  let line = substitute(a:line, "\\s*--.*", "", "")
  return line
endfunction
