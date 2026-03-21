#===================================================================================================#
#                                                                                                   #
#  Shamelessly stolen from nikhilkmr300                                                             #
#  https://github.com/nikhilkmr300/omz-themes/blob/master/themes/matte-black-yellow-line.zsh-theme  #
#                                                                                                   #
#===================================================================================================#

# Refer https://misc.flogisoft.com/bash/tip_colors_and_formatting for the ANSI/VT100 control sequences

DEPENDENCIES=(
    "tput"
    "printf"
    "echo"
    )
dependency_problem=0
for dependency in "${DEPENDENCIES[@]}"
do
    if ! command -v "${dependency}" 1>/dev/null 2>&1
    then
        echo "${dependency} is not installed"
        dependency_problem=1
    fi
done
if [[ "dependency_problem" -ne "0" ]]
then
    echo "Failed to find all required dependencies"
    return 1
fi
unset dependency dependency_problem DEPENDENCIES

user_color=220
dir_color=220
git_branch_color=129
separator_color=236
input_color=255
error_color=94
venv_color=203
dbox_color=145

if [[ -n "${CONTAINER_ID}" ]]
then
    case ${CONTAINER_ID} in 
        ubuntu)
            user_color=100
            dir_color=100
            dbox_color=100
            ;;
        fedora)
            user_color=111
            dir_color=111
            dbox_color=111
            ;;
        *)
            user_color=145
            dir_color=145
            dbox_color=145
            ;;
    esac
fi

local __user_seq="$(tput bold)$(tput setaf "${user_color}")"
local __dir_seq="$(tput bold)$(tput setaf "${dir_color}")"
local __git_branch_seq="$(tput bold)$(tput setaf "${git_branch_color}")"
local __input_seq="$(tput bold)$(tput setaf "${input_color}")"
local __error_seq="$(tput bold)$(tput setaf "${error_color}")"

local __reset_seq="$(tput sgr0)"

# For some parts of prompt setting color through tput results in weird
# behavior
local __venv_seq="${FG[${venv_color}]}"
local __dbox_seq="${FG[${dbox_color}]}"
local __separator_seq="${FG[${separator_color}]}"

local __separator_character="─"
# Uncomment the following line to hide the virtual environment name.
export VIRTUAL_ENV_DISABLE_PROMPT=1

__print_rprompt() {
    local rprompt=""
    if [[ -n "${CONTAINER_ID}" ]]
    then
       local rprompt=" [ : %{${__dbox_seq}%}${CONTAINER_ID}%{${reset_color}%}]${rprompt}" 
    fi
    if [[ -n "${VIRTUAL_ENV_PROMPT}" ]]
    then
       local rprompt=" [󰌠 : %{${__venv_seq}%}${VIRTUAL_ENV_PROMPT}%{${reset_color}%}]${rprompt}" 
    fi
    echo -ne "${rprompt}"
}

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

PROMPT="${__separator_seq}\${(l.\$(tput cols)..${__separator_character}.)}%{${reset_color}%}
${user}:${dir} ${git_branch}${__reset_seq}
> "

RPROMPT="%{$(echotc UP 1)%}\$(__print_rprompt)%{$(echotc DOWN 1)%}"

# Unset variables that were consumed and are no longer needed
unset user
unset dir
unset git_branch
unset user_color
unset dir_color
unset git_branch_color
unset separator_color
unset input_color
unset error_color
unset venv_color
unset dbox_color

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
