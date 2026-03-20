-- Generate typed code from JSON in clipboard using quicktype
local function quickType(lang)
    -- source from clipboard registry
    local buf = vim.fn.getreg('+')
    local tmp = vim.fn.tempname() .. '.json'
    local f = io.open(tmp, 'w')
    f:write(buf)
    f:close()

    local just_types = lang ~= 'typescript-zod' and ' --just-types' or ''
    local cmd = 'quicktype ' .. tmp .. ' --lang ' .. lang .. just_types .. ' 2>&1'
    local output = vim.fn.systemlist(cmd)

    if vim.v.shell_error ~= 0 then
        vim.notify(table.concat(output, '\n'), vim.log.levels.ERROR)
        return
    end
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, output)
end

vim.keymap.set('n', '<leader>pc', function()
    local currentFiletype = vim.bo.filetype

    if currentFiletype == 'go' then
        currentFileType = 'golang'
    end

    quickType(currentFiletype)
end)

vim.keymap.set('n', '<leader>pg', function() quickType('golang') end)
vim.keymap.set('n', '<leader>pt', function() quickType('typescript') end)
vim.keymap.set('n', '<leader>pz', function() quickType('typescript-zod') end)

local ok, wk = pcall(require, 'which-key')
if not ok then return {} end
wk.add({
    { '<leader>p', group = 'Paste to type' },
    { '<leader>pc', desc = 'Paste to type (current filetype)' },
    { '<leader>pg', desc = 'Paste to golang type' },
    { '<leader>pt', desc = 'Paste to typescript type' },
    { '<leader>pz', desc = 'Paste to typescript-zod type' },
})
return {}

