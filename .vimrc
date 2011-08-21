" -*- encoding: utf-8 -*-
" Linmic's vimrc
" Po-Huan Lin <linmicya@gmail.com>

set nocp " no vi
lang C " set msg lang to English

filetype plugin indent on
set ai " auto indent
set noci " no copyindent
set nosi " no smart indent

au BufRead,BufNewFile *.mako set ft=mako syntax=html
au BufRead,BufNewFile *.css set ft=css syntax=css3

"  ensure BufWinEnter is only done on initial buffer read
au BufReadPost * let b:reloadcheck = 1
au BufWinEnter * if exists('b:reloadcheck') | unlet b:reloadcheck | if &mod != 0 && &fenc != "" | exe 'e! ++enc=' . &fenc | endif | endif

syntax on " syntax highlight
set hlsearch " search highlighting

" auto reload vimrc when editing it in unix
if has("unix")
	au! bufwritepost .vimrc source $HOME/.vimrc
elseif has("win32")
	au! bufwritepost .vimrc source $VIM/_vimrc
	so $VIMRUNTIME/mswin.vim
	behave mswin
endif

if has("gui_running")
	" GUI is running or is about to start.
	" Maximize gvim window.
	set lines=40 columns=150
endif

set guifont=Monaco:h16

" <F5> for python to compile current file
command! Py call s:Py()
nmap <F5> :Py<CR>
function! s:Py()
	:w
	:!python %
endfunction

set number " show line number

" shortcut to toggle line number and column space
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

set cursorline " highlight current row where cursor located
set cursorcolumn " highlight current column where cursor located

set ignorecase
set smartcase

set nobk " no backup
set nowb " no writebackup

set foldmethod=indent
set foldcolumn=2
set foldlevel=999 " expand all folds by default

set fo+=mB " Chinese/Japanese line wrap setting (no space joining lines/wrap fix)

set backspace=2

"set noswf " no swap

set sw=4 sts=4 ts=4
autocmd BufRead *.py set et

set enc=utf-8
set fenc=utf-8
set ff=unix

set list
set listchars=tab:>-,trail:- " clearly show the diff among tabs and trailing spaces
set ambw=double " only works if enc=utf-8

color blugrine

" Omni補完関連 =======================================================
" $VIMRUNTIME/autoload/htmlcomplete.vimの645行目をコメントアウントしておくとhtmlの補完が小文字になる
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1 " autocomplete with .
let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
let OmniCpp_MayCompleteScope = 1 " autocomplete with ::

au FileType html set omnifunc=htmlcomplete#CompleteTags " html completeopt
au FileType python set omnifunc=pythoncomplete#Complete " python complete
set completeopt=menu,preview,menuone " 補完表示設定

" TabでOmni補完及びポップアップメニューの選択
function InsertTabWrapper(is_shift)
	if pumvisible()
		return a:is_shift ? "\<C-p>" : "\<C-n>"
	endif
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k\|<\|/' " htmlで補完できるように<,/でもOmni補完
		return "\<tab>"
	elseif exists('&omnifunc') && &omnifunc == ''
		return a:is_shift ? "\<C-p>" : "\<C-n>"
	else
		return "\<C-x>\<C-o>"
	endif
endfunction
inoremap <tab> <C-r>=InsertTabWrapper(0)<CR>
" Shift-Tabはうまくいかないようだ
" inoremap <S-tab> <C-r>=InsertTabWrapper(1)<CR>

" CRでOmni確定&改行
function InsertCrWrapper()
	return pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
endfunction
inoremap <CR> <C-r>=InsertCrWrapper()<CR>

set completeopt=menu,preview,menuone " 補完表示設定

highlight CursorColumn ctermbg=DarkGray guibg=#000040
highlight CursorLine ctermbg=DarkGray guibg=#003000
highlight FoldColumn ctermbg=Black ctermfg=Cyan guibg=Black guifg=Cyan
highlight Folded ctermbg=Black ctermfg=Cyan guibg=Black guifg=Cyan
highlight LineNr ctermbg=Black ctermfg=LightGreen guibg=Black guifg=LightGreen
highlight SpecialKey ctermfg=DarkGray guifg=#404040

let html_use_css = 1
let use_xhtml = 1
let python_highlight_all = 1

map <F3> :Search 
map <silent> <S-F3> :SearchReset<CR>
map <silent> <F4> :TlistToggle<CR>

"map <C-T> :tabedit<CR>
"inoremap <C-N> <C-O>:tabedit<CR>
"cnoremap <C-N> <C-C>:tabedit<CR>
"map <C-[> :tabprevious<CR>
"map <C-]> :tabnext<CR>
"map <C-D> :tabclose<CR>

"an 1.12 PopUp.Current\ tag\ stack :tags<CR>
"an 1.57 PopUp.Find\ C\ symbol :cs find s <C-R>=expand("<cword>")<CR><CR>
"an 1.57 PopUp.Find\ definition :cs find g <C-R>=expand("<cword>")<CR><CR>
"an 1.57 PopUp.Find\ callee :cs find d <C-R>=expand("<cword>")<CR><CR>
"an 1.57 PopUp.Find\ caller :cs find c <C-R>=expand("<cword>")<CR><CR>
"an 1.57 PopUp.Find\ string :cs find t <C-R>=expand("<cword>")<CR><CR>
"an 1.57 PopUp.Find\ file :cs find f <C-R>=expand("<cfile>")<CR><CR>
"an 1.57 PopUp.Find\ includers :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"an 1.59 PopUp.-SEP3- <Nop>

if has("cscope")
	set cscopetag " :cstag by default than :tag
	set csto=0 " search cscope db first

	if filereadable("cscope.out")
		cs add cscope.out
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif

	set cscopeverbose " make success/fail msg printed
endif

"ctags Source Explorer(srcexpl.vim)設定
"自動(#vimrcに追加。自動表示するまでの時間)
let g:SrcExpl_RefreshTime = 1

"tagsをsrcexpl起動時に自動で作成（更新）するかどうか
let g:SrcExpl_UpdateTags = 1

" leader for the javascript beautifier
let mapleader = ","
