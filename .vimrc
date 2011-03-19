" -*- encoding: utf-8 -*-
" Linmic's vimrc
" Po-Huan Lin <linmicya@gmail.com>

lang C " set msg lang to English

autocmd FileType html set omnifunc=htmlcomplete#CompleteTags " html complete
autocmd BufRead,BufNewFile *.mako set filetype=mako " mako filetype

au BufReadPost * let b:reloadcheck = 1
au BufWinEnter * if exists('b:reloadcheck') | unlet b:reloadcheck | if &mod != 0 && &fenc != "" | exe 'e! ++enc=' . &fenc | endif | endif

syntax on " syntax highlight
set hlsearch " search highlighting

set ai " auto indent -> on
set noci " display line number by default
set nosi " smart indent -> on

" auto reload vimrc when editing it in unix
if has("unix")
	autocmd! bufwritepost .vimrc source ~/.vimrc
elseif has("win32")
	so C:\Program Files (x86)\Vim\vim73\mswin.vim
	behave mswin
endif

" display line number by default
set number

" shortcut to toggle line number and column space
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

" [Python] Execute file being edited with <Shift> + e:
map <buffer> <S-e> :w<CR>:!C:\Python27\python % <CR>

filetype plugin indent on

set cursorline " highlight current row where cursor located
set cursorcolumn " highlight current column where cursor located

set ignorecase
set smartcase

set nobk " no backup
set nowb " no writebackup

set background=dark
set foldmethod=indent
set foldcolumn=2
set foldlevel=999 " expand all folds by default

" font/size setting
set gfn=Consolas:h11 gfw=MingLiU:h11

set fo+=mB " Chinese/Japanese line wrap setting (no space joining lines/wrap fix)

set nocp " no Vi thanks
set backspace=2

set noswapfile

set shiftwidth=4
set softtabstop=4
set tabstop=4

set encoding=utf-8
set fileformat=unix

set list
set listchars=tab:>-,trail:- " clearly show the diff among tabs and trailing spaces
set ambw=double " only works if enc=utf-8

color blugrine

" Omni 補完関連
" $VIMRUNTIME/autoload/htmlcomplete.vimの645行目をコメントアウントしておくとhtmlの補完が小文字になる

set completeopt=menu,preview,menuone " 補完表示設定

" TabでOmni補完及びポップアップメニューの選択
function InsertTab(is_shift)
	if pumvisible()
		return a:is_shift ? "\<C-p>" : "\<C-n>"
	endif
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k\|<\|/' " htmlで補完できるように<,/でもOmni補完関連
		return "\<tab>"
	elseif exists('&omnifunc') && &omnifunc == ''
		return a:is_shift ? "\<C-p>" : "\<C-n>"
	elseif
		return "\<C-x>\<C-o>"
	endif
endfunction

inoremap <tab> <C-r>=InsertTab(0)<CR>
" Shift-Tabはうまくいかないようだ
" inoremap <S-tab> <C-r>=InsertTab(1)<CR>

" CRでOmni確定&改行
function InsertCr()
	return pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
endfunction

inoremap <CR> <C-r>=InsertCr()<CR>

highlight CursorColumn ctermbg=DarkGray	guibg=#000040
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

map <C-T> :tabe<CR>
inoremap <C-N> <C-O>:tabe<CR>
cnoremap <C-N> <C-C>:tabe<CR>

map <C-[> :tabp<CR>
map <C-]> :tabn<CR>
map <C-D> :tabc<CR>

an 1.12 PopUp.Current\ tag\ stack :tags<CR>
an 1.57 PopUp.Find\ C\ symbol :cs find s <C-R>=expand("<cword>")<CR><CR>
an 1.57 PopUp.Find\ definition :cs find g <C-R>=expand("<cword>")<CR><CR>
an 1.57 PopUp.Find\ callee :cs find d <C-R>=expand("<cword>")<CR><CR>
an 1.57 PopUp.Find\ caller :cs find c <C-R>=expand("<cword>")<CR><CR>
an 1.57 PopUp.Find\ string :cs find t <C-R>=expand("<cword>")<CR><CR>
an 1.57 PopUp.Find\ file :cs find f <C-R>=expand("<cfile>")<CR><CR>
an 1.57 PopUp.Find\ includers :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
an 1.59 PopUp.-SEP3- <Nop>

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
