{
  luaRc = ''
    require('fidget').setup {}
    local lsp_zero = require('lsp-zero')
    lsp_zero.on_attach(function(client, bufnr)
      lsp_zero.default_keymaps({buffer = bufnr})
    end)

    local cmp = require('cmp')
    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<tab>'] = cmp.mapping.confirm { select = true },
      },
      sources = cmp.config.sources({
        { name = 'nvim-lsp' },
        { name = 'luasnip' },
      }),
    }

    local lsp_mappings = {
      { 'gD', vim.lsp.buf.declaration },
      { 'gd', vim.lsp.buf.definition },
      { 'gi', vim.lsp.buf.implementation },
      { 'gr', vim.lsp.buf.references },
      { '[d', vim.diagnostic.goto_prev },
      { ']d', vim.diagnostic.goto_next },
      { ' ' , vim.lsp.buf.hover },
      { ' s', vim.lsp.buf.signature_help },
      { ' d', vim.diagnostic.open_float },
      { ' q', vim.diagnostic.setloclist },
      { '\\r', vim.lsp.buf.rename },
      { '\\a', vim.lsp.buf.code_action },
    }
    for i, map in pairs(lsp_mappings) do
      vim.keymap.set('n', map[1], function() map[2]() end)
    end
    vim.keymap.set('x', '\\a', function() vim.lsp.buf.code_action() end) 

    local caps = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('cmp_nvim_lsp').default_capabilities(),
      { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
    );

    require('lspconfig').nil_ls.setup {
      autostart = true,
      capabilities = caps,
      cmd = { "nil" },
      settings = {
        ['nil'] = {
          testSetting = 42,
          formatting = {
            command = { "nixpkgs-fmt" },
          },
        },
      },
    }
  '';
}
