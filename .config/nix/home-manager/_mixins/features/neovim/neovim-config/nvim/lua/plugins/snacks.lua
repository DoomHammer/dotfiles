return {
	"snacks.nvim",
	opts = {
		terminal = {
			win = {
				position = "float",
			},
		},
		dashboard = {
			preset = {
				header = table.concat({
					"Hello, DoomHammer!",
					" ____       _   _     __     ___            ",
					"|  _ \\  ___| | | | __ \\ \\   / (_)_ __ ___  ",
					"| | | |/ _ \\ |_| |/ _` \\ \\ / /| | '_ ` _ \\ ",
					"| |_| |  __/  _  | (_| |\\ v / | | | | | | | ",
					"|____/ \\___|_| |_|\\__,_| \\_/  |_|_| |_| |_|",
				}, "\n"),
			},
			sections = {
				{ section = "header" },
				{ section = "startup" },
				{ section = "keys", gap = 1, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Recent Files",
					section = "recent_files",
					indent = 2,
					padding = 1,
				},
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						-- luacheck: push ignore 113
						return Snacks.git.get_root() ~= nil
						-- luacheck: pop
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{
					pane = 3,
					icon = " ",
					desc = "Browse Repo",
					padding = 1,
					key = "b",
					action = function()
						-- luacheck: push ignore 113
						Snacks.gitbrowse()
						-- luacheck: pop
					end,
				},
				function()
					-- luacheck: push ignore 113
					local in_git = Snacks.git.get_root() ~= nil
					-- luacheck: pop
					local cmds = {
						{
							title = "Notifications",
							cmd = "gh notify -s -a -n5",
							action = function()
								-- luacheck: push ignore 113
								vim.ui.open("https://github.com/notifications")
								-- luacheck: pop
							end,
							key = "n",
							icon = " ",
							height = 5,
							enabled = true,
						},
						{
							title = "Open Issues",
							cmd = "gh issue list -L 3",
							key = "i",
							action = function()
								-- luacheck: push ignore 113
								vim.fn.jobstart("gh issue list --web", { detach = true })
								-- luacheck: pop
							end,
							icon = " ",
							height = 7,
						},
						{
							icon = " ",
							title = "Open PRs",
							cmd = "gh pr list -L 3",
							key = "P",
							action = function()
								-- luacheck: push ignore 113
								vim.fn.jobstart("gh pr list --web", { detach = true })
								-- luacheck: pop
							end,
							height = 7,
						},
						{
							icon = " ",
							title = "Git Status",
							cmd = "git --no-pager diff --stat -B -M -C",
							height = 10,
						},
					}
					-- luacheck: push ignore 113
					return vim.tbl_map(function(cmd)
						return vim.tbl_extend("force", {
							pane = 3,
							section = "terminal",
							enabled = in_git,
							padding = 1,
							ttl = 5 * 60,
							indent = 3,
						}, cmd)
					end, cmds)
					-- luacheck: pop
				end,
			},
		},
	},
}
