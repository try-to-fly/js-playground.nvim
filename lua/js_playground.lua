local api = vim.api

-- 存储窗口和缓冲区ID
local js_playground_win = nil
local js_playground_buf = nil

-- 创建或复用右侧窗口
local function create_or_reuse_right_window()
	if js_playground_win and api.nvim_win_is_valid(js_playground_win) then
		return js_playground_buf, js_playground_win
	end

	local width = vim.o.columns
	local height = vim.o.lines

	local win_width = math.floor(width * 0.4)
	local win_height = height - 2

	local opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = 1,
		col = width - win_width,
		style = "minimal",
		border = "single",
	}

	js_playground_buf = api.nvim_create_buf(false, true)
	js_playground_win = api.nvim_open_win(js_playground_buf, true, opts)

	return js_playground_buf, js_playground_win
end

-- 运行当前文件的JS代码并显示输出

local function run_js_code()
	local current_file = vim.fn.expand("%:p")
	local start_time = vim.loop.hrtime()
	local cmd = "node " .. current_file .. " 2>&1"
	local output = vim.fn.system(cmd)
	local end_time = vim.loop.hrtime()
	local elapsed_ms = (end_time - start_time) / 1e6

	-- 创建或复用窗口
	local buf, win = create_or_reuse_right_window()

	-- 设置缓冲区内容为输出结果
	api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, "\n"))

	-- 设置缓冲区的文件类型为JavaScript以启用语法高亮
	api.nvim_buf_set_option(buf, "filetype", "javascript")

	-- 使用通知显示执行耗时
	vim.notify(string.format("JS Playground - Elapsed: %.2f ms", elapsed_ms), vim.log.levels.INFO)
end
-- 绑定命令和自动命令
local function setup_autocmds()
	api.nvim_exec(
		[[
        augroup JsPlayground
            autocmd!
            autocmd BufWritePost *.js lua require('js_playground').run_js_code_if_window_exists()
        augroup END
    ]],
		false
	)
end

-- 只有在窗口存在时才运行JS代码
local function run_js_code_if_window_exists()
	if js_playground_win and api.nvim_win_is_valid(js_playground_win) then
		run_js_code()
	end
end

-- 公开的接口
local M = {}
M.run_js_code = run_js_code
M.setup_autocmds = setup_autocmds
M.run_js_code_if_window_exists = run_js_code_if_window_exists

return M
