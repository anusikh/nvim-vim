" STEPS
" pre-req: vim-plug, ripgrep
" source and run :PlugInstall to install all plugins
" install lang servers -> :CocInstall coc-java coc-json coc-tsserver coc-rust-analyzer coc-java-debug
" install debuggers -> :VimspectorInstall CodeLLDB
" for quickfix: open rg search, press tab on the item you want to add to quickfix and then press enter
" for commenting: ctrl+v, select lines, shift+i+<comment symbol>
" for un-commenting: ctrl+v, select lines (use arrow keys to move cursor if reqd), d
" for filetree use :Vexplore
 
" for java lombok support add this in coc config
" {
"   "java.jdt.ls.vmargs": "-javaagent:/home/anusikh/Downloads/lombok-1.18.28.jar",
"   "java.jdt.ls.lombokSupport.enabled": true,
"   "java.trace.server": "verbose",
"   "java.jdt.ls.java.home": "/home/anusikh/.jvem/java"
" }

" a sample .vimspector.json file for rust debugging
" {
"   "$schema": "https://puremourning.github.io/vimspector/schema/vimspector.schema.json",
"   "adapters": {
"     "CodeLLDB-localbuild": {
"       "extends": "CodeLLDB",
"       "command": [
"         "$HOME/Development/vimspector/CodeLLDB/build/adapter/codelldb",
"         "--port",
"         "${unusedLocalPort}"
"       ]
"     }
"   },
"   "configurations": {
"     "jvem -- current": {
"       "adapter": "CodeLLDB",
"       "configuration": {
"         "request": "launch",
"         "program": "cargo",
" 	    "args": ["run", "--", "current"],
"         "expressions": "native"
"       }
"     }
"   }
" }

" a sample .vimspector.json file for java debugging
" {
"   "adapters": {
"     "java-debug-server": {
"       "name": "vscode-java",
"       "port": "${AdapterPort}"
"     }
"   },
"   "configurations": {
"     "Java Attach": {
"       "default": true,
"       "adapter": "java-debug-server",
"       "configuration": {
"         "request": "attach",
"         "host": "127.0.0.1",
"         "port": "5005"
"       },
"       "breakpoints": {
"         "exception": {
"           "caught": "N",
"           "uncaught": "N"
"         }
"       }
"     }
"   }
" }
" first run the jar of a java application with command: java -jar -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 ./target/demo-0.0.1-SNAPSHOT.jar
" then simply cd to attach debugger

set encoding=utf-8
set nobackup
set nowritebackup
set number
set re=2
set mouse=a
set updatetime=300
set signcolumn=yes
set autoindent expandtab tabstop=2 shiftwidth=2
set clipboard=unnamed
set nocompatible
set backspace=indent,eol,start
set laststatus=2

call plug#begin()

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'puremourning/vimspector'

call plug#end()

" Vimspector keymaps (for .vimspector.json examples, refer vimpsector repo)
nnoremap <silent> cd :call vimspector#Launch()<CR>
nnoremap <silent> t :call vimspector#ToggleBreakpoint()<CR>
nnoremap <silent> sa :VimspectorBreakpoints<CR>
nnoremap <silent> r :VimspectorReset<CR>
" FZF and Rg keymaps
nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <C-r> :Rg<CR>
" COC keymaps (copied from coc.nvim README.md)
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
augroup mygroup
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
nmap <leader>as  <Plug>(coc-codeaction-source)
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <leader>cl  <Plug>(coc-codelens-action)
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
command! -nargs=0 Format :call CocActionAsync('format')

command! -nargs=? Fold :call     CocAction('fold', <f-args>)

command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" See: https://github.com/dansomething/coc-java-debug
function! JavaStartDebugCallback(err, port)
	execute "cexpr! 'Java debug started on port: " . a:port . "'"
	call vimspector#LaunchWithSettings({ "configuration": "Java Attach", "AdapterPort": a:port })
endfunction

function JavaRunDebugMode()
	let l:class_name = expand('%:t:r')
	execute 'AsyncRun -pos=tab -mode=term -name=' . l:class_name . ' -cwd=' . getcwd() . ' javac -g ' . l:class_name .'.java && java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=y ' . l:class_name
	tabp
endfunction

function JavaStartDebug()
	call CocActionAsync('runCommand', 'vscode.java.startDebugSession', function('JavaStartDebugCallback'))
endfunction

command -nargs=0 JavaRunDebugMode call JavaRunDebugMode()
command -nargs=0 JavaStartDebug call JavaStartDebug()
