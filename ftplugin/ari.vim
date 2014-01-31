if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

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

function! JumpUpOneLevelAri()
  let file_name =  expand("%:p")
  let hierarchy_line = system("grep hierarchy " . file_name)
  let hierarchy_words = split(hierarchy_line, ' ')
  if len(hierarchy_words) == 2
    let entity_with_enter = get(hierarchy_words, 1)
    let entity = get(split(entity_with_enter, "\n"), 0)
  else
    echo "no entity found, is this a ariadne file?"
    return
  endif
  let file_output = system("find -L $DESIGN_WORK_DIR -name \"*.ari\" -type f | xargs grep -l \"info " . entity . "\"")
  let file_list = split(file_output, '\n')
  call filter(file_list, 'v:val !~ file_name')
  echo file_name
  echo file_list
  if len(file_list) == 1
    let thefile = get(file_list, 0)
  else
    let i = 0
    while i < len(file_list)
      let i += 1
      let projectfile = substitute(get(file_list, i - 1),expand("$DESIGN_WORK_DIR")."/", "", "g")
      echo i . " : " . projectfile
    endwhile
    let makeid = input('Enter line of prefered input: ')
    let thefile = get(file_list,  makeid-1)
  endif
  exec "e ". thefile
endfunction


