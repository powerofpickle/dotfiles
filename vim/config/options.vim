" Disable intro message when vim starts
set shortmess+=I

" Enhance command completion
set wildmenu
set wildmode=longest:full,full

" Show relative numbers when buffer is focused, otherwise show absolute numbers
set number
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

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

