# .bash_profile

# get the aliases and functions
#
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Upstart magic tool
#
[[ -e ~/.umt/umt-profile ]] && source ~/.umt/umt-profile

# user specific environment and startup programs
#
export PATH=${HOME}/.local/bin:${HOME}/bin:${PATH}
