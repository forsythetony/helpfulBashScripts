# Add Custom aliases here

# export PS1="\n\[\033[38;5;247m\]\w\[\033[34m\]\$(parse_git_branch)\n🍉  \[\033[0m\]"

# list all, including dot files
alias ll='ls -alG'

# find running processes, you could also just use pgrep
alias psfind="ps aux | grep"

# openssl encrypt/decrypt with des3
alias enc="openssl enc -des3"
alias encd="openssl enc -d -des3"

# openssl encrypt/decrypt with des3 returns base64 string
alias enc64="openssl enc -des3 -base64"
alias encd64="openssl enc -d -des3 -base64"

# get the lan ip for a given interface, eg en0
alias getip="ipconfig getifaddr $1"

# clear the "quicklook" cache
alias qlcache="qlmanage -r cache"

# clear your bash history
alias clearbash="history -c && rm -f ~/.bash_history"

# clear the Directory Service cache
alias clearcache="dscacheutil -flushcache"

# clear all the things 😈
alias clearall="qlcache && clearbash && clearcache && clear"
