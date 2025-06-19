let s:prefix = ';'

" Use ctrl + h/j/k/l to move between panes
let s:movement_keys = ['h', 'j', 'k', 'l']
for key in s:movement_keys
    let lhs = '<C-' . key . '>'
    let rhs = '<C-w>' . key
    execute 'nnoremap '. lhs . ' ' . rhs
    execute 'inoremap '. lhs . ' <C-\><C-N>' . rhs
endfor

" Buffer navigation
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <C-s> :b#<CR>

" Surround selection with parentheses or quotes
vnoremap (( "sc(<C-r>s)<Esc>
vnoremap "" "sc"<C-r>s"<Esc>

" NERDTree keymaps
if !exists(':NvimTreeToggle')
    if exists(':NERDTreeToggle')
        execute 'nnoremap ' . s:prefix . 't :NERDTreeToggle<CR>'
        execute 'nnoremap ' . s:prefix . 'f :NERDTreeFind<CR>'
    end
end

command! Bd enew | bd #

nnoremap tp :tabprev<CR>
nnoremap tn :tabnext<CR>
nnoremap tt :tabnew<CR>
