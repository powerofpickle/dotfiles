" Disable intro message when vim starts
set shortmess+=I

" Enhance command completion
set wildmenu
set wildmode=longest:full,full

" Set timeout for mappings to 500ms
"set timeoutlen=500
" Set timeout for terminal key codes to 10ms
"set ttimeoutlen=50

" Show relative numbers when buffer is focused, otherwise show absolute numbers
set number
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" https://stackoverflow.com/questions/19320747/prevent-vim-from-indenting-line-when-typing-a-colon-in-python
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

autocmd FileType c,cpp setlocal cinkeys-=:

" colorschemes in order of preference
let colorschemes = [
    \ 'catppuccin-macchiato',
    \ 'base16-ocean',
    \ 'default'
\ ]

function! s:set_colorscheme(colorschemes) abort
  for colorscheme in a:colorschemes
      try
          execute 'colorscheme ' . colorscheme
          "echo "Using colorscheme: " . colorscheme
          return
      catch /^Vim\%((\a\+)\)\=:E185/
          " Ignore the error and continue to the next colorscheme
      endtry
  endfor
  "echo "No preferred colorscheme found, using default."
endfunction

call s:set_colorscheme(colorschemes)

augroup CustomFileTypes
    autocmd!
    autocmd BufReadPost,BufNewFile *.h.inc,*.cpp.inc set filetype=cpp
    autocmd BufReadPost,BufNewFile *.c.inc set filetype=c
augroup END

if exists(':Copilot')
    " Disable copilot by default
    let g:copilot_enabled = v:false
end
