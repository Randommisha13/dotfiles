#===================================================================================================#
#                                                                                                   #
#  Shamelessly stolen from nikhilkmr300                                                             #
#  https://github.com/nikhilkmr300/omz-themes/blob/master/themes/matte-black-yellow-line.zsh-theme  #
#                                                                                                   #
#===================================================================================================#

# Refer https://misc.flogisoft.com/bash/tip_colors_and_formatting for the ANSI/VT100 control sequences

local __ohmyzsh_theme__user_color=220
local __ohmyzsh_theme__dir_color=220
local __ohmyzsh_theme__git_branch_color=129
local __ohmyzsh_theme__line_color=236
local __ohmyzsh_theme__input_color=255

# Uncomment the following line to hide the virtual environment name.
# export VIRTUAL_ENV_DISABLE_PROMPT=1

# Number of columns to leave free for virtual environment name. You can set this
# so that the dashes cover the width of the screen.
prompt_buffer=0

# User details in bold
local user='%B$FG[${__ohmyzsh_theme__user_color}]%}%n@%m%{$reset_color%}'
# Directory details in bold
local dir='%B$FG[${__ohmyzsh_theme__dir_color}]%~%{$reset_color%}'
# git branch details
# Function because I want parentheses
__ohmyzsh_theme__get_git_prompt() {
    if [[ -n "$(git_current_branch)" ]]
    then
        echo -ne "($(git_current_branch))"
    fi
}
local git_branch='$FG[${__ohmyzsh_theme__git_branch_color}]$(__ohmyzsh_theme__get_git_prompt)%{$reset_color%}'


# Error message on command returning non-zero exit code
__ohmyzsh_theme__error_msg="\e[0;31mCommand failed\e[0m"

# Prints the separator line between two prompts, adjusted for the length of the
# name of the current virtual environment.
# Refer the 88/256 colors section on this webpage: https://misc.flogisoft.com/bash/tip_colors_and_formatting
__ohmyzsh_theme__line_color_sequence="\e[38;5;${__ohmyzsh_theme__line_color}m"

# Extra 12 symbols that appear only when we call function
__ohmyzsh_theme__normal_prompt_lenght=$(( $(echo -n '$(__ohmyzsh_theme__print_line)' | wc --chars) + 12 ))

# Unlike original, this gets called every time we display prompt
# Tries to detect changes in first line of prompt, if it is longer than
# expected, corrects itself to fill all the remaining columns
__ohmyzsh_theme__print_line() {
    local dash="${__ohmyzsh_theme__line_color_sequence}─\e[0m"
    local buffer=$prompt_buffer
    local prompt_parts=("${(@f)${PROMPT}}")
    if [[ $(echo -n "${prompt_parts[1]}" | wc --chars) \
        -gt $(echo -n '123456789012$(__ohmyzsh_theme__print_line)' | wc --chars) ]]
    then
        local buffer=$(( $(echo -n "${prompt_parts[1]}" | wc --chars) \
            - __ohmyzsh_theme__normal_prompt_lenght ))
    fi
    for i in {1..$((COLUMNS-buffer))}
    do
        echo -ne $dash
    done
}

# Refer: https://stackoverflow.com/questions/263890/how-do-i-find-the-width-height-of-a-terminal-window
PROMPT="\$(__ohmyzsh_theme__print_line)
${user}:${dir} ${git_branch}
> $FG[${__ohmyzsh_theme__input_color}]"

# Unset variables that were consumed and are no longer needed
unset user
unset dir
unset git_branch

# Resetting color to default white.
preexec()
{
    echo -ne "\e[0m"
}

# Printing error message if command failed.
precmd()
{
    echo -n "\n"
    # Command failed
    if [ $? -ne 0 ];
    then
        echo "${__ohmyzsh_theme__error_msg}"
    fi
}
