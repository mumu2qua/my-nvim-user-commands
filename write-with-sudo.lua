vim.api.nvim_create_user_command('WSudo',
  function(filename)
    filename = filename.fargs[1]
    if not filename then filename = vim.fn.expand("%") end
    if not filename or #filename == 0 then
      print('No filename was provided')
      return 1
    end
    -- write buffer to temp file
    local tempfile = vim.fn.tempname()
    vim.api.nvim_exec(string.format("write! %s", tempfile), true)
    -- fill the target file with temp file's content
    -- Note: some dd implementations don't support bs=1M
    local cmd = string.format("dd if=%s of=%s bs=1048576",
      vim.fn.shellescape(tempfile),
      vim.fn.shellescape(filename))
    local password = vim.fn.inputsecret("Password: ")
    vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
    vim.fn.delete(tempfile)
    -- refresh the buffer and show the "file changed" message
    vim.cmd.checktime()
  end,
  { nargs = '?', complete = 'file', desc = 'Write with sudo' }
)

-- vim: ts=2 sts=2 sw=2 et
