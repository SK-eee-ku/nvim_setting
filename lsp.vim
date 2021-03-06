"  mapping
function! LC_maps()
  if has_key(g:LSP_commands, &filetype)
    nnoremap <buffer> <silent> <Leader>lc     <Cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <buffer> <silent> <Leader>ld     <Cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <buffer> <silent> <Leader>lh     <Cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <buffer> <silent> <Leader>li     <Cmd>lua vim.lsp.buf.implementation()<CR>
    inoremap <buffer> <silent> <C-s>          <Cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <buffer> <silent> <Leader>lt     <Cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <buffer> <silent> <Leader>lr     <Cmd>lua vim.lsp.buf.rename()<CR>
    nnoremap <buffer> <silent> <Leader>lk     <Cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <buffer> <silent> <Leader>ls     <Cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <buffer> <silent> <Leader>lw     <Cmd>lua vim.lsp.buf.workspace_symbol()<CR>
    nnoremap <buffer> <silent> <Leader>lf     <Cmd>lua vim.lsp.buf.formatting_sync(nil, 10000)<CR>
    nnoremap <buffer> <silent> <Leader>le     <Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
  endif
endfunction

autocmd BufEnter * call LC_maps()

" dictionaryを宣言
let g:LSP_commands = {}

" それぞれの言語を追加
" 例えば、C/C++:
if executable('clangd')
  let g:LSP_commands['c'] = 'clangd'
  let g:LSP_commands['cpp'] = 'clangd'
endif

" Rust
if executable('rust-analyzer')
  let g:LSP_commands['rust'] = 'rust_analyzer'
endif

" Python
if executable('pylsp')
  let g:LSP_commands['python'] = "pylsp"
endif

" css
if executable('css-language-server')
  let g:LSP_commands['css'] = "cssls"
endif

" typescript/javascript
if executable('deno')
  let g:LSP_commands['typescript'] = "denols"
  let g:LSP_commands['javascript'] = "denols"
elseif executable('typescript-language-server')
  let g:LSP_commands['typescript'] = "tsserver"
  let g:LSP_commands['javascript'] = "tsserver"
endif

" html
if executable('vscode-html-language-server')
lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require'lspconfig'.html.setup {
  capabilities = capabilities,
}
EOF
endif

" vue
if executable("vls")
  let g:LSP_commands['vls'] = "vuels"
endif

" vim script
if executable("vim-language-server")
  let g:LSP_commands['vim'] = "vimls"
endif

" tex
if executable("texlab")
  let g:LSP_commands['tex'] = "texlab"
endif


" 追加したそれぞれの言語についてLSPコマンドを起動
lua << EOF
for key, val in pairs(vim.g.LSP_commands) do
  require('lspconfig')[val].setup {}
end
EOF

lua << EOF
-- エラー表示
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = true,
  }
)
EOF
