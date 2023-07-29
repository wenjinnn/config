" auto positioning to last edit position when open file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
" auto save buffer
au BufLeave * if &readonly==0 && filereadable(bufname('%')) | silent update | endif
" auto vimdiff wrap
au VimEnter * if &diff | execute 'windo set wrap' | endif
" nvim-dap repl completion
au FileType dap-repl lua require('dap.ext.autocompl').attach()
au FileType dap-float nnoremap <buffer> <silent> q <cmd>quit<CR>

" Auto generate tags file on file write of ctags supported languages file,
" Languages Supported by Exuberant Ctags: http://ctags.sourceforge.net/languages.html
" if executable('ctags') && getcwd() != getenv('HOME')
"     au BufWritePost,QuitPre *.c,*.h,*.asp,*.awk,*.cpp,*.cs,*.html,*.java,*.js,*.lua,makefile,*.sql,*.py,*.vim,*.yml,*.json,*.ts,*.go,*.properties,*.lisp silent! !ctags
" endif
autocmd User TelescopePreviewerLoaded setlocal wrap
autocmd User TelescopePreviewerLoaded setlocal number

" firenvim setting
function! s:IsFirenvimActive(event) abort
  if !exists('*nvim_get_chan_info')
    return 0
  endif
  let l:ui = nvim_get_chan_info(a:event.chan)
  return has_key(l:ui, 'client') && has_key(l:ui.client, 'name') &&
      \ l:ui.client.name =~? 'Firenvim'
endfunction

function! OnUIEnter(event) abort
  if s:IsFirenvimActive(a:event)
    " for 4k screen display
    " set guifont=FiraCode_Nerd_Font_Mono:h20
    " disable auto session
    let g:auto_session_enabled = v:false
  endif
endfunction
autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
