local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function new_entry(value, lnum)
  return {
    value = value,
    display = value,
    ordinal = value,
    lnum = lnum,
  }
end

local function list_matches(pattern, format)
  local output = {}

  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    local matches = { line:match(pattern) }

    if matches[1] then
      table.insert(output, new_entry(format(unpack(matches)), lnum))
    end
  end

  return output
end

--- Parse the current buffer for Terraform resources and return resource type/name entries.
local function list_terraform_resources()
  return list_matches('^%s*resource%s+"([^"]+)"%s+"([^"]+)"', function(resource_type, resource_name)
    return resource_type .. "." .. resource_name
  end)
end

--- Parse the current buffer for Terraform variables and return variable name entries.
local function list_terraform_variables()
  return list_matches('^%s*variable%s+"([^"]+)"', function(variable_name)
    return variable_name
  end)
end

-- Display output in Telescope and handle selection
local function show_in_telescope(output, opts)
  opts = opts or {}

  if not output or vim.tbl_isempty(output) then
    vim.notify(opts.empty_message or "No Terraform blocks found.", vim.log.levels.INFO)
    return
  end

  pickers
    .new({}, {
      prompt_title = opts.prompt_title or "Terraform",
      finder = finders.new_table({
        results = output,
        entry_maker = function(entry)
          return entry
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)

          local selection = action_state.get_selected_entry()
          if selection then
            vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
          end
        end)

        return true
      end,
    })
    :find()
end

local function list_tf_resources_command()
  show_in_telescope(list_terraform_resources(), {
    prompt_title = "Terraform Resources",
    empty_message = "No Terraform resources found.",
  })
end

local function list_tf_variables_command()
  show_in_telescope(list_terraform_variables(), {
    prompt_title = "Terraform Variables",
    empty_message = "No Terraform variables found.",
  })
end

-- Create Neovim command
vim.api.nvim_create_user_command("TFResources", list_tf_resources_command, { force = true })
vim.api.nvim_create_user_command("TFVariables", list_tf_variables_command, { force = true })

return {
  list_terraform_resources = list_terraform_resources,
  list_terraform_variables = list_terraform_variables,
}
