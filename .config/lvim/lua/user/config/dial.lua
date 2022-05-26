local M = {}

M.config = function()
  local status_ok, dial = pcall(require, "dial")

  if not status_ok then
    return
  end

  vim.cmd [[
    nmap  <C-a>  <Plug>(dial-increment)
    nmap  <C-x>  <Plug>(dial-decrement)
    vmap  <C-a>  <Plug>(dial-increment)
    vmap  <C-x>  <Plug>(dial-decrement)
    vmap g<C-a> g<Plug>(dial-increment-additional)
    vmap g<C-x> g<Plug>(dial-decrement-additional)
  ]]

  local augend = dial.augend
  dial.config.augends:register_group {
    default = {
      augend.integer.alias.decimal,   -- nonnegative decimal number (0, 1, 2, 3, ...)
      augend.integer.alias.hex,       -- nonnegative hex number  (0x01, 0x1a1f, etc.)
      augend.date.alias["%Y/%m/%d"],  -- date (2022/02/19, etc.)
      augend.date.alias["%Y-%m-%d"],
      augend.date.alias["%m/%d"],
      augend.date.alias["%H:%M"],
      augend.hexcolor.new {
        case = "lower"
      },
      augend.constant.new {
        elements = { "and", "or" },
        word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
        cyclic = true, -- "or" is incremented into "and".
      },
      augend.constant.new {
        elements = { "&&", "||" },
        word = false,
        cyclic = true,
      },
      augend.constant.new {
        elements = { "true", "false" },
        word = true,
        cyclic = true
      },
      augend.constant.new {
        elements = { "True", "False" },
        word = true,
        cyclic = true
      }
    }
  }
end

return M
