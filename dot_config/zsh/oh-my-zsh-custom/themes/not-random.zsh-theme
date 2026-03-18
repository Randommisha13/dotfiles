#===================================================================================================#
#                                                                                                   #
#  Shamelessly stolen from nikhilkmr300                                                             #
#  https://github.com/nikhilkmr300/omz-themes/blob/master/themes/matte-black-yellow-line.zsh-theme  #
#                                                                                                   #
#===================================================================================================#

# Refer https://misc.flogisoft.com/bash/tip_colors_and_formatting for the ANSI/VT100 control sequences

user_color=220
dir_color=220
git_branch_color=129
line_color=236
input_color=255
error_color=94

local __user_seq="$(tput bold)$(tput setaf "${user_color}")"
local __dir_seq="$(tput bold)$(tput setaf "${dir_color}")"
local __git_branch_seq="$(tput bold)$(tput setaf "${git_branch_color}")"
local __line_seq="$(tput setaf "${line_color}")"
local __input_seq="$(tput bold)$(tput setaf "${input_color}")"
local __error_seq="$(tput bold)$(tput setaf "${error_color}")"

local __reset_seq="$(tput sgr0)"

local __line_character="─"
# Uncomment the following line to hide the virtual environment name.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Number of columns to leave free for virtual environment name. You can set this
# so that the dashes cover the width of the screen.
# prompt_buffer=0

# User details in bold
local user='%{${__user_seq}%}%n@%m%{${__reset_seq}%}'
# Directory details in bold
local dir='%{${__dir_seq}%}%~%{${__reset_seq}%}'
# git branch details
# Function because I want parentheses
__get_git_prompt() {
    if [[ -n "$(git_current_branch)" ]]
    then
        echo -ne "($(git_current_branch))"
    fi
}
local git_branch='%{${__git_branch_seq}%}$(__get_git_prompt)%{${__reset_seq}%}'

# Unlike original, this gets called every time we display prompt
# Tries to detect changes in first line of prompt, if it is longer than
# expected, corrects itself to fill all the remaining columns
__print_line() {
    prompt_length="$(echo "${PROMPT}" | cut --delimiter="
" --fields 1 | wc --chars)" 
    local line_width="$(( $(tput cols) + __normal_prompt_length - prompt_lenth ))"

    # printf prints pattern for every input string. In this case, '%.0s' causes
    # printf to print 0 digits of the inputted number(s), effectively printing
    # '-' $line_width times
    local separator_line="$(printf -- "${__line_character}%.0s" $(seq "${line_width}"))"
    echo -e "${__line_seq}${separator_line}${__reset_seq}"

    # For some reason twelve extra characters get dumped into $PROMPT after
    # the first time it's called, I have no idea why
}

# Refer: https://stackoverflow.com/questions/263890/how-do-i-find-the-width-height-of-a-terminal-window
PROMPT="\$(__print_line)
${user}:${dir} ${git_branch}${__reset_seq}
> "

__normal_prompt_length="$(echo "${PROMPT}" | cut --delimiter="
" --fields 1 | wc --chars)" 

# For some reason prompt gets extended by 16 (presumably control) characters
# somewhere after first invocation and before second invocation
__normal_prompt_length="$((__normal_prompt_length - 16))"

# Unset variables that were consumed and are no longer needed
unset user
unset dir
unset git_branch
unset user_color
unset dir_color
unset git_branch_color
unset line_color
unset input_color

precmd()
{
    last_cmd_status="${?}"

    echo -n "\n"

    if [[ "${last_cmd_status}" -ne "0" ]]
    then
        echo -e "${__error_seq}Exited with status ${last_cmd_status}${__reset_seq}"
    fi
}

# Resetting color to default white.
# preexec() {
#     echo -ne "${__reset_seq}"
# }
