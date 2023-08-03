" basic settings {{{
let root_path=expand('<sfile>:p:h')
let &runtimepath .= ',' . root_path
let mapleader = "\<space>"
" nocompatible with vi
set nocompatible
filetype on
filetype plugin on
set noeb
syntax enable
syntax on
set t_Co=256
set cmdheight=1
set showcmd
set ruler
set laststatus=2
set number
set cursorline
set whichwrap+=<,>,h,l
set ttimeoutlen=0
set timeoutlen=300
set virtualedit=block,onemore
" ignore filetype when file search
set wildignore+=*/tmp/*,*.so,*.swp,*.png,*.jpg,*.jpeg,*.gif,*.zip,*.rar,*.class,*.jar,*.pyc,*.pyd

" auto positioning to last edit position when open file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif
" auto save buffer when switch
autocmd BufLeave * if &readonly==0 && filereadable(bufname('%')) | silent update | endif
" auto vimdiff wrap
au VimEnter * if &diff | execute 'windo set wrap' | endif

" load vim default plugin
" runtime macros/matchit.vim

" code indent
set autoindent
set cindent
set cinoptions=g0,:0,N-s,(0
set smartindent
filetype indent on
" tabs & space
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set backspace=2
set sidescroll=10
set list
set listchars=tab:>~,space:·,precedes:«,extends:»,trail:·
set undofile
set undodir=~/.vim/undodir
set noshowmode
set wrap
set foldmethod=marker
set foldlevelstart=99
" set relativenumber  
" set mouse=a
" set cursorcolumn
" let g:indentLine_enabled = 1

" code lens
" command line lens menu
set wildmenu
" preview  Show extra information about the currently selected
" completion in the preview window.  Only works in
" combination with "menu" or "menuone".
set completeopt-=preview

" search
set hlsearch
set incsearch
set ignorecase

" buffers
set noswapfile
set autoread
set autowriteall
set confirm

" encodeing
set langmenu=zh_CN.UTF-8
set helplang=cn
set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

" gvim/macvim
if has("gui_running")
    let system = system('uname -s')
    if system == "Darwin\n"
        set guifont=Droid\ Sans\ Mono\ Nerd\ Font\ Complete:h18
    else
        set guifont=DroidSansMono\ Nerd\ Font\ Regular\ 18
    endif
    set guioptions-=m
    set guioptions-=T
    set guioptions-=L
    set guioptions-=r
    set guioptions-=b
    set showtabline=0
    set guicursor=n-v-c:ver5
endif

" uninstall default plug manager
function! s:deregister(repo)
  let repo = substitute(a:repo, '[\/]\+$', '', '')
  let name = fnamemodify(repo, ':t:s?\.git$??')
  call remove(g:plugs, name)
endfunction
command! -nargs=1 -bar UnPlug call s:deregister(<args>)

" }}}

" plugs {{{
call plug#begin('~/.vim/plugged')

Plug 'chxuan/vim-buffer'
Plug 'easymotion/vim-easymotion'
Plug 'bkad/CamelCaseMotion'
Plug 'haya14busa/incsearch.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jreybert/vimagit'
Plug 'junegunn/gv.vim'
Plug 'Shougo/echodoc.vim'
Plug 'rhysd/clever-f.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'joshdick/onedark.vim'
" Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-rooter'
Plug 'alvan/vim-closetag'
Plug 'diepm/vim-rest-console'
Plug 'luochen1990/rainbow'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" Plug 'itchyny/vim-cursorword'
Plug 'lfv89/vim-interestingwords'
Plug 'puremourning/vimspector'
Plug 'voldikss/vim-floaterm'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asyncrun.extra'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'glepnir/dashboard-nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'miyakogi/seiya.vim'
" Plug 'skywind3000/vim-terminal-help'
" Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
" Plug 'ryanoasis/vim-devicons' Icons without colours
" Plug 'akinsho/nvim-bufferline.lua'
  Plug 'scrooloose/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'uzxmx/vim-widgets'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()  
" }}}

" coc extensions {{{
let g:coc_global_extensions = [
      \'coc-json', 
      \'coc-java', 
      \'coc-java-debug',
      \'coc-java-lombok',
      \'coc-java-dependency',
      \'coc-spell-checker',
      \'coc-highlight',
      \'coc-go',
      \'coc-sql',
      \'coc-python',
      \'coc-yaml',
      \'coc-yank',
      \'coc-tsserver',
      \'coc-xml',
      \'coc-sh',
      \'coc-html',
      \'coc-css',
      \'coc-eslint',
      \'coc-prettier',
      \'coc-markdownlint',
      \'coc-rime',
      \'coc-tasks',
      \'coc-db',
      \'coc-snippets',
      \'coc-vimlsp',
      \'coc-ci',
      \'coc-translator',
      \'coc-docker',
      \'coc-tabnine']
" }}}

" theme settings {{{
set background=dark
let g:onedark_termcolors=256
colorscheme onedark
" }}}

" vim key map settings {{{
nnoremap j gj
nnoremap k gk

" open current cursor word help doc
nnoremap <leader>H :execute ":help " . expand("<cword>")<cr>

" plug map
nnoremap <leader><leader>i :PlugInstall<cr>
nnoremap <leader><leader>u :PlugUpdate<cr>
nnoremap <leader><leader>c :PlugClean<cr>

" split windows operators
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" copy to system clipboard
vmap <leader><leader>y "+y

" paste to vim register
nnoremap <leader><leader>p "+p
" }}}

" plug key map & settings {{{

" vimspector
nmap <leader>dc <Plug>VimspectorContinue
nmap <leader>dso <Plug>VimspectorShowOutput
nmap <leader>ds <Plug>VimspectorStop
nmap <leader>dr <Plug>VimspectorRestart
nmap <leader>drr <Plug>VimspectorReset
nmap <leader>dp <Plug>VimspectorPause
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>dcb <Plug>VimspectorToggleConditionalBreakpoint
nmap <leader>dfb <Plug>VimspectorAddFunctionBreakpoint
nmap <leader>dtc <Plug>VimspectorRunToCursor
nmap <leader>do <Plug>VimspectorStepOver
nmap <leader>di <Plug>VimspectorStepInto
nmap <leader>dof <Plug>VimspectorStepOut
" for normal mode - the word under the cursor
nmap <Leader>de <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>de <Plug>VimspectorBalloonEval
let g:vimspector_sidebar_width = 30

" vim-buffer
nnoremap <silent> <c-p> :PreviousBuffer<cr>
nnoremap <silent> <c-n> :NextBuffer<cr>
nnoremap <silent> <leader>x :CloseBuffer<cr>
nnoremap <silent> <leader>X :BufOnly<cr>

" DB
nnoremap <silent> <leader>dd :DBUIToggle<cr>
let g:db_ui_winwidth = 30

" nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<cr>
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1         
let g:NERDTreeShowHidden=1
let g:NERDTreeHighlightFoldersFullName = 1 
let g:NERDTreeDirArrowExpandable='▸'
let g:NERDTreeDirArrowCollapsible='▼'

" nerdtree-git-plugin
let g:NERDTreeGitStatusIndicatorMapCustom = {
            \ "Modified"  : "M",
            \ "Staged"    : "S",
            \ "Untracked" : "U",
            \ "Renamed"   : "R",
            \ "Unmerged"  : "!",
            \ "Deleted"   : "D",
            \ "Dirty"     : "*",
            \ "Clean"     : "C",
            \ 'Ignored'   : 'I',
            \ "Unknown"   : "?"
            \ }

" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" vim-easymotion
map <leader>w <Plug>(easymotion-bd-w)
nmap <leader>w <Plug>(easymotion-overwin-w)

" nvim lightspeed
" unmap s <Plug>Lightspeed_s
" unmap S <Plug>Lightspeed_S
" nmap <leader>s <Plug>Lightspeed_s
" nmap <leader>S <Plug>Lightspeed_S

" fzf & rg
let g:fzf_history_dir = '~/.vim/fzf-history'
nnoremap <leader>f :Files<cr>
nnoremap <leader>t :BTags<cr>
nnoremap <leader>F :Rg<cr>
nnoremap <leader>B :Buffers<cr>
nnoremap <leader>h :History<cr>

" tabular
nnoremap <leader>l :Tab /\|<cr>
nnoremap <leader>= :Tab /=<cr>

" gv
nnoremap <leader>g :GV<cr>
nnoremap <leader>G :GV!<cr>
nnoremap <leader>gg :GV?<cr>

" dashboard.nvim
let g:dashboard_default_executive ='fzf'
let g:dashboard_custom_header = [
\ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
\ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
\ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
\ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
\ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
\ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
\]
nnoremap <silent> <Leader>oh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>of :DashboardFindFile<CR>
nnoremap <silent> <Leader>oc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>ow :DashboardFindWord<CR>
nnoremap <silent> <Leader>ob :DashboardJumpMark<CR>
nnoremap <silent> <Leader>on :DashboardNewFile<CR>
nmap <Leader>os :<C-u>SessionSave<CR>
nmap <Leader>ol :<C-u>SessionLoad<CR>
let g:dashboard_custom_shortcut={
\ 'last_session'       : 'SPC o s',
\ 'find_history'       : 'SPC o h',
\ 'find_file'          : 'SPC o f',
\ 'new_file'           : 'SPC o n',
\ 'change_colorscheme' : 'SPC o c',
\ 'find_word'          : 'SPC o w',
\ 'book_marks'         : 'SPC o b',
\ }

" vim-rooter
let g:rooter_patterns = [
            \'.git', 
            \'.project',
            \'.vim',
            \'go.mod',
            \'src',
            \'Makefile',
            \'*.sln',
            \'build/env.sh',
            \'.svn',
            \'.vscode',
            \'package.json']
let g:rooter_change_directory_for_non_project_files = 'current'

" vim rest console
let g:vrc_auto_format_uhex=1
let g:vrc_allow_get_request_body=1
let g:vrc_curl_opts={
            \   '--include': '',
            \   '--location': '',
            \   '--show-error': '',
            \   '--silent': ''
            \ }
let g:vrc_header_content_type='application/json; charset=utf-8'
let g:vrc_response_default_content_type='application/json'

" airline
let g:airline_theme="onedark"
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#buffer_nr_format = '%s '
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
" let g:airline_left_sep = ''
" let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
" let g:airline_right_alt_sep = ''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" clever-f
map ; <Plug>(clever-f-repeat-forward)
map , <Plug>(clever-f-repeat-back)

" vim-easymotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" map <Leader> <Plug>(easymotion-prefix)

" vim-camelCaseMotion
let g:camelcasemotion_key = '<leader>'
" map <silent> w <Plug>CamelCaseMotion_w
" map <silent> b <Plug>CamelCaseMotion_b
" map <silent> e <Plug>CamelCaseMotion_e
" map <silent> ge <Plug>CamelCaseMotion_ge
" sunmap w
" sunmap b
" sunmap e
" sunmap ge

" floaterm & map exit terminal mode
nmap <Leader>m :FloatermToggle<CR>
tnoremap <nowait> <Leader><Leader>i <c-\><c-n>
tnoremap <nowait> <Leader><Leader>m <c-\><c-n>:FloatermToggle<CR>
tnoremap <nowait> <Leader><Leader>n <c-\><c-n>:FloatermNext<CR>
tnoremap <nowait> <Leader><Leader>p <c-\><c-n>:FloatermPrev<CR>
tnoremap <nowait> <Leader><Leader>c <c-\><c-n>:FloatermNew<CR>
tnoremap <nowait> <Leader><Leader>x <c-\><c-n>:FloatermKill<CR>
let g:floaterm_width = 0.9
let g:floaterm_height = 0.65

"closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.ts'

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\		'tex': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\		},
\		'lisp': {
\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\		},
\		'vim': {
\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\		},
\		'html': {
\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\		},
\		'css': 0,
\	}
\}
" seiya default value: ['ctermbg']
let g:seiya_target_groups = has('nvim') ? ['guibg'] : ['ctermbg']

" echodoc.vim
let g:echodoc_enable_at_startup = 1

" coc.nvim settings 
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
" set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
" set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=200

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>i  <Plug>(coc-format-selected)
nmap <leader>i  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer. 
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent> <space>d  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent> <space>ct  :<C-u>CocList tasks<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>co  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>cs  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" coc translator
nmap <Leader>T <Plug>(coc-translator-p)
vmap <Leader>T <Plug>(coc-translator-pv)
" coc ci
nmap <silent> w <Plug>(coc-ci-w)
nmap <silent> b <Plug>(coc-ci-b)
" coc actions
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@
highlight CocHighlightText  guibg=#3e4452
" }}}


" others {{{
" markdown
" let system = system('uname -s')
" if system == "Darwin\n"
"     let g:mkdp_path_to_chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome"
" else
"     let g:mkdp_path_to_chrome = '/usr/bin/google-chrome-stable %U'
" endif
" nmap <silent> <F7> <Plug>MarkdownPreview
" imap <silent> <F7> <Plug>MarkdownPreview
" nmap <silent> <F8> <Plug>StopMarkdownPreview
" imap <silent> <F8> <Plug>StopMarkdownPreview

" Doxygen
" let g:DoxygenToolkit_authorName="chxuan, 787280310@qq.com"
" let s:licenseTag = "Copyright(C)\<enter>"
" let s:licenseTag = s:licenseTag . "For free\<enter>"
" let s:licenseTag = s:licenseTag . "All right reserved\<enter>"
" let g:DoxygenToolkit_licenseTag = s:licenseTag
" let g:DoxygenToolkit_briefTag_funcName="yes"
" let g:doxygen_enhanced_color=1
" let g:DoxygenToolkit_commentType="Qt"
set t_Co=256  " Note: Neovim ignores t_Co and other terminal codes.
if has("termguicolors")
    " fix bug for vim
    " set t_8f=^[[38;2;%lu;%lu;%lum
    " set t_8b=^[[48;2;%lu;%lu;%lum

    " enable true color
    set termguicolors
endif
" transparent vim background
" let t:is_transparent = 0
" function! Toggle_transparent()
"     if t:is_transparent == 0
"         hi Normal guibg=NONE ctermbg=NONE
"         let t:is_transparent = 1
"     else
"         set background=dark
"         let t:is_transparent = 0
"     endif
" endfunction
" nnoremap <C-t> : call Toggle_transparent()<CR>
" }}}

