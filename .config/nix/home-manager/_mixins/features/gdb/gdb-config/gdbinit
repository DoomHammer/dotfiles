# Saving history by default
set history filename ~/.gdb_history
set history save

# No need to set the window size as scrolling should be enabled
set height 0
set width 0

# Pretty printing of structures
set print pretty

# Allow setting pending breakpoints
set breakpoint pending on

# Tell GDB you know what you are doing
set confirm off


#------------------------------------------------------------------------------
# Functions.
# Courtesy of https://github.com/s3rvac/dotfiles/blob/master/gdb/.gdbinit
#------------------------------------------------------------------------------

# Disable TUI.
define dt
	tui disable
end

# Enable TUI.
define et
	tui enable
	# Display the source and assembly window.
	layout split
	# Switch focus to the command window so that arrow keys work as expected
	# (history up/down and movement on the command line instead of movement in
	# the source-code window).
	focus cmd
end

#------------------------------------------------------------------------------
# Aliases.
#------------------------------------------------------------------------------

# Refreshes the screen (e.g. after the output from the debugged program has
# cluttered the screen).
alias -a rf = refresh
