" Vim syntax file
" Language      ari description files

if exists("b:current_syntax")
  finish
endif

syn include @vhd $VIMRUNTIME/syntax/vhdl.vim
unlet b:current_syntax
syn include @cpp $VIMRUNTIME/syntax/cpp.vim
unlet b:current_syntax
syn include @ruby $VIMRUNTIME/syntax/ruby.vim
unlet b:current_syntax
syn include @python $VIMRUNTIME/syntax/python.vim

syn keyword cKeyword hierarchy info end port generic signal constant xrfp xrf
syn keyword cKeyword assign from library configuration architecture component
syn keyword cKeyword remove_package add_package move_package exec post_exec
syn keyword cKeyword in out inout auto assign rename_ports group_comment
syn keyword cKeyword port_comment keep_case language add_header move_header
syn keyword cKeyword create sc_method sc_thread config_in_arch entity_comment
syn keyword cKeyword arch_comment inst_comment remove_header

syn match cComment "--.*$"

syn region cStatements matchgroup=cTodo start="statements\s*$" end="end\s*statements" contains=@vhd
syn region cDeclarations matchgroup=cTodo start="declarations\s*$" end="end\s*declarations" contains=@vhd
syn region cDeclarationsTop matchgroup=cTodo start="declarationstop\s*$" end="end\s*declarationstop" contains=@vhd
syn region cCreate matchgroup=cTodo start="create \k\+\s*$" end="end\s*create" contains=@cpp
syn region cRuby matchgroup=cTodo start="ruby\s*$" end="end\s*ruby" contains=@ruby
syn region cRuby matchgroup=cTodo start="ruby_post\s*$" end="end\s*ruby" contains=@ruby
syn region cPython matchgroup=cTodo start="^\s*\zspython\s*$" end="^\s*\zsend\s*python" contains=@python
syn region cPythonPost matchgroup=cTodo start="^\s*\zspython_post\s*$" end="^\s*\zsend\s*python" contains=@python

if version >= 508 || !exists("did_ari_syntax_inits")
  if version < 508
    let did_ari_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cKeyword Statement
  HiLink cComment Comment
  HiLink cTodo Todo

  delcommand HiLink
endif

let b:current_syntax = "ari"
